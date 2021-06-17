#--------------------------------------------------------------------------------------------------------------
# Description: Summarize and plot results from HUMAnN2 software
#--------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------
## Libraries to import
library("dplyr")
library("reticulate") # to import and run python code
library("tidyr")
library("ggplot2")
#--------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------
## Import data & parse data
fun_data <- read.table(file = "gene_families_merged_cpm.tsv", 
                       stringsAsFactors = FALSE, sep = "\t",
                       header = TRUE, comment.char = "")
colnames(fun_data) <- gsub(pattern = "^X\\.\\.|_genefamilies", replacement = "", 
                           x = colnames(fun_data))
colnames(fun_data)[1] <- c("Gene_family")
#--------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------
## Retrieve UniProt IDs to retrieve protein names 
uniprot_ids <- fun_data$Gene_family %>%
  sapply(X = ., function(x) {
    strsplit(x = x, split = "_|\\|")[[1]][2]
  })
#library("reticulate") # python function
source_python("get_uniprot_id.py")
id_2_gene <- get_uniprot_id(uniprot_ids, 
                            convert_from ="NF90", # UniRef90
                            convert_to = "GENENAME") # common gene name
colnames(id_2_gene) <- c("UniProt_id", "Gene_name")
#--------------------------------------------------------------------------------------------------------------
  
#--------------------------------------------------------------------------------------------------------------
## Join UniProt annotations and tax information
fun_data[,"UniProt_id"] <- uniprot_ids

# get genus and species information 
tax_info <- fun_data$Gene_family %>% 
  sapply(X = ., function(x) {
    strsplit(x = x, split = "\\|")[[1]][2]
  })
split_tax <- tax_info %>% 
  sapply(X = ., function(x) {
    strsplit(x = x, split = "\\.")
  })
genus <- split_tax %>% 
  sapply(X = ., function(x) {
    grep(pattern = "^g__", x = x, value = TRUE) %>% 
      gsub(pattern = "^g__", replacement = "", .)
  }) 
genus[genus == "character(0)"] <- NA
genus <- genus %>% unlist(.)
spp <- split_tax %>% 
  sapply(X = ., function(x) {
    grep(pattern = "^s__", x = x, value = TRUE) %>% 
      gsub(pattern = "^s__", replacement = "", .)
  }) 
spp[spp == "character(0)"] <- NA
spp <- spp %>% unlist(.)
fun_data[,"Genus"] <- genus
fun_data[,"Species"] <- spp

# join gene names
fun_data <- left_join(x = fun_data, y = id_2_gene, by = "UniProt_id")

# save current data 
write.table(x = fun_data, file = "gene_families_merged_cpm_annotated.tsv", 
            sep = "\t", quote = FALSE, row.names = FALSE)
#--------------------------------------------------------------------------------------------------------------

#--------------------------------------------------------------------------------------------------------------
## Plot nir genes
sample_order <- c("T4_50_0", "T7_50_0", "T24_50_0",
                  "T4_50_10", "T7_50_10", "T24_50_10")
plot_1 <- fun_data %>% 
  filter(!is.na(Genus)) %>% 
  filter(grepl(pattern = "^nir", x = Gene_name, ignore.case = TRUE)) %>% 
  pivot_longer(data = ., cols = colnames(fun_data)[2:7], 
               names_to = "Samples", values_to = "Counts") %>% 
  mutate(Samples = factor(Samples, levels = sample_order)) %>% 
  ggplot(data = ., aes(x = Samples, y = Counts, fill = Gene_name)) + 
  geom_bar(stat = "identity", position = position_dodge2(preserve = "single")) + 
  facet_wrap(~ Species) +
  ggsci::scale_fill_npg(name = "Gene") + 
  theme_minimal() +
  ylab("Counts (CPM)") + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))
ggsave(filename = "nir_genes_by_species.pdf", 
       plot = plot_1, height = 4, width = 7)
#--------------------------------------------------------------------------------------------------------------
