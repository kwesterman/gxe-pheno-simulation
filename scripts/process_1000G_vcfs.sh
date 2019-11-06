#!/bin/bash

# Subset each chromosome to MAF > 0.05 for more manageable size
for chr in {1..22}; do
	bcftools view -q 0.05 -O z -o ../data/processed/sequenced/chr${chr}.maf05.vcf.gz ../data/raw/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf
done
for chr in X; do
	bcftools view -q 0.05 -O z -o ../data/processed/sequenced/chr${chr}.maf05.vcf.gz ../data/raw/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf
done

# Filter each chromosome for only top variants from Sung 2018
for chr in {1..22} X; do
	bcftools view -i 'ID=@../data/raw/sung2018_variants.csv' -O z -o ../data/processed/sequenced/chr${chr}.maf05.sung2018subset.vcf.gz ..data/processed/sequenced/chr${chr}.maf05.vcf.gz;
done

# Concatenate simulation-relevant genotypes across chromosomes 
bcftools concat -O z -o ../data/processed/sequenced/all.maf05.sung2018subset.vcf.gz ../data/processed/sequenced/chr*.maf05.sung2018subset.vcf.gz 
