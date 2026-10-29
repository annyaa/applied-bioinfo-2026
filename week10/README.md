# Generate peak calls for ChIP-Seq/ATAC seq


https://aacrjournals.org/cancerres/article/80/6/1234/647756/ETV4-Is-Necessary-for-Estrogen-Signaling-and

https://www.ncbi.nlm.nih.gov/bioproject/?term=GSE129803 

## Find a BioProject with ChIP-seq or ATAC-seq reads for the genome you have been using. The project should have at least two replicates in both groups.

- Bioproject: **PRJNA532875**

Create the design file
```
bio search -H -csv PRJNA532875 > runinfo.csv
```

**ETV4 is found on chromosome 17**


### reproduce workflow
run `make all` in an environment with `deeptools`

verify that all sequences are chipseq and rename runinfo to design.csv since it will work as the design file


Create a design.csv describing the samples and their groups.
Generate peak calls for each sample.
Load the coverage tracks and the peak files in IGV and compare the calls within each replicate group.
Write a README.md that a reviewer can follow.
Implementation suggestions:

Since peak calling requires both a background and a condition you might want to add a background target to the Makefile to process the background samples. Many solutions are possible here.

make background could run the workflow for the background samples.
make peaks could call peaks for a condition relative to the background.
It is not required to do it this way. It is just a suggestion.


## README CONTENTS

Summarize the project: the assay, the organism, how many samples, and what the control and the condition are.
Describe how to run the workflow so a reviewer can reproduce it.
How many peaks were called in each sample?
How consistent are the peak calls within replicates? Show one region where the replicates agree and one region where they do not.
Include screenshots of both regions from IGV.

**single sample**

```
make all
```

**try ano0ther sample**

```
# Run each sample separately.
make SRR=SRR8896964 SAMPLE=ChIP-seq_Ishi_T47D_DMSO_Input all
```

after testing that it works on a different sample, run on all samples

```
# Run the batch target
make batch
```

## call peaks

single input sample

```
make peaks
```

**run for all samples**

```
cat design.csv | parallel --eta --lb --colsep , --header : make SAMPLE={sample} peaks
```


cat << 'EOF' > .gitignore
fasta/
fastq/
bam/
gff/
bw/
EOF
