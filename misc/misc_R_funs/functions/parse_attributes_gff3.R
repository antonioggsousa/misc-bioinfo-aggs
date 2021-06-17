# Parse attribute column from a gff3: retrieve gene attributes
# author: António Sousa
# last update: 07/10/2020

## Test data
d <- "ftp://ftp.ensembl.org/pub/release-86/gff3/homo_sapiens/"
f <- "Homo_sapiens.GRCh38.86.chromosome.MT.gff3.gz"
download.file(paste0(d, f), "mt_gff3.gz")
gff.mito <- read.gff("mt_gff3.gz")
##

# Run fun and example
gff_file <- "mt_gff3.gz"

get_gene_attr_from_gff <- function(gff_file) {
  
  require("ape")
  
  gff <- read.gff(gff_file) # import gff
  list_attr <- strsplit(x = gff$attributes, split = ";") # split "attributes" col by ";"
  list_len <- length(list_attr) # no of elements

  # to save results
  chro <- c()
  id <- c()
  name <- c()
  biotype <- c()
  description <- c()
  gene_id <- c()
  logic_name <- c()
  v <- c()
  for ( ele in seq(list_len) ) {
      
    if ( length(grep("chromosome", list_attr[[ ele ]][1])) == 1 ) { # get chromosome id
      chromo <- gsub(pattern = "ID=chromosome:", replacement = "", 
                     x = list_attr[[ ele ]][1] )
    } else if ( length(grep("ID=gene", list_attr[[ ele ]][1])) == 1 ) { # get gene attributes\
      #it assumes that have 7 tags separated bi ";": ID, Name, biotype, description, gene_id, \
      #logic_name, version
      
      # ID
      check_id <- sapply(list_attr[[ ele ]], function(x) grep(pattern = "ID=", x))
      if ( 1 %in% check_id ) {
        ID <- names(check_id[!is.na(check_id == 1)])
        ID <- gsub(pattern = "ID=", replacement = "", 
                   x = ID)
      } else ID <- NA
      
      # Name
      check_name <- sapply(list_attr[[ ele ]], function(x) grep(pattern = "Name=", x))
      if ( 1 %in% check_name) {
        Name <- names(check_name[!is.na(check_name == 1)])
        Name <- gsub(pattern = "Name=", replacement = "", 
                     x = Name) 
      } else Name <- NA
      
      # Biotype
      check_biotype <- sapply(list_attr[[ ele ]], function(x) grep(pattern = "biotype=", x))
      if ( 1 %in% check_biotype ) {
        Biotype <- names(check_biotype[!is.na(check_biotype == 1)])
        Biotype <- gsub(pattern = "biotype=", replacement = "", 
                        x = Biotype) 
      } else Biotype <- NA
      
      # Description
      check_description <- sapply(list_attr[[ ele ]], function(x) grep(pattern = "description=", x))
      if ( 1 %in% check_description ) {
        Description <- names(check_description[!is.na(check_description == 1)]) 
        Description <- gsub(pattern = "description=", replacement = "",
                            x = Description) 
      } else Description <- NA
      
      # Gene_id
      check_gene_id <- sapply(list_attr[[ ele ]], function(x) grep(pattern = "gene_id=", x)) 
      if ( 1 %in% check_gene_id ) {
        Gene_id <- names(check_gene_id[!is.na(check_gene_id == 1)])
        Gene_id <- gsub(pattern = "gene_id=", replacement = "", 
                        x = Gene_id) 
      } else Gene_id <- NA
      
      # Logic_name 
      check_logic_name <- sapply(list_attr[[ ele ]], function(x) grep(pattern = "gene_id=", x)) 
      if ( 1 %in% check_logic_name ) {
        Logic_name <- names(check_logic_name[!is.na(check_logic_name == 1)])
        Logic_name <- gsub(pattern = "logic_name=", replacement = "", 
                           x = Logic_name)
      } else Logic_name
       
      #Version <- gsub(pattern = "version=", replacement = "", 
      #             x = list_attr[[ ele ]][7]) 
        
      # Save result
      chro <- append(chro, chromo)
      id <- append(id, ID)
      name <- append(name, Name)
      biotype <- append(biotype, Biotype)
      description <- append(description, Description)
      gene_id <- append(gene_id, Gene_id)
      logic_name <- append(logic_name, Logic_name)
      #v <- append(v, Version)
    } else {
      next()
    }
  }
  # save into a df
  attr_df <- data.frame("Chromosome" = chro, "ID" = id, 
                        "Name" = name, "Biotype" = biotype, 
                        "Description" = description, "Gene_id" = gene_id, 
                        "Logic_name" = logic_name) #, "Version" = v)
  return(attr_df)
}
