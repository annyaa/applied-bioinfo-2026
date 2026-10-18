# Interpreting a multisample VCF file
This task aims to generate a multisample VCF file based on the genome selected. Using at least three samples, annotate a few of the variants to try to tell what effect the change has on the protein.

To do this, start with the previous Makefile and add the annotation steps.


Run the Makefile iteratively in terminal. 

```
make align SRR=SRR35818875 SAMPLE_NAME=denv4_samp1
make align SRR=SRR35818873 SAMPLE_NAME=denv4_samp2
make align SRR=SRR35818859 SAMPLE_NAME=denv4_samp3
make align SRR=SRR35818860 SAMPLE_NAME=denv4_samp4
make align SRR=SRR35818861 SAMPLE_NAME=denv4_samp5
make align SRR=SRR35818866 SAMPLE_NAME=denv4_samp6
make align SRR=SRR35818878 SAMPLE_NAME=denv4_samp7
make align SRR=SRR35818863 SAMPLE_NAME=denv4_samp8
```


Pass all bam files into mpileup at once

```
bcftools mpileup -d 100 --annotate 'INFO/AD,FORMAT/DP,FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/SP' -O u -f fasta/dengue_virus.fasta \
    bam/denv4_samp1.bam \
    bam/denv4_samp2.bam \
    bam/denv4_samp3.bam \
    bam/denv4_samp4.bam \
    bam/denv4_samp5.bam \
    bam/denv4_samp6.bam \
    bam/denv4_samp7.bam \
    bam/denv4_samp8.bam | \
    bcftools call --ploidy 1 --annotate 'FORMAT/GQ' -mv -O u | \
    bcftools norm -f fasta/dengue_virus.fasta -d all -O u | \
    bcftools sort --write-index -O z -o vcf/dengue_multisample.vcf.gz
```

## Annotate a few variants
Select a few variants that fall in a coding sequence. If the VCF has none, choose a different sample.
Predict the effect of each variant either by eye or with a software tool.

### Initial view

![varpred1](images/varpred1.png)

![varpred2](images/varpred2.png)

![varpred3](images/varpred3.png)

![varpred4](images/varpred4.png)


## Variant 1

Reference: A
alternate: C
Original: ACA = Threonine(T)

![varpred5](images/varpred5.png)

![varpred6](images/varpred6.png)


- **Sample 1**

Reference: A
Variant: A

**No change in amino acid**

![varpred7](images/varpred7.png)


- **Sample 2**

Zero coverage across all regions. Perhaps a faulty or mismatched sample.

![varpred8](images/varpred8.png)


- **Sample 3**

Reference: A
Variant: C
Original: ACA = Threonine(T)
New amino acid: CCA = Proline (P) = **nonsynonymous variation**




- **Sample 4**

Reference: A
Variant: C
Original: ACA = Threonine(T)
New amino acid: CCA = Proline (P) = **nonsynonymous variation**

- **Sample 5**

Reference: A
Variant: C
Original: ACA = Threonine(T)
New amino acid: CCA = Proline (P) = **nonsynonymous variation**

- **Sample 6**

Reference: A
Variant: C
Original: ACA = Threonine(T)
New amino acid: CCA = Proline (P) = **nonsynonymous variation**

- **Sample 7**

Reference: A
Variant: C
Original: ACA = Threonine(T)
New amino acid: CCA = Proline (P) = **nonsynonymous variation**

- **Sample 8**

Reference: A
Variant: C
Original: ACA = Threonine(T)
New amino acid: CCA = Proline (P) = **nonsynonymous variation**


## Variant 2

Reference: T
alternate: C
Original: TTT = Phenylalanine(F)

![varpred10](images/varpred10.png)

![varpred11](images/varpred11.png)


- **Sample 1**

Reference: T
Variant: C
Original: TTT = Phenylalanine(F)
New amino acid: CTT = Leucine (L) = **nonsynonymous variation**

![varpred12](images/varpred7.png)


- **Sample 2**

Zero coverage across all regions. Perhaps a faulty or mismatched sample.

![varpred8](images/varpred8.png)


- **Sample 3**

Reference: T
Variant: C

**No change in amino acid**

![varpred13](images/varpred13.png)


- **Sample 4**

Reference: T
Variant: C

**No change in amino acid**

- **Sample 5**

Reference: T
Variant: C

**No change in amino acid**

- **Sample 6**

Reference: A
Reference: T
Variant: C

**No change in amino acid**

- **Sample 7**

Reference: T
Variant: C

**No change in amino acid**

- **Sample 8**

Reference: T
Variant: C

**No change in amino acid**




Which variants did you annotate, and which gene does each one fall in?
For each variant, what is the reference codon, the alternate codon, and the amino acid change?
Include the commands needed to run the Makefile, a screenshot of one variant lined up with the translated coding sequence in IGV, and the software output for that variant.
