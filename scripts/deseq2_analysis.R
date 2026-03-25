suppressPackageStartupMessages({
  library(DESeq2)
})

counts <- read.table("counts/count_matrix.tsv",
                     header = TRUE,
                     sep = "\t",
                     row.names = 1,
                     check.names = FALSE)

coldata <- read.table("counts/sample_info.tsv",
                      header = TRUE,
                      sep = "\t",
                      row.names = 1,
                      check.names = FALSE)

coldata$condition <- factor(coldata$condition, levels = c("WT", "DEL_slyA"))

dds <- DESeqDataSetFromMatrix(
  countData = counts,
  colData = coldata,
  design = ~ condition
)

dds <- dds[rowSums(counts(dds)) >= 10, ]

dds <- DESeq(dds)

res <- results(dds, contrast = c("condition", "DEL_slyA", "WT"))
res <- res[order(res$padj), ]

write.csv(as.data.frame(res), "results/deseq2_results.csv")
write.csv(as.data.frame(counts(dds, normalized = TRUE)), "results/normalized_counts.csv")

sig <- subset(as.data.frame(res), !is.na(padj) & padj < 0.05)
write.csv(sig, "results/deseq2_significant_padj0.05.csv")

png("results/MAplot.png", width = 1200, height = 900, res = 150)
plotMA(res, ylim = c(-5, 5))
dev.off()

vsd <- vst(dds, blind = TRUE)

png("results/PCA.png", width = 1200, height = 900, res = 150)
plotPCA(vsd, intgroup = "condition")
dev.off()
