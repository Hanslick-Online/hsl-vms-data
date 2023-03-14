# bin/bash

echo "downloading saxon"
wget https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/SaxonHE9-9-1-7J.zip/download && unzip download -d saxon && rm -rf download
# echo "downloading TEIC stylesheets"
# wget https://github.com/TEIC/Stylesheets/archive/refs/heads/dev.zip && unzip dev.zip -d TEI-Stylesheets && rm -rf dev.zip
