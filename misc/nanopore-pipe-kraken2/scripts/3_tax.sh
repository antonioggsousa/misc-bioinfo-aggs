#!/bin/bash

SECONDS=0

IN=$PWD/data/fastq_filter
DB=$PWD/../bin/centrifuge/database
CENTRI=$PWD/../bin/centrifuge/bin/centrifuge
CENTRI_2=$PWD/../bin/centrifuge/bin/centrifuge-kreport
OUT=$PWD/results/tax_class

mkdir -p $OUT

for fastq in $IN/*.fq;
do
	sampName=$( basename $fastq );
	echo "Processing sample ${sampName%%.*}";
	$CENTRI -x $DB/p_compressed -U $fastq --threads 10 --report-file $OUT/${sampName%%.*}_tax_report.tsv;
	$CENTRI_2 -x $DB/p_compressed $OUT/${sampName%%.*}_tax_report.tsv > $OUT/${sampName%%.*}_krona.tsv;
	echo "";
done;

echo "It took $SECONDS secs!"
				
