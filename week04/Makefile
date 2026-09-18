#
# Download reads, rename them to a descriptive sample name, trim, and summarize QC.
#

ACCESSION ?= SRR1234567
SAMPLE_NAME ?= $(ACCESSION)
N ?= 10000
TYPE ?= fastq
ADAPTER ?= AGATCGGAAGAGCACACGTCTGAACTCCAGTCA

R1 = $(TYPE)/$(SAMPLE_NAME)_1.fastq
R2 = $(TYPE)/$(SAMPLE_NAME)_2.fastq
T1 = $(TYPE)/$(SAMPLE_NAME)_1.trimmed.fastq
T2 = $(TYPE)/$(SAMPLE_NAME)_2.trimmed.fastq
DOWNLOAD_DONE = $(TYPE)/.$(SAMPLE_NAME)_done

all: $(T1) $(T2)

$(TYPE):
	mkdir -p $@

$(DOWNLOAD_DONE): | $(TYPE)
	fastq-dump -N 1 -X $(N) --split-3 --outdir $(TYPE) $(ACCESSION)
	@if [ "$(ACCESSION)" != "$(SAMPLE_NAME)" ] && [ -f $(TYPE)/$(ACCESSION)_1.fastq ]; then mv $(TYPE)/$(ACCESSION)_1.fastq $(R1); fi
	@if [ "$(ACCESSION)" != "$(SAMPLE_NAME)" ] && [ -f $(TYPE)/$(ACCESSION)_2.fastq ]; then mv $(TYPE)/$(ACCESSION)_2.fastq $(R2); fi
	@if [ "$(ACCESSION)" != "$(SAMPLE_NAME)" ] && [ -f $(TYPE)/$(ACCESSION).fastq ]; then mv $(TYPE)/$(ACCESSION).fastq $(TYPE)/$(SAMPLE_NAME).fastq; fi
	@touch $@

$(T1) $(T2): $(DOWNLOAD_DONE)
	fastp --adapter_sequence=$(ADAPTER) \
	      --cut_tail \
	      -i $(R1) -I $(R2) \
	      -o $(T1) -O $(T2)

qc: $(T1) $(T2)
	@echo "Running seqkit stats..."
	seqkit stats $(TYPE)/$(SAMPLE_NAME)*.fastq > $(TYPE)/$(SAMPLE_NAME)_stats.txt
	@echo "Running fastqc..."
	fastqc $(TYPE)/$(SAMPLE_NAME)*.fastq
	@echo "Running multiqc..."
	multiqc .

clean:
	rm -rf $(TYPE) multiqc_data multiqc_report.html

.PHONY: all clean qc
