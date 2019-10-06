library(tidyverse)

index_snps_df <- readxl::read_excel("data/raw/sung_smk_bp_gwis_ss.xlsx", sheet=12, skip=1) %>%  # 81 index variants from Sung 2018 (smk -> BP)
  select(rsID)

gxe_effects_df <- readxl::read_excel("data/raw/sung_smk_bp_gwis_ss.xlsx", sheet=9, skip=1) %>%  # Main-effect and GxE summary stats
  select(rsID=RSID, freq_all=Freq_Trans, beta_main=...16, beta_int=...22) %>%  # Using trans-ancestry betas
  slice(-(1:2)) %>%
  mutate_at(vars(beta_main, beta_int), as.numeric) %>%
  na.omit() %>%
  inner_join(index_snps_df, by="rsID")  # Filter for index variants only

write_csv(select(gxe_effects_df, rsID), "data/processed/sung2018_variants.csv")
write_csv(gxe_effects_df, "data/processed/sung2018_effects.csv")