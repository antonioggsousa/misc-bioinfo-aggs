#!/bin/bash 

SECONDS=0 

echo
echo "Checksum the fastq files!"
echo 

FASTQ=$PWD/data
CHECKFILE=$PWD/info/md5.txt

for fastq in $FASTQ/*.fq.gz; 
do checksum=$(grep $(basename $fastq) $CHECKFILE | cut -d ' ' -f 1); 
	check2=$(md5sum $fastq | cut -d ' ' -f 1); 
	if [ $checksum == $check2 ]; 
	then echo "$fastq file matched the checksum key at $CHECKFILE!"; 
	else echo "$fastq file does not matched the checksum key at $CHECKFILE!";
	       echo "Check if $fastq file is not corrupted!"	
	fi; 
done;

echo 
echo "It took $SECONDS secs to checksum the fastq files!"
echo 
