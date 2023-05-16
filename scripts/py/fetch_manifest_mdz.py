import requests
import pandas as pd

# URL of the manifest
url2 = "https://api.digitale-sammlungen.de/iiif/presentation/v2/bsb10598668/manifest"
url3 = "https://api.digitale-sammlungen.de/iiif/presentation/v2/bsb10598670/manifest"
base = "https://api.digitale-sammlungen.de/iiif/image/v2/"
ext = "/full/full/0/default.jpg"

# create a response object and return json
def get_manifest(url):
    r = requests.get(url)
    json = r.json()
    return json

# create csv with manifest data
def create_csv(json, save="edition2.csv"):
    canvases = json['sequences'][0]['canvases']
    images = []
    for x in canvases:
        data = {}
        image = x['images'][0]
        resource = image['resource']
        data['id'] = resource['@id'].replace(ext, '').replace(base, '')
        data['width'] = resource['width']
        data['height'] = resource['height']
        images.append(data)
    df = pd.DataFrame(images)
    df.to_csv(save, index=False)
    return df

json = get_manifest(url2)
manifest = create_csv(json, save="./traktat-facs/0002/0002_out.csv")
print(manifest)

json = get_manifest(url3)
manifest = create_csv(json, save="./traktat-facs/0003/0003_out.csv")
print(manifest)