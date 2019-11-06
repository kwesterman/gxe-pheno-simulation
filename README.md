Goal: simulate GxE phenotypes for workflow testing.

assemble_summary_statistics.R: Hack around in R to wrangle Excel Supplementary File from Sung 2018 into a straightforward summary statistics table.

download_1000G_vcfs.sh: Download VCFs containing genotype calls for 2504 individuals from the 1000G phase 3 v5 datast.

process_1000G_vcfs.sh: Filter VCFs first for MAF > 0.05 to generate a more reasonable dataset size, then for top variants from Sung 2018 (smoking -> blood pressure GWIS) and concatenate chromosomes.

simulate_phenos.R: Based on input genotypes and summary statistics, simulate phenotypes to contain (sparse) genetic signal.

fetch_MIS_results.sh & subset_imputed_vcfs.sh: If MAF > 0.05 sequenced genotypes used above are imputed using the Michigan Imputation Server, fetch the results (fetch_MIS_results.sh) and subset to common variants (subset_1000G_vcfs.sh). These imputed genotypes can then be used for downstream interaction testing.
