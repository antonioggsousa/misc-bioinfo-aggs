#!/bin/bash 

SECONDS=0

echo ""
echo "Annotate denitrifying-related metagenomic reads with ROCker!"

## abort if some command returns a non-zero value
#
set -e
set -o pipefail

## check if ROCker is installed
#
if [[ -x "$(command -v ROCker)" ]];
then
        echo "";
        echo "ROCker is installed!";
        echo $(ROCker --version)
        echo "";
else
        echo "";
        echo "ABORT!";
        echo "ROCker is not installed or accessible!";
        echo ""
fi;

## dirs/files
#
FASTA=$PWD/data/fasta
REF=$PWD/databases
ANNOT=$PWD/output/annotation
THREADS=4

mkdir $REF; mkdir $ANNOT;

## link to download the reference databases
#
DB='http://enve-omics.ce.gatech.edu/rocker/rocker/models/NarG/NarG.250.rocker http://enve-omics.ce.gatech.edu/rocker/rocker/models/NirK/NirK.250.rocker http://enve-omics.ce.gatech.edu/rocker/rocker/models/NosZ/NosZ.250.rocker http://enve-omics.ce.gatech.edu/rocker/rocker/models/RpoB/RpoB.250.rocker'

for db in $DB; 
	do echo "";
	database=$( basename ${db});
	echo "Downloading $database database...";
	wget $db -O $REF/$database; 
	mkdir $ANNOT/${database%%.*};
	#
	for fa in $FASTA/*; 
		do echo ""; 
		echo "Mapping metagenomic reads from $( basename ${fa%%.*}) sample against $database database...";
		ROCker search -i $fa -k $REF/$database -o $ANNOT/${database%%.*}/$( basename ${fa%%.*}).blast;
	done; 
done;

echo ""
echo "It took $SECONDS to download databases and annotate fasta files!"
echo ""

