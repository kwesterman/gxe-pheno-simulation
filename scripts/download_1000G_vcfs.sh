#!/bin/bash

for chr in {1..22}; do
	echo "$chr"
	curl -O ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz
	curl -O ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz.tbi
done

for chr in X; do
	echo "$chr"
	curl -O ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz
	curl -O ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr${chr}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz.tbi
done

mv *.vcf.gz *.vcf.gz.tbi ../data/raw/
