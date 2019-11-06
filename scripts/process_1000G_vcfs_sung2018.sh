#!/bin/bash

# Filter each chromosome for only top variants from Sung 2018
for chr in {1..22} X Y; do
	bcftools view -i 'ID=@../data/sung2018_variants.csv' -O z -o ../data/chr${chr}.sung2018subset.vcf.gz ../data/chr${chr}.vcf.gz;
done

# Concatenate chromosomes into a single VCF
bcftools concat -O z -o data/processed/all.sung2018subset.vcf.gz chr*.sung2018subset.vcf.gz 
