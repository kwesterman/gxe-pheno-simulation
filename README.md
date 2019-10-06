Goal: simulate GxE phenotypes for workflow testing.

process_1000G_vcfs.sh: Filter VCFs for top variants from Sung 2018 (smoking -> blood pressure GWIS) and concatenate chromosomes

assemble_summary_statistics.R: Hack around in R to wrangle Excel Supplementary File from Sung 2018 into a straightforwar summary statistics table.

simulate_phenos.R: Based on input genotypes and summary statistics, simulate phenotypes to contain (sparse) genetic signal.
