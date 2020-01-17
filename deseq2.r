library(DESeq2)

#input_data <- read.csv('/Users/m221138/Scarisbrick_Project/RNAseq/deseq2/overall.tsv', sep="\t", row.names=1, header=TRUE)
#input_meta_data <- read.csv('/Users/m221138/Scarisbrick_Project/RNAseq/deseq2/overall.meta.tsv', sep="\t", header=TRUE, row.names=1)

args <- commandArgs(trailingOnly=TRUE)

input_data <- read.csv(args[1], sep="\t", row.names=1, header=TRUE)
input_meta_data <- read.csv(args[2], sep="\t", row.names=1, header=TRUE)
output_file <- args[3]

cts <- as.matrix(input_data)
coldata <- input_meta_data

dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = coldata,
                              design = ~ condition)

deseq_result <- DESeq(dds)
res <- results(deseq_result)
pvalue_orded_results <- res[order(res$pvalue),]
write.csv(as.data.frame(pvalue_orded_results), file=output_file)

