import os
import glob

from utils import facs_to_tei


files = sorted(glob.glob(os.path.join("data", "editions", "t__03_VMS_1865_TEI_AW_26-01-21-TEI-P5.xml")))
facs = sorted(glob.glob(os.path.join("/mnt/acdh_resources/ARCHE/staging/Hanslick_VMS_21500/Traktat/traktat-facs-high-res", "0003", "*_out.csv")))

print(files)
print(facs)

for fi, fc in zip(files, facs):
    try:
        facs_to_tei(fpath=fi, fnames=fc)
    except Exception as err:
        print(err)
