#!/bin/bash


PICARD=picard
#2020 MAC reference (includes rDNA chromosome chr_181)
curl -o data/ref_genome/Tetrahymena_thermophila_mac_assembly_v5.fasta https://tet.ciliate.org/common/downloads/tet/latest/Tetrahymena_thermophila_mac_assembly_v5.fasta
#mitchondrial reference (NCBI)
esearch -db nucleotide -query "NC_003029.1" | efetch -format fasta > data/ref_genome/NC_003029.1.fasta
#combine and index
cat data/ref_genome/Tetrahymena_thermophila_mac_assembly_v5.fasta data/ref_genome/NC_003029.1.fasta > data/ref_genome/mac_mito.fasta
bwa index data/ref_genome/mac_mito.fasta
$PICARD CreateSequenceDictionary R=data/ref_genome/mac_mito.fasta O=data/ref_genome/mac_mito.dict
