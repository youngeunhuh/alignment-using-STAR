# alignment-using-STAR

#! bin/bash

wget ftp://ftp.ensembl.org/pub/release-92/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz
gunzip Mus_musculus.GRCm38.dna.primary_assembly.fa.gz

wget ftp://ftp.ensembl.org/pub/release-92/gtf/mus_musculus/Mus_musculus.GRCm38.92.gtf.gz
gunzip Mus_musculus.GRCm38.92.gtf.gz

mkdir ref_mouse

STAR --runThreadN 6 --runMode genomeGenerate --genomeDir ./ref_mouse --genomeFastaFiles ./Mus_musculus.GRCm38.dna.primary_assembly.fa

STAR --runThreadN 6 --genomeDir ./ref_mouse --sjdbGTFfile ./Mus_musculus.GRCm38.92.gtf --sjdbOverhang 100 \
--readFilesIn CRND8_12m_129_pool2_5_S5_R1_001.fastq.gz CRND8_12m_129_pool2_5_S5_R2_001.fastq.gz --readFilesCommand zcat \
--quantMode TranscriptomeSAM GeneCounts --outFileNamePrefix Q_NTG_129.
