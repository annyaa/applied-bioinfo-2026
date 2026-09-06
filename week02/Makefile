#
# Download genomic data from NCBI, one directory per type.
# Index FASTA (samtools faidx) and GFF (bgzip + tabix) for IGV.
#

BASE = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/035/046/485/GCF_035046485.1_AalbF5
ACC = GCF_035046485.1_AalbF5
NAME = Albopictus

FA_GZ = fasta/${NAME}.fna.gz
FA = fasta/${NAME}.fa
GFF = gff/${NAME}.gff.gz

all: ${FA}.fai ${GFF}.tbi

fasta gff:
	mkdir -p $@

${FA_GZ}: | fasta
	curl -L ${BASE}/${ACC}_genomic.fna.gz -o $@

${GFF}: | gff
	curl -L ${BASE}/${ACC}_genomic.gff.gz -o $@

${FA}: ${FA_GZ}
	gunzip -c $< > $@

${FA}.fai: ${FA}
	samtools faidx $<

${GFF}.tbi: ${GFF}
	gunzip -c ${GFF} > gff/${NAME}.gff
	(grep '^#' gff/${NAME}.gff; grep -v '^#' gff/${NAME}.gff | sort -k1,1 -k4,4n) | bgzip > ${GFF}.tmp
	mv ${GFF}.tmp ${GFF}
	rm -f gff/${NAME}.gff
	tabix -p gff ${GFF}

clean:
	rm -rf fasta gff

.PHONY: all clean
