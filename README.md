# Differential gene expression analysis of *E. coli* BW25113 WT vs ΔslyA

## Overview
This project presents a complete **RNA-seq analysis workflow** performed on public bacterial transcriptomic data from *Escherichia coli* BW25113. The objective was to compare **wild-type (WT)** samples with a **ΔslyA mutant** in order to identify differentially expressed genes associated with the deletion of `slyA`.

This project was carried out as a **hands-on learning project**, but based on a **real public dataset** and a biologically meaningful question.

---

## Biological question
Does deletion of the **`slyA`** gene alter gene expression in *E. coli* BW25113?

---

## Dataset
Public RNA-seq data were selected from a study comparing *E. coli* BW25113 WT and `ΔslyA`.

### Samples used in this mini-project
- **WT**
  - SRR13970433
  - SRR13970434
- **ΔslyA**
  - SRR13970441
  - SRR13970442

### Experimental design
- Organism: *Escherichia coli* BW25113
- Sequencing type: **paired-end RNA-seq**
- Read length: ~76 bp
- Number of conditions: 2
- Replicates: 2 per condition

---

## Reference genome
Reference genome used for alignment:
- *E. coli* BW25113
- Assembly: `GCF_000750555.1`
- Chromosome accession: `CP009273.1`

Files used:
- Genome FASTA
- Genome annotation GFF

---

## Workflow
The analysis pipeline included the following steps:

1. **Download of raw sequencing data**
   - `prefetch`
   - `fasterq-dump`

2. **Quality control of raw reads**
   - `FastQC`
   - `MultiQC`

3. **Read trimming**
   - `fastp`

4. **Quality control after trimming**
   - `FastQC`
   - `MultiQC`

5. **Reference preparation**
   - download of genome FASTA and GFF
   - `hisat2-build`

6. **Read alignment**
   - `HISAT2`
   - bacterial mode with `--no-spliced-alignment`

7. **SAM/BAM processing**
   - `samtools view`
   - `samtools sort`
   - `samtools index`

8. **Gene-level counting**
   - `featureCounts`

9. **Differential expression analysis**
   - `DESeq2` in R

10. **Visualization**
   - PCA plot
   - MA plot

---

## Main results

### Quality control
Raw and trimmed reads showed overall good quality. Adapter contamination was not a major issue. Some expected bacterial RNA-seq biases remained, including:
- sequence duplication
- non-uniform base composition

These did not prevent downstream analysis.

### Alignment
Alignment rates were very high:

- SRR13970433: **98.45%**
- SRR13970434: **98.36%**
- SRR13970441: **96.49%**
- SRR13970442: **96.40%**

### Differential expression
Using DESeq2, the analysis identified:

- **319 significantly differentially expressed genes**
- threshold: `padj < 0.05`

### PCA
The PCA showed a **clear separation between WT and ΔslyA samples**, with:

- **PC1 = 83% variance**
- **PC2 = 10% variance**

This suggests that the major source of variation in the dataset is the biological condition.

### MA plot
The MA plot showed:
- most genes centered around log2FC = 0
- a subset of genes clearly upregulated or downregulated in the mutant

---

## Example of top differentially expressed genes

### Top upregulated genes in ΔslyA
- BW25113_RS16785
- BW25113_RS10445
- BW25113_RS10065
- BW25113_RS22665
- BW25113_RS05600
- BW25113_RS05605
- BW25113_RS05610
- BW25113_RS05615

### Top downregulated genes in ΔslyA
- BW25113_RS08595
- BW25113_RS16200
- BW25113_RS16205
- BW25113_RS16210
- BW25113_RS14975
- BW25113_RS16720
- BW25113_RS16175
- BW25113_RS16715

Several neighboring loci were regulated in the same direction, suggesting possible **co-regulated gene clusters or operon-like organization**.

---

## Project structure

```bash
rna_seq_project/
├── raw_data/
├── trimmed/
├── fastqc_raw/
├── multiqc_raw/
├── fastqc_trimmed/
├── multiqc_trimmed/
├── ref/
├── index/
├── bam/
├── logs/
├── counts/
├── results/
└── scripts/
