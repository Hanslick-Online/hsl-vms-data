#!/usr/bin/env python3

from __future__ import annotations

import argparse
import copy
import re
import sys
import unicodedata
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from difflib import SequenceMatcher
from functools import lru_cache
from pathlib import Path
from typing import Iterable
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen


TEI_NS = "http://www.tei-c.org/ns/1.0"
XML_NS = "http://www.w3.org/XML/1998/namespace"
NS = {"tei": TEI_NS}
XML_ID = f"{{{XML_NS}}}id"
INF_NEG = -10**9

ET.register_namespace("", TEI_NS)

DEFAULT_REFERENCE = Path(
    "102_derived_tei/102_02_tei-simple_refactored/01_VMS_1854_TEI_AW_26-01-21-TEI-P5.xml"
)
DEFAULT_OUTPUT = Path("102_derived_tei/102_03_collation_docs.xml")
DEFAULT_BASE_URL = "https://raw.githubusercontent.com/Hanslick-Online/hsl-vms-docs/main/data/editions"


@dataclass(frozen=True)
class DocSpec:
    source_file: str
    output_id: str
    output_target: str
    label: str
    sort_key: float


@dataclass(frozen=True)
class Paragraph:
    text: str
    anchor: str


DOC_SPECS = (
    DocSpec(
        source_file="1853_Hanslick_UeberdensubjektivenEindruckderMusik_1.xml",
        output_id="d__Hanslick_UeberdensubjektivenEindruckderMusik_1.xml",
        output_target="d__Hanslick_UeberdensubjektivenEindruckderMusik_1.html",
        label="Dok 1853 I",
        sort_key=0.1,
    ),
    DocSpec(
        source_file="1853_Hanslick_UeberdensubjektivenEindruckderMusik_2.xml",
        output_id="d__Hanslick_UeberdensubjektivenEindruckderMusik_2.xml",
        output_target="d__Hanslick_UeberdensubjektivenEindruckderMusik_2.html",
        label="Dok 1853 II",
        sort_key=0.2,
    ),
    DocSpec(
        source_file="1853_Hanslick_UeberdensubjektivenEindruckderMusik_3.xml",
        output_id="d__Hanslick_UeberdensubjektivenEindruckderMusik_3.xml",
        output_target="d__Hanslick_UeberdensubjektivenEindruckderMusik_3.html",
        label="Dok 1853 III",
        sort_key=0.3,
    ),
    DocSpec(
        source_file="1854_Hanslick_DieTonkunstinihrenBeziehungenzurNatur.xml",
        output_id="d__Hanslick_DieTonkunstinihrenBeziehungenzurNatur_1.xml",
        output_target="d__Hanslick_DieTonkunstinihrenBeziehungenzurNatur_1.html",
        label="Dok 1854",
        sort_key=0.4,
    ),
)


def tei(tag: str) -> str:
    return f"{{{TEI_NS}}}{tag}"


