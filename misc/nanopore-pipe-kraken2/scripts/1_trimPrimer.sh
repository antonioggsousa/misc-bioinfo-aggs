#!/bin/bash 

SECONDS=0

IN=$PWD/data/fastq
OUT=$PWD/data/fq_trim_primer
PORE=$PWD/../bin/Porechop/./porechop-runner.py

mkdir -p $OUT

for fastq in $IN/*.fastq.gz; 
do 
	sampName=$( basename $fastq );
	echo "Processing sample ${sampName%%.*}";
	$PORE -i $fastq -o $OUT/$sampName;
	echo "";
done; 

echo "It took $SECONDS secs!"

