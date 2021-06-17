#!/bin/bash 

SECONDS=0

IN=$PWD/data/fastq
OUT=$PWD/results/report_QC

mkdir -p $OUT

for fastq in $IN/*.fastq.gz; 
do 
	sampName=$( basename $fastq );
	echo "Processing sample ${sampName%%.*}";
	NanoPlot -t 8 --fastq $fastq --prefix $OUT/${sampName%%.*};
	echo "";
done; 

echo "It took $SECONDS secs!"

