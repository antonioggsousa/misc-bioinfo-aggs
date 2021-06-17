#!/bin/bash

SECONDS=0

IN=$PWD/data/fastq_filter
DB=$PWD/../bin/kraken2/database/minikraken_8GB_20200312
KRAKEN=$PWD/../bin/kraken2/./kraken2
OUT=$PWD/results/tax_class_kraken

mkdir -p $OUT

for fastq in $IN/*.fq;
do
	sampName=$( basename $fastq );
	echo "Processing sample ${sampName%%.*}";
	$KRAKEN --db $DB $fastq --threads 10 \
		--output $OUT/${sampName%%.*}_output.tsv \
		--report $OUT/${sampName%%.*}_report.tsv;
	echo "";
done;

echo "It took $SECONDS secs!"
				
