# URL of the FASTA reference genome
GCF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.fna.gz

# URL of the GFF reference genome annotation
GFF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/848/505/GCF_000848505.1_ViralProj14703/GCF_000848505.1_ViralProj14703_genomic.gff.gz

# Name of the reference genome
GENOME_NAME = ebola_1976

# Genome fasta file
GENOME_FASTA = fasta/$(GENOME_NAME).fasta

# GFF annotation file
GFF = gff/$(GENOME_NAME).gff

# SRR accession number
SRR=SRR1553425

# Number of reads to download
N = 20000

# Fastq files
FASTQ_1 = fastq/$(SRR)_1.fastq
FASTQ_2 = fastq/$(SRR)_2.fastq

# Sample name 
SAMPLE_NAME = EM100

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

# Download the GFF annotation.
gff: $(GFF)
	ls -lh $(GFF)

# We need to unzip, sort and re-compress the GFF annotation.
# To be readable IGV and other bioinformatics tools.
$(GFF):
	mkdir -p $(dir $@)
	curl -fsSL $(GFF_URL) | gunzip -c > $@

# Download the fastq files.
fastq: $(FASTQ_1) $(FASTQ_2)

$(FASTQ_1) $(FASTQ_2):
	mkdir -p $(dir $@)
	fastq-dump -X $(N) --split-files -O $(dir $@) $(SRR)
	seqkit stats $(FASTQ_1) $(FASTQ_2)

# Index the genome.
index: $(INDEX)

$(INDEX): $(GENOME_FASTA)
	bwa index $<

# Align the fastq files to the genome.
align: $(BAM)
	ls -lh $(BAM)

$(BAM): $(INDEX) $(FASTQ_1) $(FASTQ_2)
	mkdir -p $(dir $@)
	bwa mem $(GENOME_FASTA) $(FASTQ_1) $(FASTQ_2) | samtools sort -o $@
	samtools index $@
	samtools flagstat $@

# Call the variants.
call: $(VCF)
	ls -lh $(VCF)

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
all: gff genome call 

# Visualize with IGV 
igv: fastq align ${BAM} $(GFF)
	echo "new" | ${NC}
	echo "genome ${DIR}/$(GENOME_FASTA)" | ${NC}
	echo "load ${DIR}/$(BAM)" | ${NC}
	echo "load ${DIR}/$(VCF)" | ${NC}
	echo "load ${DIR}/$(GFF)" | ${NC}
	
# Remove some of the generated files.
clean:
	rm -rf $(FASTQ_1) $(FASTQ_2) $(BAM) $(BAM).bai $(VCF) $(VCF).tbi

.PHONY: usage all genome fastq index align clean call igv