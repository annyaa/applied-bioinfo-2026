# Parameter definitions to match repository info & enhance trackability

# URL of reference
GCF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/862/125/GCF_000862125.1_ViralProj15306/GCF_000862125.1_ViralProj15306_genomic.fna.gz

# Name of ref
GENOME_NAME = dengue_virus

# name of the genome FASTA file on my machine
GENOME_FASTA = fasta/$(GENOME_NAME).fasta

#SRA run accession number (changed from SRR35818859)
SRR = SRR35818875

# Number of reads to download
N = 20000

# Sample name TO IMPROVE USER FRIENDLINESS
SAMPLE_NAME = denv4_samp1

# Fastq files (Raw)
FASTQ_1 = fastq/$(SAMPLE_NAME)_1.fastq
FASTQ_2 = fastq/$(SAMPLE_NAME)_2.fastq

# Fastq files (Trimmed)
TRIM_1 = fastq/$(SAMPLE_NAME)_1.trimmed.fastq
TRIM_2 = fastq/$(SAMPLE_NAME)_2.trimmed.fastq

# The adapter sequence
ADAPTER = AGATCGGAAGAGCACACGTCTGAACTCCAGTCA

# Output BAM file for alignments derived from sample name
BAM = bam/$(SAMPLE_NAME).bam

# BWA index sentinel
INDEX = $(GENOME_FASTA).bwt

# ---------- definitions go above this line, code below -------

usage:
	@echo " # Read the source code"

# Run all steps.
all: genome fastq trim index align qc

# Download the genome
genome: $(GENOME_FASTA)

$(GENOME_FASTA):
	mkdir -p $(dir $@)
	curl -fsSL $(GCF_URL) | gunzip > $@
	seqkit stats $@
	
# Download and rename the fastq files.
fastq: $(FASTQ_1) $(FASTQ_2)

$(FASTQ_1) $(FASTQ_2):
	mkdir -p $(dir $@)
	fastq-dump -X $(N) --split-3 -O $(dir $@) $(SRR)
	@if [ "$(SRR)" != "$(SAMPLE_NAME)" ]; then mv $(dir $@)$(SRR)_1.fastq $(FASTQ_1); mv $(dir $@)$(SRR)_2.fastq $(FASTQ_2); fi

# Trim the fastq files.
trim: $(TRIM_1) $(TRIM_2)

$(TRIM_1) $(TRIM_2): $(FASTQ_1) $(FASTQ_2)
	fastp --adapter_sequence=$(ADAPTER) --cut_tail -i $(FASTQ_1) -I $(FASTQ_2) -o $(TRIM_1) -O $(TRIM_2)

# Index the genome.
index: $(INDEX)

$(INDEX): $(GENOME_FASTA)
	bwa index $<

# Align the fastq files to the genome.
align: $(BAM)

$(BAM): $(INDEX) $(TRIM_1) $(TRIM_2)
	mkdir -p $(dir $@)
	bwa mem $(GENOME_FASTA) $(TRIM_1) $(TRIM_2) | samtools sort -o $@
	samtools index $@
	samtools flagstat $@ > bam/$(SAMPLE_NAME)_flagstat.txt
	samtools coverage $@ > bam/$(SAMPLE_NAME)_coverage.txt

# Quality Control
qc: $(TRIM_1) $(TRIM_2) $(BAM)
	seqkit stats fastq/$(SAMPLE_NAME)*.fastq > fastq/$(SAMPLE_NAME)_stats.txt
	fastqc fastq/$(SAMPLE_NAME)*.fastq
	multiqc .

# Remove generated files.
clean:
	rm -rf fastq/ bam/ fasta/ multiqc_data multiqc_report.html fastp.html fastp.json

.PHONY: usage all genome fastq trim index align qc clean
