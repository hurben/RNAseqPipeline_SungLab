#DEG_to_VolcanoPlot.adj.r					20.01.22
#hur.benjamin@mayo.edu
#
#Drawing Volcano Plots for DESeq2 results
#
#note:
#Generally, the pvalues from DESeq2 shows great results in 'volcano'.
#Other DEG methods such as EBSeq have "skewed" pvalues that cause volcano plot to look less volcano.
#
#cmd: Rscript DEG_to_VolcanoPlot.adj.r [input] [output_prefix]
#[input] directly uses the output from "deseq2.r"

library(ggplot2)
library(ggrepel)

#test dataset
#input_file = read.csv('/Users/m221138/Scarisbrick_Project/RNAseq/deseq2/klk6.overall.deg.tsv', sep=",", header=TRUE, row.names=1)

args <- commandArgs(trailingOnly=TRUE)
input_file = read.csv(args[1], sep=",", header=TRUE, row.names=1)
output_prefix = args[2]

#defining new dataframe
x_axis <- input_file$log2FoldChange
y_axis <- -log10(input_file$padj)
gene_list <- rownames(input_file)
df <- do.call(rbind, Map(data.frame, 'log2FC'=x_axis, 'padj'=y_axis))
rownames(df) <- gene_list
df$genes <- row.names(df)

#Thresholds for data points color

#adj pvalue 0.05 = 1.30103 (-10log padj)
sig_subset <- subset(df, padj > 1.30103)
sig_red_subset <- subset(sig_subset, log2FC > 1.6)
sig_blue_subset <- subset(sig_subset, log2FC < -1.6)

#Plot for labels
output_pdf_label <- paste(output_prefix, ".label.pdf", sep="")
pdf(output_pdf_label)

ggplot(df, aes(x=log2FC, y=padj))+ coord_cartesian(xlim=c(-5,5), ylim=c(0,5))+ geom_point(colour="grey") +
geom_point(data = sig_red_subset, colour="red") +
geom_point(data = sig_blue_subset, colour="blue") +
geom_text_repel(data=sig_red_subset, aes(log2FC, padj, label=genes), colour="red", size=2) +
geom_text_repel(data=sig_blue_subset, aes(log2FC, padj, label=genes), colour="blue", size=2) +
ylab("-10 log (adj pvalue)")

dev.off()

#Plot without labels
output_pdf <- paste(output_prefix, ".pdf", sep="")
pdf(output_pdf)
ggplot(df, aes(x=log2FC, y=padj))+ coord_cartesian(xlim=c(-5,5), ylim=c(0,5))+ geom_point(colour="grey") +
geom_point(data = sig_red_subset, colour="red") +
geom_point(data = sig_blue_subset, colour="blue")+
ylab("-10log (adj pvalue)")
dev.off()
