## calculate genome equivalents as: https://aem.asm.org/content/aem/84/2/e01646-17.full.pdf

## import packages
#
library("dplyr")
library("ggplot2")
#library("readr") # it requires 'readr'
#library("seqinr") # it requires 'seqinr'


## dirs/files
#
ANNOT <- paste0( getwd(), "/../output/annotation" )
IN_FOLDERS <- list.files( path = ANNOT, 
                         full.names = TRUE )


## retrieve the median gene length for each matched "protein" in DB
# 
annt_tbl <- data.frame( "Genes" = rep( NA, 24 ), 
                        "Samples" = rep( NA, 24 ), 
                        "Median_Length" = rep( NA, 24 ),
                        "not_matching_UniProtIds" = rep( NA, 24 ),
                        "Mapped_Reads" = rep( NA, 24 ) ) 
uniprotIds <- c() # vct to save tmp uniprot ids
uniprotLen <- c() # vct to save tmo uniprot fasta seq length
noMatchUniprot <- c() # vct to save not matching Uniprot ids
c <- 0 # counter 
for ( pathDir in IN_FOLDERS ) {
  
  gene <- basename( path = pathDir ) # get basename 
  sampList <- list.files( path = pathDir )
  
  # loop over samples, import the annt tbls and retrieve uniprot ids
  for ( samp in sampList ) {
    
    c = c + 1
    annt_tbl$Genes[ c ] <- gene
    annt_tbl$Samples[ c ] <- samp
    geneAnnt <- readr::read_tsv( file = paste0( pathDir, "/", samp ), 
                                 col_names = FALSE ) # import annt tbl
    geneAnnt <- geneAnnt[ , 2 ] %>% 
      pull %>% 
      sapply( ., function(x) strsplit(x, "\\|")[[1]][2] ) # import and parse annotation tbls
    uniprotIds <- append( uniprotIds, geneAnnt) # uniprot ids for the curr gene/protein
    annt_tbl$Mapped_Reads[ c ] <- length( uniprotIds ) # no. of hits for the curr gene in the curr samp
    
    ## loop over uniprot ids and get the length of each fasta seq
    for ( uni in uniprotIds ) {
      
      currUniFa <- try( seqinr::read.fasta( paste0( "https://www.uniprot.org/uniprot/", uni, ".fasta" ), 
                                       seqtype = "AA", as.string = TRUE), 
                        silent = TRUE ) # curr Uni id fasta seq
      if ( class(currUniFa) == "try-error" ) { # in case of not matching uniprot ids against the DBs: append these
        noMatchUniprot <- append( noMatchUniprot, currUniFa )
      } else { # just save 
        currUniFaLen <- nchar( currUniFa[[1]][1] ) # UniProt ID fasta seq length
        uniprotLen <- append( uniprotLen, 
                              currUniFaLen ) # save it  
      }
    }
      
    #annt_tbl$not_matching_UniProtIds[ c ] <- paste( noMatchUniprot, collapse = "-" ) # list of genes
    #for which it was not possible to get gene length
    annt_tbl$Median_Length[ c ] <- median( uniprotLen ) # get "Median_Length" for uniprot fasta seqs
    
  }
}

readr::write_tsv(x = annt_tbl, path = "../output/annotation/annotation_tbl.tsv")

annt_tbl <- readr::read_tsv(file = "../output/annotation/annotation_tbl.tsv") %>% 
  as.data.frame()

## get genome equivalents 
#
annt_tbl$Genome_Equivalents <- NA 
for ( r in 1:nrow( annt_tbl ) ) { 
  
  samp <- annt_tbl$Samples[ r ] # curr sample
  
  annt_tbl$Genome_Equivalents[ r ] <- ( annt_tbl$Mapped_Reads[ r ] / 
                                          annt_tbl$Median_Length[ r ] ) /  # normalized target reads
    ( annt_tbl[ annt_tbl$Genes == "RpoB" & annt_tbl$Samples == samp, "Mapped_Reads" ] / 
        annt_tbl[ annt_tbl$Genes == "RpoB" & annt_tbl$Samples == samp, "Median_Length" ] ) # normalized RpoB reads
}

readr::write_tsv( x = annt_tbl, 
                 path = "../output/annotation/annotation_tbl_summary.tsv", 
                 col_names = TRUE)

## Plot
#
plot_1 <- 
  annt_tbl[ annt_tbl$Genes != "RpoB", ] %>% 
  mutate( "samples" = factor( gsub("-0.blast|-10.blast", "", Samples), 
                              levels = c("T4-50", "T7-50", "T24-50") ) ) %>% 
  mutate( "Condition" = factor( gsub("T4-50-|T7-50-|T24-50-|.blast", "", Samples), 
                                levels = c("0", "10"), 
                                labels = c('0 μg/g', '0.1 μg/g')) ) %>%
  ggplot( ., aes( x = samples, y = Genome_Equivalents, fill = Genes ) ) + 
  geom_bar( stat = "identity" ) + 
  ggsci::scale_fill_npg() +
  facet_grid( Genes ~ Condition ) + 
  ylab("Genome equivalents") + 
  theme_bw()

pdf(file = "../output/annotation/genome_equivalents.pdf")
print(plot_1)
dev.off()
