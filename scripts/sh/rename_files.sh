#!/bin/bash
for filename in $@; do
	dirorig=`dirname ${filename}`
	dirdest="`echo ${dirorig}|sed 's/_01_/_07_/g'|sed 's/_02_/_08_/g'`_renamed"
	mkdir -p ${dirdest}
	shortname=`basename $filename`
	n=`echo "$shortname"|cut -d _ -f 1`
	y=`echo "$shortname"|cut -d _ -f 3`
	cp  ${filename}  "${dirdest}/VMS_Auflage_${n}_${y}.xml"
done
