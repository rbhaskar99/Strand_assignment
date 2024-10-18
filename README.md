# Strand_assignment
# RNA-Seq Contaminant Detection Pipeline

RNA-Seq Contaminant Detection Pipeline is made to process RNA-Seq data to detect potential contaminants using the `fastv` tool. It performs both global and localized contaminant detection against microbial databases.

## Overview

The pipeline consists of the following key steps:
1. **Downsampling**: Downsamples 1 million reads from each paired-end RNA-Seq sample using `seqtk`.
2. **Global Contaminant Detection**: Compares the downsampled reads against a global k-mer database of microbial contaminants.
3. **Localized Contaminant Detection**: Compares the downsampled reads against the k-mer and genome FASTA files of *Prevotella nigrescens*.

## Requirements

- **Nextflow**: Ensure you have Nextflow installed. You can install it using:
  ```bash
  curl -s https://get.nextflow.io | bash
- seqtk: For downsampling the FASTQ files. Install it usinhg pip.install seqtk
- fastv: For contaminant detection. Install it from https://github.com/OpenGene/fastv

## Downloading FASTQ Files

You can download the required `fastq.gz` files using the terminal with the `wget` command. Here are the commands to download the RNA-Seq sample files directly:

### RNA-Seq Sample Downloads

Open your terminal and execute the following commands:

```bash
# Create a directory for the data
mkdir -p data
cd data

# Download the FASTQ files for Sample 1
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR252/043/SRR25233843/SRR25233843_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR252/043/SRR25233843/SRR25233843_2.fastq.gz

# Download the FASTQ files for Sample 2
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR252/031/SRR25233831/SRR25233831_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR252/031/SRR25233831/SRR25233831_2.fastq.gz

# Download the k-mer and genome FASTA files for Prevotella nigrescens
wget http://opengene.org/microbial.kc.fasta.gz
wget https://opengene.org/uniquekmer/microbial/genomes_kmers/27/Prevotella_nigrescens_F0103_uid43119.kmer.fasta
wget https://opengene.org/uniquekmer/microbial/genomes_kmers/27/Prevotella_nigrescens_F0103_uid43119.fasta
