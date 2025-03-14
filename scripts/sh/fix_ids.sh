#!/bin/bash
orig_dir="102_derived_tei/102_01_tei-full_bak"

for path in ${orig_dir}/*; do
	orig_file=`basename ${path}`
	alternate=`echo $orig_file|sed 's/\([[:digit:]]\)\.\([[:digit:]]\)/\1-\2/g'`
	n=`echo "$orig_file"|cut -d _ -f 1`
	y=`echo "$orig_file"|cut -d _ -f 3`
	dest_file="VMS_Auflage_${n}_${y}.xml"
	for filename in ${orig_file%.*} ${alternate%.*}; do
		sed -i "s/t__$filename/$dest_file/g" 102_derived_tei/102_0[2-6]*/*
		sed -i "s/$filename/$dest_file/g" 102_derived_tei/102_0[2-6]*/*
	done
done
