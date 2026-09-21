# Obtaining FASTQ data from SRA
This week, we will locate and download FASTQ files for the *Aedes albopictus* genome, which we selected and visualized in week 2. The NCBI RefSeq assembly is `GCF_035046485.1`.

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


## Download FASTQ files for an experiment
In the Makefile are commands for downloading a subset of reads from the SRA based on an accession number **(SRR40532399)**. The project number is `PRJNA1524040`. This will **not** download the entire dataset. Instead we obtain just a subset defined by an N parameter (the number of reads to download).


# Quality control

## The following steps were performed for quality control: 
- Run a QC visualization on the downloaded reads to generate a report.
- Apply a QC method to the reads to see whether it makes a visual difference.
- Run a QC visualization on the trimmed reads to generate a report.


## Did the QC step make a difference?

Upon inspecting the fatsp and multiqc reports, I do not think the QC step made a difference. I examined metrics such as the read quality, sequence quality, base contents, kmer counts and N content.


## How to replicate the above 
Activate bioinfo and run `pixi add multiqc` before running the `make` command as follows:

```
make qc ACCESSION=SRR40532399 SAMPLE_NAME=Aedes_albo_samp1 N=100000
```
