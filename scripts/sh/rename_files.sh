#!/bin/bash
orig_dir="$1"
tmp_dir="tmp"
dest_dir="`echo ${orig_dir} | sed 's/_01_/_07_/g'|sed 's/_02_/_08_/g'`_renamed"
mkdir -p ${tmp_dir}
mkdir -p ${dest_dir}
cp ${orig_dir}/*.xml ${tmp_dir}

for path in ${tmp_dir}/*; do
	orig_file=`basename ${path}`
	n=`echo "$orig_file"|cut -d _ -f 1`
	y=`echo "$orig_file"|cut -d _ -f 3`
	dest_file="VMS_Auflage_${n}_${y}.xml"
	cp  ${path}  "${tmp_dir}/${dest_file}"
done
cp ${tmp_dir}/VMS* ${dest_dir}
