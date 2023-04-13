[![Build and publish](https://github.com/acdh-oeaw/hanslick-vms/actions/workflows/build.yml/badge.svg)](https://github.com/acdh-oeaw/hanslick-vms/actions/workflows/build.yml) [![DOI](https://zenodo.org/badge/564263510.svg)](https://zenodo.org/badge/latestdoi/564263510)


# Hanslick VMS 

Find future updates at [Hanslick Online Data Repository](https://github.com/Hanslick-Online/hsl-vms-data).

This git repository currently contains test data of the [FWF edition project P 30554](https://pf.fwf.ac.at/project_pdfs/pdf_abstracts/p30554d.pdf) on Eduard Hanslick: „Vom Musikalisch-Schönen. Ein Beitrag zur Revision der Aesthetik der Tonkunst.“

Provided by Alexander and Meike Wilfing, Sept 2018

* 102_02_tei-simple_refactored contains the "resulting" TEI data to be manually edited

## Rebuilding the data

### Building the basic TEI documents

**BEWARE** THIS REMOVES ANY MANUAL EDITS on the TEI documents

* run *DOCX TEI P5* transformation scenario on 001_src
* copy resulting XML to 102_01_tei-full
* rename "media" folder containing images to the number of the edition (01–10)
* convert tif images to jpg (e.g. using `convert`)
* run *simplify & upconvert* transformation scenario on 102_01_tei-full

The preliminary TEI documents are placed into 102_02_tei-simple where they should be further corrected/edited.

### Building the paragraph diffs

* run the *comp* transformation scenario
* diff TEI documents will be placed into 102_05_comp

### Building index documents

* run the *index_persons* *index_orgnames* *index_placenames*  transformation scenario
* index TEI documents will be placed into 102_04_indexes

NB: if a `<persName>` element contains a `@key` attribute this will be used as the index entry of the occurence in question.
