#!/bin/bash


# Filter each chromosome for only top variants from Sung 2018
for chr in {1..22}; do
	bcftools view -i 'ID=@../data/processed/simulation/sung2018_variants.csv' -O z -o ../data/processed/sequenced/chr${chr}.sung2018subset.vcf.gz ../data/raw/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
done
for chr in X; do
	bcftools view -i 'ID=@../data/processed/simulation/sung2018_variants.csv' -O z -o ../data/processed/sequenced/chr${chr}.sung2018subset.vcf.gz ../data/raw/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz
done

# Concatenate simulation-relevant genotypes across chromosomes 
bcftools concat -O z -o ../data/processed/sequenced/all.sung2018subset.vcf.gz ../data/processed/sequenced/chr*.sung2018subset.vcf.gz 

# Subset each chromosome to MAF > 0.05 for more manageable size
for chr in {1..22}; do
	bcftools view -q 0.05 -O z -o ../data/processed/sequenced/chr${chr}.maf05.vcf.gz ../data/raw/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
done
for chr in X; do
	bcftools view -q 0.05 -O z -o ../data/processed/sequenced/chr${chr}.maf05.vcf.gz ../data/raw/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz
done
