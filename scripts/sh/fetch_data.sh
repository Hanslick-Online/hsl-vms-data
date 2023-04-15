# bin/bash

# fetch edition entities all
rm -rf ./data/indices
mkdir ./data/indices
wget https://github.com/Hanslick-Online/hsl-entities/archive/refs/heads/main.zip
unzip main
mv hsl-entities-main/out/*.xml ./data/indices
rm ./data/indices/listbibl_static.xml
rm -rf hsl-entities-main
rm main.zip