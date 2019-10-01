## TO-DO:
## scale effect sizes or final phenotype variance to specify GxE effect as a proportion of variance
## include genetic main effects as well?

library(SeqArray)
library(tidyverse)

# Genotypes
genofilename <- "data/raw/ALL.chr22.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.bi_maf001.vcf.bgz.gds"
seqOptimize(genofilename, target="by.sample")
genofile <- seqOpen(genofilename)

samp.ids <- seqGetData(genofile, "sample.id")
variant.ids <- seqGetData(genofile, "variant.id")

# Exposures
set.seed(100)
E_vec <- sample(c(0, 1), size=length(samp.ids), replace=T, prob=c(0.3, 0.7))  # Random binary vector of exposures

# Summary statistics
gxe_effects_df <- readxl::read_excel("data/raw/sung_smk_bp_gwis_ss.xlsx", sheet=9, skip=1) %>%  # GxE summary stats from Sung 2018 (smk -> BP)
  select(rsID=RSID, freq_all=Freq_Trans, beta_main=...16, beta_int=...22) %>%  # Using trans-ancestry betas
  slice(-(1:2)) %>%
  mutate_at(vars(beta_main, beta_int), as.numeric) %>%
  na.omit() %>%
  right_join(tibble(rsID=seqGetData(genofile, "annotation/id")))  %>%  # Only keep variants in the genotype file
  replace_na(list(beta_main=0, beta_int=0))  # If variants are missing from Sung summary stats, assume zero effect

# Simulate phenotypes
gxe_sim <- function(index, x) {
  # Given a set of diploid genotypes and associated GxE effect sizes,
  # simulate phenotypes assuming no main-effect for environment or phenotype
  
  dose_vec <- colSums(x$genotype)  # Sum to get diploid MAC per variant for each individual

  ## Variance calculation
  # gxe_effects_variance <- mean(gxe_ss ** 2)  # Variance based on effect sizes
  # gxe_variance <- gxe_effects_variance * (mean(geno_vec ** 2) * mean(env_vec ** 2) - mean(geno_vec * env_vec) ** 2)
  
  gxe_sum <- as.vector((dose_vec * E_vec[index]) %*% gxe_effects_df$beta_int)  # Weighted sum of GxE products based on GxE effect sizes
  rnorm(1, mean=140 + gxe_sum, sd=20)  # 140 and 20 are approximate values for mean/sd of SBP from Sung 2018 population descriptions
}

# seqSetFilter(genofile, sample.id=samp.ids[1:10], variant.id=variant.ids[1:1000])
phenos <- seqApply(genofile, c(sample.id="sample.id", genotype="genotype"), FUN=gxe_sim, 
                   var.index="absolute", margin="by.sample", as.is="double")

pheno_df <- tibble(  # Assemble final phenotype vector with sample ID, exposure, and phenotype
  id=seqGetData(genofile, "sample.id"),
  smk_sim=E_vec,
  bp_sim=phenos
)
write_tsv(pheno_df, "data/processed/smk_bp_sim_phenos.tsv")

closefn.gds(sfile)
closefn.gds(gfile)
