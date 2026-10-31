# Generate peak calls for ChIP-Seq/ATAC seq

This week, we reuse a previously built a pipeline that calls variants for many samples from a design file. However, for sequencing data, we select ChIP-seq or ATAC-seq, and replace the variant call with peak calling.


## Selected Project summary

The project used in building the prior pipeline did not have CHIP-Seq/ ATAC-seq data, so I have selected a new project.
The project is based on a paper by [Rodriguez et al(2020)](https://aacrjournals.org/cancerres/article/80/6/1234/647756/ETV4-Is-Necessary-for-Estrogen-Signaling-and) titled **"ETV4 Is Necessary for Estrogen Signaling and Growth in Endometrial Cancer Cells"**

The goal of the project is to enhance understanding of the molecular mechanisms benind the role the estrogen receptor alpha (ER) plays in regulating endometrial cancer. Specifically, the aim is to understand the transcription factors that control genomic binding of the ER in endometrial cancer cells 

The [Bioproject](https://www.ncbi.nlm.nih.gov/bioproject/?term=GSE129803) for this study is **PRJNA532875**.

We focus on analyzing **ChIP-seq** data from NCBI using the accession GSE129803 but RNA-seq (GSE129804) and ATAC-seq (GSE129802) data are also available.

The project used the following cells:

- Ishikawa cells - endometrial carcinoma 
- T-47D cells - breast carcinoma

Treatments involved:

- Control: DMSO
- ChIP-seq: 10 nmol/L E2 for 1 hour 

The authors performed ChIP-seq to map ER genomic binding in 5 endometrial cancer xenografts and combined this data with published ER ChIP-seq data sets to obtain 9 breast tumors and 10 endometrial tumors in total. 

**Main finding from the study:** The authoprs concluded that the transcription factor ETV4 is important for estrogen signaling in endometrial cancer cells.


## Reproducing the workflow

Create the design file
```
bio search -H -csv PRJNA532875 > design.csv
```

Since **ETV4 is found on chromosome 17**, download the genome sequence of chromosome 17 from the Ensembl FTP server.

**single sample**

```
make all
```

**try a different sample from the one specified in makefile**

```
# Run each sample separately.
make SRR=SRR8896964 SAMPLE=ChIP-seq_Ishi_ETV4KO1_E21hr_ER_B all
```

**After testing that the makefile works on a different sample, run on all samples**

```
# Run the batch target
make batch
```

## call peaks

Ensure `macs3` is added to `pixi`

**single sample**

In the makefile, we used `ChIP-seq_Ishi_Ishi_E21hr_ER_B` so to call peaks on this single input sample, the specify `BKG = ChIP-seq_Ishi_Ishi_DMSO_Input` in the makefile and run:

```
make SAMPLE=ChIP-seq_Ishi_Ishi_E21hr_ER_B peaks
```

**run for all samples**

There are two different controls used, specifically:

- ChIP-seq_Ishi_Ishi_DMSO_Input (Control for the Ishikawa cell line samples)
- ChIP-seq_Ishi_T47D_DMSO_Input (Control for the T47D cell line samples)  

Thus, we have to use a dynamic approach to linking the background control. Here is the updated version in the makefile (created with help from Gemini):

```
# Dynamically route to the correct background based on the sample name
BKG = $(if $(findstring T47D,$(SAMPLE)),ChIP-seq_Ishi_T47D_DMSO_Input,ChIP-seq_Ishi_Ishi_DMSO_Input)

# Background BAM file
BAM_BKG = bam/$(BKG).bam
```

Now, we can run on all treatment samples, keeping in mind this helpful note from Gemini to explain why it is necessary to filter out anything with "Input" in peak calling:

*"ensure your parallel grep -v filter excludes both of them when calling peaks (an input cannot call peaks on itself)"*

```
cat design.csv | grep -v "Input" | parallel --eta --lb --colsep , --header : make SAMPLE={sample_description} peaks
```

## Peak calling results

Below, we load the coverage tracks and the peak files generated for each sample in IGV and compare the calls within each replicate group.

### Initial view after loading coverage files in igv:

![chip1](images/chip1.png)

### Apply distinct coloring to identify locations of interest:

![chip2](images/chip2.png)

![chip3](images/chip3.png)

### Initial view after loading peak files

![chip10](images/chip10.png)

![chip11](images/chip11.png)

### Coverage at position 23,579,698 - 59,6777,745

![chip4](images/chip4.png)

![chip5](images/chip5.png)

### Peaks at 23,312,084 - 59,945,357

![chip12](images/chip12.png)

![chip13](images/chip13.png)

### Coverage at position 41,346,707 - 41,910,738

![chip6](images/chip6.png)

![chip7](images/chip7.png)

### Peaks at 41,342,524 - 41,914,918

![chip14](images/chip14.png)

![chip15](images/chip15.png)

### Position 41,619,909 - 41,637,534

![chip8](images/chip8.png)

![chip9](images/chip9.png)

### Peaks at 41,619,778 - 41,637,664

![chip16](images/chip16.png)

![chip17](images/chip17.png)

![chip18](images/chip18.png)

![chip19](images/chip19.png)

How many peaks were called in each sample?
How consistent are the peak calls within replicates? Show one region where the replicates agree and one region where they do not.
Include screenshots of both regions from IGV.
