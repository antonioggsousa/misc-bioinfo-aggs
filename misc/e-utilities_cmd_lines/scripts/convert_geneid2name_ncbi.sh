# Download data from NCBI with esearch: https://www.ncbi.nlm.nih.gov/books/NBK179288/

## Example:

for i in `head ./ensembl_ids_1k.txt`; 
do printf ${i}"\t"; 
	esearch -db gene -query ${i} | esummary | xtract -pattern DocumentSummary -element NomenclatureSymbol,NomenclatureName; 
done;
