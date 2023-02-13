import os
import glob

from utils import facs_to_tei


files = sorted(glob.glob(os.path.join("102_derived_tei", "102_02_tei-simple_refactored", "*.xml")))
facs = sorted(glob.glob(os.path.join("traktat-facs", "*", "*_out.csv")))

print(files)
print(facs)

for fi, fc in zip(files, facs):
    try:
        facs_to_tei(fpath=fi, fnames=fc)
    except Exception as err:
        print(err)
