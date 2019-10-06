#!/bin/bash

# Filter each chromosome for only top variants from Sung 2018
for chr in {1..22} X Y; do
	bcftools view -i 'ID=@data/processed/sung2018_variants.csv' -O z -o data/processed/chr${chr}.maf05.sung2018subset.vcf.gz ../1000G_data/chr${chr}.maf05.vcf.gz;
done

# Concatenate chromosomes into a single VCF
bcftools concat -O z -o data/processed/all.maf05.sung2018subset.vcf.gz chr*.maf05.sung2018subset.vcf.gz 
