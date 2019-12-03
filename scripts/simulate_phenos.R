library(SeqArray)
library(SNPRelate)
library(tidyverse)

# Genotypes
vcf_filename <- "../data/processed/sequenced/all.sung2018subset.vcf.gz"
gds_filename <- "../data/processed/sequenced/all.sung2018subset.gds"
seqVCF2GDS(vcf_filename, gds_filename)
seqOptimize(gds_filename, target="by.sample")
genofile <- seqOpen(gds_filename)

samp.ids <- seqGetData(genofile, "sample.id")
variant.ids <- seqGetData(genofile, "variant.id")

# Exposures
set.seed(100)
E_vec <- sample(c(0, 1), size=length(samp.ids), replace=T, prob=c(0.3, 0.7))  # Random binary vector of exposures

# Summary statistics
gxe_effects_df <- read_csv("../data/processed/simulation/sung2018_effects.csv") %>%
  right_join(tibble(rsID=seqGetData(genofile, "annotation/id")))  %>%  # Only keep variants in the genotype file (MAF > 0.05!)
  replace_na(list(beta_main=0, beta_int=0)) %>%  # If variants are missing from Sung summary stats, assume zero effect
  mutate(beta_main=ifelse(abs(beta_main) > 0.5 | abs(beta_int) > 0.3, beta_main, 0),  # Include only variants with largest effects
         beta_int=ifelse(abs(beta_main) > 0.5 | abs(beta_int) > 0.3, beta_int, 0))

# Simulate phenotypes
gxe_sim <- function(index, x) {
  # Given a set of diploid genotypes and associated GxE effect sizes,
  # simulate phenotypes assuming no main-effect for environment or phenotype
  geno_vec <- colSums(x$genotype)  # Sum to get diploid MAC per variant for each individual

  g_sum <- as.vector(geno_vec %*% gxe_effects_df$beta_main)  # Weighted sum of main effects 
  gxe_sum <- as.vector((geno_vec * E_vec[index]) %*% gxe_effects_df$beta_int)  # Weighted sum of GxE products
  rnorm(1, mean=140 + g_sum + gxe_sum, sd=2)  # 140 and 20 are approximate values for mean/sd of SBP from Sung 2018 population descriptions
  # Shrink the std. dev. to more easily uncover the effects with a smaller sample size
}

phenos <- seqApply(genofile, c(sample.id="sample.id", genotype="genotype"), FUN=gxe_sim, 
                   var.index="absolute", margin="by.sample", as.is="double")

# Write phenotype file
num_ids <- length(samp.ids)
pheno_df <- tibble(  # Assemble final phenotype table
  id=samp.ids,
  bp_sim=phenos,
  smk_sim=E_vec,
  sex=sample(c(1, 2), size=num_ids, replace=T),
  age=runif(num_ids, 20, 65) +  # Induce small correlation with age covariate
    rnorm(num_ids, phenos / sd(phenos), 5)
)

write_csv(pheno_df, "../data/processed/simulation/smk_bp_sim_phenos.csv")
write_tsv(pheno_df, "../data/processed/simulation/smk_bp_sim_phenos.tsv")

closefn.gds(genofile)

# Simulate and write (random/unrelated) pedigree to accompany phenotypes
ped_df <- tibble(
  PED=1:num_ids, 
  EGO=samp.ids,
  FA=0,
  MO=0,
  SEX=pheno_df$sex
)
write_csv(ped_df, "../data/processed/simulation/sim_unrelated_pedigree.csv")
