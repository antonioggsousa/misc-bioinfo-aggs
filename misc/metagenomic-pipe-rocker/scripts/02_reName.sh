#!/bin/bash

SECONDS=0

echo 
echo "Renaming file names of fastq files by their respective file names!"
echo 


# abort if any cmd fail
#
set -e
set -o pipefail 


# dirs
#
IN=$PWD/info/Readme.txt
OUT=$PWD/info
FASTQ=$PWD/data
FASTQDIR=$PWD/data/fastq

# retrieve the sample names and the respective fastq file name 
#
grep -A2 "T" $IN | sed 's/[^[:alnum:]._-]\+//g' > $OUT/sampleNames.tmp

# retrieve only the sample names
sampleNames=$(grep ^T[0-9] $OUT/sampleNames.tmp) 

# loop over the sample names 
for sample in $sampleNames;
do sampleFileName=$(grep -A2 $sample $OUT/sampleNames.tmp); 
	echo $sampleFileName >> $OUT/sampleNames.txt;
done;

rm $OUT/sampleNames.tmp #remove the first temporary sample names file


mkdir $FASTQDIR #create the new dir for fastq files

## Copy and rename fastq files 
#
for fastq in $FASTQ/*.fq.gz; 
do echo ""; 
	fileName=$(basename $fastq)
	echo "Renaming $fileName fastq file!";
	reName=$(grep $fileName $OUT/sampleNames.txt | cut -d ' ' -f 1); 
	echo "Copying $fileName file!";
	cp $fastq $FASTQDIR;
	mv $FASTQDIR/$fileName $FASTQDIR/${reName}_${fileName##*_};
done; 

echo 
echo "It took $SECONDS secs to copy and rename fastq files!"
echo 
	




