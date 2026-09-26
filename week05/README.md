# Generating a BAM file
Next up, is aligning the reads to the genome and creating a BAM alignment file. 

## Choosing the number of reads (N) to align
We will work with a subset of N reads, not the whole dataset. Using the genome size and the sequencing data properties, estimate the N number of reads you should download to get a coverage of at least 10x. Th goal is to check whether the number we obtain for *Aedes albopictus* is more than a million.

We use the formula below for the calculation. It is the Lander/Waterman equation found at this [link] (https://www.illumina.com/documents/products/technotes/technote_coverage_calculation.pdf):

C = LN / G

C = target coverage = 10
L = read length = 150 per read = 2 x 150 = 300 for paired end
G = genome length = 1.3 Gb for our reference [Aalb5] (https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_035046485.1/)
N = read length = ?

CG = LN; N = CG / L

N = 10(1.3 x 10^9) / 300 = 43, 333 333.33

We obtain over 43 million so we need to pivot to a different genome as this genome alignment process requires more powerful hardware than we have at our disposal.

We pivot to using Dengue Virus Serotype 4(DENV4), a pathogen which *Ae. albopictus* is a competent vector of. It has a genome size of 10.8kb. 

## Accession information for Wolbachia
The genome accession (NCBI RefSeq assembly) is GCA_031101955.1
The project accession is PRJNA1346681
From that project I chose run SRR35818859


## New selection of number of reads
N = 10 (10800) / (102 + 104) = 524.2718447

524 is very low compared to 43 million! Let's use 20 000 as we did in class. 

Write a Makefile that aligns the reads and creates a BAM file.
Run a statistics report on the BAM file.
Visualize the BAM file in IGV.



Write a README.md that a reviewer can follow. What to put in the README
Explain how you arrived at N
What percent of the reads align?
What do the alignments look like? Do the reads show errors or variations?
Is the coverage uniform?
Include the commands needed to run the Makefile and a screenshot of the BAM file in IGV.
Visualize the BAM file - The BAM file contains a wealth of information. In subsequent chapters we will explore what we can do with it. For now, visualize your well-earned BAM file in IGV.

Start IGV and load the genome as a reference. Then load the BAM file as a track. In my case, I see the following:


