#draw_heatmap.r              20.01.20
#hur.benjamin@mayo.edu
#
#[1] Draw heatmap from given list
#[2] Designed to run this script i x j times (i = input matrix from DESeq2 results, j = predefined gene list)
#
#Memo: Drawing heatmap in case of "TREE CUT"
#
#cmd: Rscript draw_heatmap.r [input deg matrix] [input predefined gene list] [output prefix]
 
library(gplots)
library(pheatmap)
library(RColorBrewer)

args <- commandArgs(trailingOnly=TRUE)

#for cut-tree, currently not in use
#library(dendextend)

#test dataset
deg_data_matrix <- '/Users/m221138/Scarisbrick_Project/RNAseq/deseq2/klk6.overall.deg.csv'
deg_data_f_matrix <- '/Users/m221138/Scarisbrick_Project/RNAseq/deseq2/klk6.male.deg.csv'
deg_data_m_matrix <- '/Users/m221138/Scarisbrick_Project/RNAseq/deseq2/klk6.female.deg.csv'

predefined_gene_list <- args[1]
output_pdf <- paste(predefined_gene_list, '.heatmap.pdf', sep="")

deg_df <-read.csv(deg_data_matrix, sep=",", header=TRUE, row.names=1)
deg_f_df <-read.csv(deg_data_f_matrix, sep=",", header=TRUE, row.names=1)
deg_m_df <-read.csv(deg_data_m_matrix, sep=",", header=TRUE, row.names=1)

deg_df <- as.data.frame(deg_df)


head(deg_df)
predefined_gene_list <- read.csv(predefined_gene_list, header=FALSE)$V1
predefined_gene_list <- as.character(predefined_gene_list)

#print (predefined_gene_list)

subset_df <- subset(deg_df, rownames(deg_df) %in% predefined_gene_list)
subset_f_df <- subset(deg_f_df, rownames(deg_f_df) %in% predefined_gene_list)
subset_m_df <- subset(deg_m_df, rownames(deg_m_df) %in% predefined_gene_list)


heatmap_ready_df <- data.frame(overall= subset_df$log2FoldChange, 
                               female=subset_f_df$log2FoldChange,
                               male=subset_m_df$log2FoldChange)
rownames(heatmap_ready_df) <- row.names(subset_df)

subset_df
pvalue_cutline <- 0.05

gene_name_with_barcode_list <- c()
for (gene_name in row.names(subset_df))
{
    barcode_list <- c(0,0,0)
    subset_df_pval <- subset_df[gene_name,"pvalue"]
    subset_f_df_pval <- subset_f_df[gene_name,"pvalue"]
    subset_m_df_pval <- subset_m_df[gene_name,"pvalue"]
    if (subset_df_pval < pvalue_cutline)
    {
        barcode_list[1] <- 1
    }   
    if (subset_f_df_pval < pvalue_cutline)
    {
        barcode_list[2] <- 1
    }        
    if (subset_m_df_pval < pvalue_cutline)
    {
        barcode_list[3] <- 1
    }

#     print (gene_name)
#     print (barcode_list)
    gene_name_with_barcode <- paste(gene_name,'_', barcode_list[1], barcode_list[2],barcode_list[3],sep="")
    #print (gene_name_with_barcode)
    gene_name_with_barcode_list <- c(gene_name_with_barcode_list, gene_name_with_barcode)
}

#print (gene_name_with_barcode_list)
#print (row.names(heatmap_ready_df))

rownames(heatmap_ready_df) <- gene_name_with_barcode_list
heatmap_ready_df <- as.matrix(heatmap_ready_df)

my_palette <- colorRampPalette(c("green", "black", "red"))(n = 50)

#hclust.average <- function(x) hclust(x, method="average")
# heatmap_results <- heatmap.2(heatmap_ready_df, hclustfun=hclust.average, 
#                              col=my_palette, 
#                              symm=F, symkey=F, symbreak=F, trace="none")

pdf(output_pdf)
#pheatmap_results <- pheatmap(heatmap_ready_df, cluster_cols=FALSE)
pheatmap(heatmap_ready_df, cluster_cols=FALSE)
dev.off()


