import os
from lxml import etree as ET
import pandas as pd

from acdh_tei_pyutils.tei import TeiReader

NS = {
    "tei": "http://www.tei-c.org/ns/1.0",
    "xml": "http://www.w3.org/XML/1998/namespace",
}


files = os.path.join("data", "traktat", "editions", "t__01_VMS_1854_TEI_AW_26-01-21-TEI-P5.xml")
fNames = os.path.join("traktat-images", "1", "out.csv")


def get_df(fpath=None):
    """open df with filenames"""
    
    file = fpath
    df = pd.read_csv(file)
    return df


def facs_to_tei(fpath=None,fnames=None):
    """add facsimiles object to tei"""
    
    f = fpath
    df = get_df(fnames)
    print(f"START updating xml: {f}")
    doc = TeiReader(f)
    root_node = doc.tree.getroot()
    facs = ET.Element("{http://www.tei-c.org/ns/1.0}facsimile")
    for i, row in df.iterrows():
        surface = ET.Element("{http://www.tei-c.org/ns/1.0}surface")
        surface.attrib["ulx"] = "0"
        surface.attrib["uly"] = "0"
        surface.attrib["lrx"] = str(row["width"])
        surface.attrib["lry"] = str(row["height"])
        graphic = ET.Element("{http://www.tei-c.org/ns/1.0}graphic")
        graphic.attrib["url"] = f"https://iiif.acdh.oeaw.ac.at/images/hsl-vms/{row['id']}"
        surface.append(graphic)
        facs.append(surface)
    root_node.insert(1, facs)
    doc.tree_to_file(file=f)
    print(f"FINISHED updating xml: {f}")
