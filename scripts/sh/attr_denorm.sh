# bin/bash

echo "add attributes"
add-attributes -g "./data/editions/*.xml" -b "https://id.acdh.oeaw.ac.at/hanslick-vms"
echo "denormalize indices"
denormalize-indices -f "data/editions/*.xml" -i "data/indices/*.xml" -m './/tei:rs[@ref]/@ref' -t 'erwähnt in ' -x './/tei:title[@type="main"][1]/text()'