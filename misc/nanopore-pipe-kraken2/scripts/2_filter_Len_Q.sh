#!/bin/bash

SECONDS=0

IN=$PWD/data/fq_trim_primer
OUT_1=$PWD/data/fastq_filter
OUT_2=$PWD/results/report_QC_2

mkdir -p $OUT_1 $OUT_2

for fastq in $IN/*.fastq.gz;
do
	sampName=$( basename $fastq );
	echo "Processing sample ${sampName%%.*}";
	gunzip -c $fastq | NanoFilt -q 10 -l 1100 --maxlength 1600 > $OUT_1/${sampName%%.*}.trim.fq;
	NanoPlot -t 9 --fastq $OUT_1/${sampName%%.*}.trim.fq --prefix $OUT_2/${sampName%%.*};
	echo "";
done;

echo "It took $SECONDS secs!"
				
