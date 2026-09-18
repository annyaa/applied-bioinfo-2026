# Obtaining FASTQ data from SRA
This week, we will locate and download FASTQ files for *Aedes albopictus* genome, which we selected and visualized in week 2. 

## Assessing the experimental evidence for the *Aedes albopictus* genome
This genome has **13, 840** datasets available in SRA.

## Break down by sequencing platform
- BGISEQ(390)
- Capillary(7)
- Illumina(12,972)
- Ion Torrent(2)
- LS454(73)
- Oxford Nanopore(13)
- PacBio SMRT(344)

## Break down by sequencing strategy 
- EpiGenomics(1)
- Exome(62)
- Genome(1,413)
- RNASeq(2)
- other(12,362)

## Break down by file type
- bam(1,469)
- fastq(11,696)
- sff(18)

## Interesting details
I am surprised by how many larval studies there are. Additionally, it is interesting to see so many efforts to characterize the mosquito virome. 





Download FASTQ files for an experiment¶
Add commands to your Makefile so that it can download a subset of reads from the SRA based on an accession number. Don't download the entire dataset, just a subset defined by an N parameter (the number of reads to download).

The Makefile should download the first N reads from an SRR accession.
Place the files in directories named after the data type.
Run a QC visualization on the downloaded reads to generate a report.
Apply a QC method to the reads to see whether it makes a visual difference.
Run a QC visualization on the trimmed reads to generate a report.
Discuss whether the QC step made a difference.

Make your Makefile generic enough to download reads from different sequencing platforms by changing the accession number alone.

Recommendation¶
Rename the FASTQ files from SRR numbers to more descriptive names that are easier to read.

The metadata fields usually carry information about the sample name.
