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

# BAM file derived from the sample name
BAM = bam/$(SAMPLE_NAME).bam

# BWA index sentinel
INDEX = $(GENOME_FASTA).bwt

# The output VCF file.
VCF=vcf/$(SAMPLE_NAME).vcf.gz

# Annotation parameters for the mpileup command
ANN=-d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'

# Call parameters for the call command
CALL=--ploidy 2 --annotate 'FORMAT/GQ' 

# Current directory
DIR = $(shell pwd)

# Netcat command to send commands to IGV
NC = nc localhost 60151

# --- All definitions above this line. All code below this line ---

usage:
	@echo "#"
	@echo "# Variant calling with bcftools"
	@echo "#"
	@echo "# GENOME_NAME=$(GENOME_NAME)"
	@echo "# GENOME_FASTA=$(GENOME_FASTA)"
	@echo "# SAMPLE_NAME=$(SAMPLE_NAME)"
	@echo "# SRR=$(SRR)"
	@echo "# N=$(N)"
	@echo "#"
	@echo "# BAM=$(BAM)"
	@echo "# VCF=$(VCF)"
	@echo "#"
	@echo "# make all"
	@echo "#"

# Download the genome.
genome: $(GENOME_FASTA)

$(GENOME_FASTA):
	mkdir -p $(dir $@)
	curl -fsSL $(GCF_URL) | gunzip > $@
	seqkit stats $@

# Download the fastq files.
fastq: $(FASTQ_1) $(FASTQ_2)

$(FASTQ_1) $(FASTQ_2):
	mkdir -p $(dir $@)
	fastq-dump -X $(N) --split-files -O $(dir $@) $(SRR)
	mv $(dir $@)$(SRR)_1.fastq $(FASTQ_1)
	mv $(dir $@)$(SRR)_2.fastq $(FASTQ_2)
	seqkit stats $(FASTQ_1) $(FASTQ_2)

# Index the genome.
index: $(INDEX)

$(INDEX): $(GENOME_FASTA)
	bwa index $<

# Align the fastq files to the genome.
align: $(BAM)

$(BAM): $(INDEX) $(FASTQ_1) $(FASTQ_2)
	mkdir -p $(dir $@)
	bwa mem $(GENOME_FASTA) $(FASTQ_1) $(FASTQ_2) | samtools sort -o $@
	samtools index $@
	samtools flagstat $@

# Call the variants.
call: $(VCF)

# Create the VCF file
$(VCF): $(BAM) $(GENOME_FASTA)
	# Create the directory for the VCF file.
	mkdir -p $(dir $@)

	# Run the variant calling process.
	bcftools mpileup ${ANN} -O u -f $(GENOME_FASTA) $(BAM) | \
		bcftools call $(CALL) -mv -O u | \
		bcftools norm -f $(GENOME_FASTA) -d all -O u | \
		bcftools sort --write-index -O z -o $(VCF)

# Run all steps.
all: $(VCF)
	ls -lh $(VCF)

# Visualize with IGV 
igv: fastq align ${BAM}
	echo "new" | ${NC}
	echo "genome ${DIR}/$(GENOME_FASTA)" | ${NC}
	echo "load ${DIR}/$(BAM)" | ${NC}
	echo "load ${DIR}/$(VCF)" | ${NC}

# Remove some of the generated files.
clean:
	rm -rf $(FASTQ_1) $(FASTQ_2) $(BAM) $(BAM).bai $(VCF) $(VCF).tbi

.PHONY: usage all genome fastq index align clean call igv
