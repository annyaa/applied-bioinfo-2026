# Parameter definitions to match repository info & enhance trackability

# URL of reference
GCF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/862/125/GCF_000862125.1_ViralProj15306/GCF_000862125.1_ViralProj15306_genomic.fna.gz

# URL of the GFF reference genome annotation
GFF_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/862/125/GCF_000862125.1_ViralProj15306/GCF_000862125.1_ViralProj15306_genomic.gff.gz

# Name of ref
GENOME_NAME = dengue_virus

# name of the genome FASTA file on my machine
GENOME_FASTA = fasta/$(GENOME_NAME).fasta

# GFF annotation file
GFF = gff/$(GENOME_NAME).gff

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

# The output VCF file including the version with all variants merged
VCF=vcf/$(SAMPLE_NAME).vcf.gz
MULTI_VCF=vcf/dengue_multisample.vcf.gz

# Annotation parameters for the mpileup command
ANN=-d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP'

# Call parameters for the call command
CALL=--ploidy 2 --annotate 'FORMAT/GQ'

# Current directory
DIR = $(shell pwd)

# Netcat command to send commands to IGV
NC = nc localhost 60151

# The design file
DESIGN = design.csv

# The parallel command to run the workflow with
PARALLEL = parallel --colsep , --header : --eta -j 4


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
	mv $(dir $@)$(SRR)_1.fastq $(FASTQ_1)
	mv $(dir $@)$(SRR)_2.fastq $(FASTQ_2)
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
all: gff $(VCF)
	ls -lh $(VCF)

		
# Run the workflow using the filtered design file to create a single VCF
batch: genome gff
	# 1. Run parallel, but ONLY to the 'align' target to generate BAMs
	(head -n 1 ${DESIGN}; grep -i "GENOMIC" ${DESIGN} | head -n 10) | ${PARALLEL} \
		make \
		SRR={run_accession} \
		SAMPLE_NAME={sample_alias} \
		N=20000 \
		align

	# 2. Once all BAMs exist, run joint variant calling on all of them at once
	# Note: ploidy is overridden to 1 for haploid viral genomes
	mkdir -p vcf
	bcftools mpileup ${ANN} -O u -f $(GENOME_FASTA) bam/*.bam | \
		bcftools call --ploidy 1 --annotate 'FORMAT/GQ' -mv -O u | \
		bcftools norm -f $(GENOME_FASTA) -d all -O u | \
		bcftools sort --write-index -O z -o $(MULTI_VCF)
		
	ls -lh $(MULTI_VCF)
		
		
		

# Visualize with IGV
igv: fastq align ${BAM} $(GFF)
	echo "new" | ${NC}
	echo "genome ${DIR}/$(GENOME_FASTA)" | ${NC}
	echo "load ${DIR}/$(BAM)" | ${NC}
	echo "load ${DIR}/$(VCF)" | ${NC}
	echo "load ${DIR}/$(VCF)" | ${NC}
	echo "load ${DIR}/$(GFF)" | ${NC}

# Remove some of the generated files.
clean:
	rm -rf $(FASTQ_1) $(FASTQ_2) $(BAM) $(BAM).bai $(VCF) $(VCF).tbi

.PHONY: usage all genome fastq index align clean call igv batch