def normalize_space(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def canonical_text(text: str) -> str:
    text = unicodedata.normalize("NFKD", text)
    text = "".join(ch for ch in text if not unicodedata.combining(ch))
    text = text.lower().replace("ß", "ss")
    replacements = (
        ("princip", "prinzip"),
        ("compon", "kompon"),
        ("phantasie", "fantasie"),
        ("thon", "ton"),
        ("that", "tat"),
        ("thatigkeit", "tatigkeit"),
        ("ae", "a"),
        ("oe", "o"),
        ("ue", "u"),
    )
    for old, new in replacements:
        text = text.replace(old, new)
    text = re.sub(r"[^a-z0-9]+", " ", text)
    return normalize_space(text)


def collect_text(element: ET.Element) -> str:
    if element.tag == tei("note"):
        return ""
    parts: list[str] = []
    if element.text:
        parts.append(element.text)
    for child in element:
        parts.append(collect_text(child))
        if child.tail:
            parts.append(child.tail)
    return "".join(parts)


def paragraph_text(element: ET.Element) -> str:
    return normalize_space(collect_text(element))


def similarity(left: str, right: str) -> float:
    sequence_ratio = SequenceMatcher(None, left, right).ratio()
    left_tokens = set(left.split())
    right_tokens = set(right.split())
    union = left_tokens | right_tokens
    token_ratio = 1.0 if not union else len(left_tokens & right_tokens) / len(union)
    return sequence_ratio * 0.7 + token_ratio * 0.3


def fetch_root(base_url: str, spec: DocSpec) -> ET.Element:
    url = f"{base_url.rstrip('/')}/{spec.source_file}"
    request = Request(url, headers={"User-Agent": "hsl-vms-data-collation-fetcher"})
    try:
        with urlopen(request) as response:
            return ET.fromstring(response.read())
    except (HTTPError, URLError) as exc:
        raise RuntimeError(f"Failed to fetch {url}: {exc}") from exc


def body_paragraphs(root: ET.Element) -> list[Paragraph]:
    paragraphs: list[Paragraph] = []
    for element in root.findall(f".//{tei('body')}//{tei('p')}"):
        text = paragraph_text(element)
        if not text:
            continue
        anchor = element.get(XML_ID, "")
        paragraphs.append(Paragraph(text=text, anchor=anchor))
    return paragraphs


def reference_paragraphs(reference_path: Path) -> list[tuple[str, str]]:
    root = ET.parse(str(reference_path)).getroot()
    items: list[tuple[str, str]] = []
    for element in root.findall(f".//{tei('body')}//{tei('p')}"):
        key = element.get("n", "").strip()
        if not (key.startswith("4.") or key.startswith("5.") or key.startswith("6.")):
            continue
        text = paragraph_text(element)
        if key and text:
            items.append((key, text))
    if not items:
        raise RuntimeError(f"No chapter 4-6 reference paragraphs found in {reference_path}")
    return items


def align_doc(paragraphs: list[Paragraph], references: list[tuple[str, str]]) -> tuple[float, list[tuple[int, int, int, float]]]:
    paragraph_texts = [canonical_text(item.text) for item in paragraphs]
    reference_texts = [canonical_text(text) for _, text in references]

    @lru_cache(maxsize=None)
    def solve(paragraph_index: int, reference_index: int) -> tuple[float, tuple[tuple[int, int, int, float], ...]]:
        if paragraph_index == len(paragraph_texts) and reference_index == len(reference_texts):
            return 0.0, ()
        if reference_index >= len(reference_texts):
            return INF_NEG, ()

        remaining_paragraphs = len(paragraph_texts) - paragraph_index
        remaining_references = len(reference_texts) - reference_index
        if remaining_paragraphs > remaining_references * 3:
            return INF_NEG, ()

        best_score = INF_NEG
        best_path: tuple[tuple[int, int, int, float], ...] = ()

        if remaining_paragraphs <= (remaining_references - 1) * 3:
            next_score, next_path = solve(paragraph_index, reference_index + 1)
            total_score = next_score - 0.35
            if total_score > best_score:
                best_score = total_score
                best_path = ((paragraph_index, paragraph_index, reference_index, 0.0),) + next_path

        max_group = min(3, remaining_paragraphs)
        for group_size in range(1, max_group + 1):
            if remaining_paragraphs - group_size > (remaining_references - 1) * 3:
                continue
            merged = " ".join(paragraph_texts[paragraph_index : paragraph_index + group_size])
            ratio = similarity(merged, reference_texts[reference_index])
            next_score, next_path = solve(paragraph_index + group_size, reference_index + 1)
            total_score = ratio - (group_size - 1) * 0.02 + next_score
            if total_score > best_score:
                best_score = total_score
                best_path = ((paragraph_index, paragraph_index + group_size, reference_index, ratio),) + next_path

        return best_score, best_path

    score, path = solve(0, 0)
    if score <= INF_NEG / 2:
        raise RuntimeError("Could not align document slice to the requested VMS paragraph range")
    return score, list(path)


def plan_alignment(documents: list[list[Paragraph]], references: list[tuple[str, str]]) -> list[tuple[int, int, list[tuple[int, int, int, float]], float]]:
    alignment_cache: dict[tuple[int, int, int], tuple[float, list[tuple[int, int, int, float]]]] = {}

    def slice_alignment(doc_index: int, reference_start: int, reference_end: int) -> tuple[float, list[tuple[int, int, int, float]]]:
        key = (doc_index, reference_start, reference_end)
        if key not in alignment_cache:
            alignment_cache[key] = align_doc(documents[doc_index], references[reference_start:reference_end])
        return alignment_cache[key]

    @lru_cache(maxsize=None)
    def solve(doc_index: int, reference_start: int) -> tuple[float, tuple[tuple[int, int, tuple[tuple[int, int, int, float], ...], float], ...]]:
        if doc_index == len(documents) - 1:
            score, path = slice_alignment(doc_index, reference_start, len(references))
            return score, ((reference_start, len(references), tuple(path), score),)

        document_length = len(documents[doc_index])
        remaining_documents = documents[doc_index + 1 :]
        remaining_reference_min = sum(max(1, len(items) - 3) for items in remaining_documents)
        remaining_reference_max = sum(len(items) for items in remaining_documents)
        min_end = max(reference_start + max(1, document_length - 3), len(references) - remaining_reference_max)
        max_end = min(reference_start + document_length, len(references) - remaining_reference_min)

        best_score = INF_NEG
        best_plan: tuple[tuple[int, int, tuple[tuple[int, int, int, float], ...], float], ...] = ()

        for reference_end in range(min_end, max_end + 1):
            try:
                score_here, path_here = slice_alignment(doc_index, reference_start, reference_end)
            except RuntimeError:
                continue
            score_next, plan_next = solve(doc_index + 1, reference_end)
            total_score = score_here + score_next
            if total_score > best_score:
                best_score = total_score
                best_plan = ((reference_start, reference_end, tuple(path_here), score_here),) + plan_next

        if best_score <= INF_NEG / 2:
            return INF_NEG, ()
        return best_score, best_plan

    score, plan = solve(0, 0)
    if score <= INF_NEG / 2:
        raise RuntimeError("Could not derive a stable document-to-VMS alignment plan")
    return [(start, end, list(path), item_score) for start, end, path, item_score in plan]


def copy_optional(parent: ET.Element, source: ET.Element | None) -> None:
    if source is not None:
        parent.append(copy.deepcopy(source))


def first_node(nodes: Iterable[ET.Element]) -> ET.Element | None:
    for node in nodes:
        return node
    return None


def safe_id(value: str) -> str:
    cleaned = re.sub(r"[^A-Za-z0-9]+", "_", value).strip("_")
    return cleaned or "witness"


def build_witness(
    spec: DocSpec,
    source_root: ET.Element,
    paragraphs: list[Paragraph],
    references: list[tuple[str, str]],
    plan: tuple[int, int, list[tuple[int, int, int, float]], float],
) -> ET.Element:
    reference_start, reference_end, path, _ = plan
    tei_root = ET.Element(tei("TEI"))
    tei_root.set(XML_ID, spec.output_id)

    header = ET.SubElement(tei_root, tei("teiHeader"))
    file_desc = ET.SubElement(header, tei("fileDesc"))
    title_stmt = ET.SubElement(file_desc, tei("titleStmt"))

    title_node = first_node(
        node for node in source_root.findall(f".//{tei('titleStmt')}/{tei('title')}") if node.get("type") == "main"
    )
    if title_node is None:
        title_node = first_node(source_root.findall(f".//{tei('titleStmt')}/{tei('title')}"))
    title = ET.SubElement(title_stmt, tei("title"))
    title.text = paragraph_text(title_node) if title_node is not None else spec.label

    author_node = source_root.find(f".//{tei('titleStmt')}/{tei('author')}")
    copy_optional(title_stmt, author_node)

    publication_stmt = ET.SubElement(file_desc, tei("publicationStmt"))
    note = ET.SubElement(publication_stmt, tei("p"))
    note.text = "Derived collation witness fetched from Hanslick-Online/hsl-vms-docs."

    label_idno = ET.SubElement(publication_stmt, tei("idno"), type="collation-label")
    label_idno.text = spec.label
    sort_idno = ET.SubElement(publication_stmt, tei("idno"), type="collation-sort")
    sort_idno.text = f"{spec.sort_key:.1f}"
    target_idno = ET.SubElement(publication_stmt, tei("idno"), type="collation-target")
    target_idno.text = spec.output_target

    source_desc_node = source_root.find(f".//{tei('sourceDesc')}")
    if source_desc_node is not None:
        file_desc.append(copy.deepcopy(source_desc_node))
    else:
        source_desc = ET.SubElement(file_desc, tei("sourceDesc"))
        source_desc_p = ET.SubElement(source_desc, tei("p"))
        source_desc_p.text = spec.source_file

    encoding_desc = ET.SubElement(header, tei("encodingDesc"))
    editorial_decl = ET.SubElement(encoding_desc, tei("editorialDecl"))
    editorial_p = ET.SubElement(editorial_decl, tei("p"))
    editorial_p.text = (
        "Paragraph numbers were assigned by monotonic text alignment against the first VMS edition "
        "for the chapter 4-6 collation test branch."
    )

    text = ET.SubElement(tei_root, tei("text"))
    body = ET.SubElement(text, tei("body"))
    div = ET.SubElement(body, tei("div"), type="collation", subtype="prepublication")

    reference_slice = references[reference_start:reference_end]
    witness_id = safe_id(spec.output_id)
    for position, (paragraph_start, paragraph_end, reference_index, _) in enumerate(path, start=1):
        if paragraph_start == paragraph_end:
            continue
        key, _ = reference_slice[reference_index]
        segment = ET.SubElement(div, tei("p"))
        segment.set(XML_ID, f"{witness_id}_{position}")
        segment.set("n", key)
        anchor = next((item.anchor for item in paragraphs[paragraph_start:paragraph_end] if item.anchor), "")
        if anchor:
            segment.set("corresp", f"#{anchor}")
        segment.text = normalize_space(" ".join(item.text for item in paragraphs[paragraph_start:paragraph_end]))

    return tei_root


def build_corpus(
    specs: tuple[DocSpec, ...],
    roots: list[ET.Element],
    documents: list[list[Paragraph]],
    references: list[tuple[str, str]],
    plan: list[tuple[int, int, list[tuple[int, int, int, float]], float]],
) -> ET.ElementTree:
    corpus = ET.Element(tei("teiCorpus"))
    corpus.set(XML_ID, "collation_docs")

    header = ET.SubElement(corpus, tei("teiHeader"))
    file_desc = ET.SubElement(header, tei("fileDesc"))
    title_stmt = ET.SubElement(file_desc, tei("titleStmt"))
    title = ET.SubElement(title_stmt, tei("title"))
    title.text = "Pre-publication witnesses for VMS chapter 4-6 collation"
    publication_stmt = ET.SubElement(file_desc, tei("publicationStmt"))
    publication_p = ET.SubElement(publication_stmt, tei("p"))
    publication_p.text = "Generated from fetched hsl-vms-docs witnesses for the collate_docs branch."
    source_desc = ET.SubElement(file_desc, tei("sourceDesc"))
    source_p = ET.SubElement(source_desc, tei("p"))
    source_p.text = "Born digital derived corpus"

    for spec, root, paragraphs, witness_plan in zip(specs, roots, documents, plan):
        corpus.append(build_witness(spec, root, paragraphs, references, witness_plan))

    return ET.ElementTree(corpus)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Fetch and align the four pre-publication witnesses for VMS chapter 4-6 collation.")
    parser.add_argument("--docs-base-url", default=DEFAULT_BASE_URL, help="Base raw GitHub URL for hsl-vms-docs edition files")
    parser.add_argument("--reference", default=str(DEFAULT_REFERENCE), help="Reference VMS witness used to inherit chapter 4-6 paragraph keys")
    parser.add_argument("--output", default=str(DEFAULT_OUTPUT), help="Output TEI corpus file")
    parser.add_argument("--min-similarity", type=float, default=0.25, help="Fail if an aligned segment falls below this similarity score")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    reference_path = Path(args.reference)
    output_path = Path(args.output)

    references = reference_paragraphs(reference_path)
    source_roots = [fetch_root(args.docs_base_url, spec) for spec in DOC_SPECS]
    documents = [body_paragraphs(root) for root in source_roots]
    plan = plan_alignment(documents, references)

    all_ratios: list[float] = []
    for spec, (reference_start, reference_end, path, score), paragraphs in zip(DOC_SPECS, plan, documents):
        ref_start_key = references[reference_start][0]
        ref_end_key = references[reference_end - 1][0]
        ratios = [ratio for paragraph_start, paragraph_end, _, ratio in path if paragraph_start != paragraph_end]
        skipped = sum(1 for paragraph_start, paragraph_end, _, _ in path if paragraph_start == paragraph_end)
        all_ratios.extend(ratios)
        print(
            f"{spec.label}: {len(paragraphs)} source paragraphs -> {reference_end - reference_start} VMS paragraphs "
            f"({ref_start_key} .. {ref_end_key}), score={score:.3f}, skipped={skipped}, "
            f"min={min(ratios):.3f}, avg={sum(ratios) / len(ratios):.3f}"
        )

    min_ratio = min(all_ratios)
    if min_ratio < args.min_similarity:
        raise RuntimeError(
            f"Alignment quality check failed: minimum segment similarity {min_ratio:.3f} is below {args.min_similarity:.3f}"
        )

    output_path.parent.mkdir(parents=True, exist_ok=True)
    corpus = build_corpus(DOC_SPECS, source_roots, documents, references, plan)
    ET.indent(corpus, space="  ")
    corpus.write(str(output_path), encoding="UTF-8", xml_declaration=True)
    print(f"Wrote {output_path}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(exc, file=sys.stderr)
        raise SystemExit(1)