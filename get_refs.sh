#!/usr/bin/env bash

set -euo pipefail

# PAO1
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/765/GCF_000006765.1_ASM676v1/GCF_000006765.1_ASM676v1_genomic.gbff.gz && gunzip GCF_000006765.1_ASM676v1_genomic.gbff.gz
mv GCF_000006765.1_ASM676v1_genomic.gbff PAO1.gbff
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/006/765/GCF_000006765.1_ASM676v1/GCF_000006765.1_ASM676v1_genomic.fna.gz && gunzip GCF_000006765.1_ASM676v1_genomic.fna.gz
mv GCF_000006765.1_ASM676v1_genomic.fna PAO1.fna

# PA14
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/014/625/GCF_000014625.1_ASM1462v1/GCF_000014625.1_ASM1462v1_genomic.gbff.gz && gunzip GCF_000014625.1_ASM1462v1_genomic.gbff.gz
mv GCF_000014625.1_ASM1462v1_genomic.gbff PA14.gbff
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/014/625/GCF_000014625.1_ASM1462v1/GCF_000014625.1_ASM1462v1_genomic.fna.gz && gunzip GCF_000014625.1_ASM1462v1_genomic.fna.gz
mv GCF_000014625.1_ASM1462v1_genomic.fna PA14.fna

# PA7
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/017/205/GCF_000017205.1_ASM1720v1/GCF_000017205.1_ASM1720v1_genomic.gbff.gz && gunzip GCF_000017205.1_ASM1720v1_genomic.gbff.gz
mv GCF_000017205.1_ASM1720v1_genomic.gbff PA7.gbff
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/017/205/GCF_000017205.1_ASM1720v1/GCF_000017205.1_ASM1720v1_genomic.fna.gz && gunzip GCF_000017205.1_ASM1720v1_genomic.fna.gz
mv GCF_000017205.1_ASM1720v1_genomic.fna PA7.fna
