#!/bin/bash 

SECONDS=0

echo ""
echo "Check and control the quality of fastq files with fastqc program!"

## abort if some command returns a non-zero value
#
set -e
set -o pipefail

## check if fastqc is installed
#
if [[ -x "$(command -v fastqc)" ]];
then
        echo "";
        echo "fastqc is installed!";
        echo $(fastqc --version)
        echo "";
else
        echo "";
        echo "ABORT!";
        echo "fastqc is not installed or accessible!";
        echo ""
fi;


## define variables
#
FASTQ=$PWD/data
OUT=$PWD/output/fastqc

mkdir output; mkdir output/fastqc;


## loop over the fastq files and check/control the quality with fastqc
#
for fastq in $FASTQ/*.fq.gz;	
do echo "Check/control the quality of $(basename $fastq)"; 
	fastqc $fastq -o $OUT;
done;

echo 
echo "It took $SECONDS secs to check/control the quality of fastq files!"
echo

