Project: nanopore-pipe-kraken2

Description: bash scripts to process Nanopore 16S rRNA gene data using Centrifuge and Kraken2 for taxonomic classification. 

Content under the `scripts` folder (run sequentially from `0_` to `3.1_`): 

   + **0_QC.sh**: check the quality of fastq files with NanoPlot.

   + **1_trimPrimer.sh**: trim primers/adapters with Porechop.

   + **2_filter_Len_Q.sh**: trim based on Q scores and length with NanoFilt and check the quality with NanoPlot.

   + **3_tax.sh**: classify taxonomically sequences with Centrifuge. 

   + **3_tax.sh**: classify taxonomically sequences with kraken2.