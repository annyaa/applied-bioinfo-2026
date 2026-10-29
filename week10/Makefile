# URL of the FASTA reference genome
FASTA_URL = https://ftp.ensembl.org/pub/release-116/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome.17.fa.gz

# URL of the GFF reference genome annotation
GFF_URL = https://ftp.ensembl.org/pub/release-116/gff3/homo_sapiens/Homo_sapiens.GRCh38.116.chromosome.17.gff3.gz

# Name of the reference genome
NAME = hg38_chr3

# Genome fasta file
FASTA = fasta/$(NAME).fa.gz

# GFF annotation file
GFF = gff/$(NAME).gff.gz

# SRR accession number
SRR=SRR8896956

# Sample name 
SAMPLE = ChIP-seq_Ishi_Ishi_E21hr_ER_B

# Number of reads to download
N = 10000000

# Read 1 in fastq format. 
# This run is single end sequencing.
R1 = fastq/$(SRR)_1.fastq

# BAM file derived from the sample name
BAM = bam/$(SAMPLE).bam

# BigWig coverage file
BW = bw/$(SAMPLE).bw

# BWA index sentinel
INDEX = $(FASTA).bwt

# Background sample name
BKG = ChIP_Input

# Background BAM file
BAM_BKG = bam/$(BKG).bam

# The output Peak file
PEAKS = peaks/$(SAMPLE)_peaks.broadPeak

# Current directory
DIR = $(shell pwd)

# Netcat command to send commands to IGV
NC = nc localhost 60151

# The design file
DESIGN = design.csv

# Run two jobs at a time since the alignment is already multithreadedwith 4 threads, thus using 2x4=8 cores
PARALLEL = parallel --eta --colsep , --header : --jobs 2 --lb


# --- All definitions above this line. All code below this line ---

usage:
	@echo "#"
	@echo "# ChIP-seq analysis with MACS3"
	@echo "#"
	@echo "# SRR=$(SRR)"
	@echo "# NAME=$(NAME)"
	@echo "# SAMPLE=$(SAMPLE)"
	@echo "# N=$(N)"
	@echo "#"
	@echo "# BW=$(BW)"
	@echo "# FASTA=$(FASTA)"
	@echo "# GFF=$(GFF)"
	@echo "#"
	@echo "# BAM=$(BAM)"
	@echo "# PEAKS=$(PEAKS)"
	@echo "#"
	@echo "# make all"
	@echo "#"
	@echo "# make genome"
	@echo "# make gff"
	@echo "# make fastq"
	@echo "# make align"
	@echo "# make peaks"
	@echo "# make clean"
	@echo "#"

# Download the genome.
genome: $(FASTA) $(GFF)
	@ls -lh $(FASTA)
	@ls -lh $(GFF)

# Need to uncompress and recompress to BGzip format.
$(FASTA):
	mkdir -p $(dir $@)
	curl -fsSL $(FASTA_URL) | gunzip | bgzip > $@
	samtools faidx $@
	seqkit stats $@

# Download the GFF annotation.
gff: $(GFF)
	ls -lh $(GFF)
	
# We need to unzip, sort and re-compress the GFF annotation.
# To be readable IGV and other bioinformatics tools.
$(GFF):
	mkdir -p $(dir $@)
	curl -fsSL $(GFF_URL) | gunzip | sort -k1,1 -k4,4n | bgzip > $@
	tabix -p gff $@

# Download the fastq files.
fastq: $(R1)
	@ls -lh $(R1)

$(R1):
	mkdir -p $(dir $@)
	fastq-dump -X $(N) --split-files -O $(dir $@) $(SRR)
	seqkit stats $@

# Index the genome.
index: $(INDEX)

$(INDEX): $(FASTA)
	bwa index $<

# Align the fastq files to the genome.
align: $(BAM) $(BW)
	@ls -lh $(BAM)
	@ls -lh $(BW)

$(BAM): $(INDEX) $(R1)
	mkdir -p $(dir $@)
	bwa mem -t 4 $(FASTA) $(R1) | samtools sort -o $@
	samtools index $@
	samtools flagstat $@

${BW}: $(BAM)
	mkdir -p $(dir $@)
	bamCoverage --binSize 1 --bam $< -o $@

$(PEAKS): $(BAM)
	macs3 callpeak --broad -g 3E8 --broad-cutoff 0.01 -n $(SAMPLE) -t ${BAM} -c ${BAM_BKG} --outdir peaks

peaks: $(PEAKS)
	@ls -lh $(PEAKS)

# Run all steps.
all: genome align 

# Visualize with IGV 
igv: 
	echo "new" | ${NC}
	echo "genome ${DIR}/$(FASTA)" | ${NC}
	echo "load ${DIR}/$(GFF)" | ${NC}
	# Loads up the coverage files for each sample.
	cat $(DESIGN) | $(PARALLEL) 'echo "load ${DIR}/bw/{sample}.bw" | ${NC}'

batch:
	cat $(DESIGN) | $(PARALLEL) make SRR={run_accession} SAMPLE={sample_description} all
	
# Remove some of the generated files.
clean:
	rm -rf $(R1) $(BAM) $(BAM).bai $(BW) $(PEAKS)

.PHONY: usage all genome gff fastq index align clean peaks igv
