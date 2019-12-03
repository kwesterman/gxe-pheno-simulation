#!/bin/bash


# Subset each chromosome to MAF > 0.01
for chr in {1..22} X; do
	bcftools view -q 0.01 -O z -o ../data/processed/imputed/chr${chr}.dose.vcf.gz ../data/processed/imputed/chr${chr}_maf01.dose.vcf.gz
done
