import os
import glob
import pandas as pd

from PIL import Image


dirs = "/mnt/acdh_resources/ARCHE/staging/Hanslick_VMS_21500/Traktat/traktat-facs-high-res"

def rename_files(dirs=dirs, date="1854", path="0001", split="--"):
    images = glob.glob(f"{dirs}/{path}/sub/*")
    for idx, f in enumerate(images):
        fn = f.split("/")
        sv_dir = fn[-3]
        sv_dir2 = fn[-2]
        sv_fn = fn[-1]
        print(sv_dir)
        os.rename(f, 
                  os.path.join(
                      dirs, 
                      sv_dir, 
                      sv_dir2, 
                      f"vms_{date}_{sv_fn.split(split)[-1]}"
                    )
                  )

rename_files(dirs=dirs, date="1891", path="0008", split="-")

def yield_img_dict(images):
    for x in images:
        item = {}
        item['id'] = os.path.basename(x).split('.')[0]
        with Image.open(x) as image:
            item['width'], item['height'] = image.width, image.height
        yield item

def create_csv(dirs=dirs):
    dir = glob.glob(f"{dirs}/*")
    for x in dir:
        sub_dir = x.split('/')[-1]
        images = sorted(glob.glob(f"{x}/sub/*"))
        df = pd.DataFrame(yield_img_dict(images), columns=['id', 'width', 'height'])
        df.to_csv(f'{x}/{sub_dir}_out.csv', index=False)

create_csv(dirs=dirs)
