#! /bin/bash

set -x

# make working directory
mkdir PRACTICE
cd ./PRACTICE

# STAR installation
if ! [ -d /github/STAR ]
then
    git clone https://github.com/alexdobin/STAR.git
    cd STAR/source
    make STAR
    export PATH=$PATH:/github/STAR/bin/Linux_x86_64
fi

# Download READ
READ1=`wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR201/005/SRR2015735/SRR2015735_1.fastq.gz`
READ2=`wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR201/005/SRR2015735/SRR2015735_2.fastq.gz`

# Download reference genome
if ! [ -e ./Mus_musculus.GRCm38.dna.primary_assembly.fa ]
then
    wget  ftp://ftp.ensembl.org/pub/release-92/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz
    gunzip Mus_musculus.GRCm38.dna.primary_assembly.fa.gz
fi

# Download annotation file
if ! [ -e ./Mus_musculus.GRCm38.92.gtf ]
then
    wget ftp://ftp.ensembl.org/pub/release-92/gtf/mus_musculus/Mus_musculus.GRCm38.92.gtf.gz
    gunzip Mus_musculus.GRCm38.92.gtf.gz
fi

# Indexing
if ! [ -d ref_mouse ]
then
    mkdir ref_mouse
fi
STAR --runThreadN 6 --runMode genomeGenerate --genomeDir ./ref_mouse --genomeFastaFiles ./Mus_musculus.GRCm38.dna.primary_assembly.fa

# Alignment
STAR --runThreadN 6 --genomeDir ./ref_mouse --sjdbGTFfile ./Mus_musculus.GRCm38.92.gtf --sjdbOverhang 100 \
     --readFilesIn $READ1 $READ2 --readFilesCommand zcat --quantMode TranscriptomeSAM GeneCounts --outFileNamePrefix READ.

mkdir SRR
mv READ* -t SRR
