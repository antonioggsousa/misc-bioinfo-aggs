#!/bin/bash 

SECONDS=0

echo ""
echo "Merge forward and reverse fastq files with PEAR program!"

## abort if some command returns a non-zero value
#
set -e
set -o pipefail

## check if pear is installed
#
if [[ -x "$(command -v pear)" ]];
then
        echo "";
        echo "pear is installed!";
        echo $(pear --version)
        echo "";
else
        echo "";
        echo "ABORT!";
        echo "pear is not installed or accessible!";
        echo ""
fi;

## check if vsearch is installed
#
if [[ -x "$(command -v vsearch)" ]];
then
        echo "";
        echo "vsearch is installed!";
        echo $(vsearch --version)
        echo "";
else
        echo "";
        echo "ABORT!";
        echo "vsearch is not installed or accessible!";
        echo ""
fi;

## dirs/files
# 
FASTQ=$PWD/data/fastq
FASTQ_MERGED=$PWD/data/merge
FASTA=$PWD/data/fasta
SAMPFILE=$PWD/info/sampleNames.txt
THREADS=4

mkdir $FASTQ_MERGED #create the output dir 'merge'
mkdir $FASTA #create the output dir 'fasta'

samples=$(cut -d ' ' -f 1 $SAMPFILE) #retrieve the sample names


## loop over each fastq file and merge fwd and rev fastq files
#
for fastq in $samples;
do echo ""; 
	echo "Merging $fastq sample!"
	gunzip $FASTQ/${fastq}_1.fq.gz; gunzip $FASTQ/${fastq}_2.fq.gz;
	pear -f $FASTQ/${fastq}_1.fq -r $FASTQ/${fastq}_2.fq -m 300 -n 150 --threads $THREADS -o $FASTQ_MERGED/${fastq}; 
	vsearch --fastq_filter $FASTQ_MERGED/${fastq}.assembled.fastq -fastaout $FASTA/${fastq}.assembled.fa;
done;

echo 
echo "It took $SECONDS to merge all fastq files!" 
echo

