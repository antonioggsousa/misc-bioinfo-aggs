Project: metagenomic-pipe-rocker

Description: scripts to process metagenomic reads and annotate them with ROCker against a set of specific functional genes.

Content under the `scripts` folder:

   + **00_checkSum.sh**: check MD5 hash string between the fastq downloaded files and the database/repository.

   + **01_fastqControl.sh**: check quality of fastq files with fastQC.

   + **02_reName.sh**: rename fastq file names.

   + **03_mergeFwdandRev.sh**: merge/combine forward and reverse fastq reads with PEAR and convert fastq files into fasta with vsearch.

   + **04_annot.sh**: annotate metagenomic reads against particular functional genes with ROCker.

   + **05_countMappedReads.R**: R script to count and normalize counts.

   + **other**: other scripts used to process results from HUMANN2 pipeline.

      + **get_uniprot_id.py**: python functions to get UniProt ids.

      + **sum_plot_humann2.R**: R script to convert UniProt ids based on the `get_uniprot_id.py` python script and plot data from HUMANN2.
