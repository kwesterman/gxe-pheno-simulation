#!/bin/bash


# Subset each chromosome to MAF > 0.05
for chr in {1..22} X Y; do
	bcftools view -q 0.05 -O z -o chr${chr}.maf05.vcf.gz ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz;
done
