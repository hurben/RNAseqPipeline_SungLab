#draw_heatmap.r              20.01.20
#hur.benjamin@mayo.edu
#
#[1] Draw heatmap from given list
#[2] Designed to run this script i x j times (i = input matrix from DESeq2 results, j = predefined gene list)
#
#Memo: Drawing heatmap in case of "TREE CUT"
#
#cmd: Rscript draw_heatmap.r [input deg matrix] [input predefined gene list] [output prefix]

#Don't learn anything in this stupid script...
 
library(gplots)
library(pheatmap)
library(RColorBrewer)


#Functions ==================================================================
get_barcode <- function(subset_df_pval, pval_cutline)
{
    barcode <- 0
    if (subset_df_pval < pvalue_cutline)
    {
        barcode <- 1
    }
    return(barcode)
}

get_df <- function(data_file)
{
    deg_df <-read.csv(data_file, sep=",", header=TRUE, row.names=1)
    deg_df <- as.data.frame(deg_df[,1:5])
    return (deg_df)
}

remove_na <- function(df)
{
    df <- df[complete.cases(df),]
    return(df)
}

get_subset_df <- function(df, gene_list)
{
    subset_df <- subset(df, rownames(df) %in% gene_list)
	subset_df <- subset_df[order(row.names(subset_df)), ]
    return (subset_df)
}

#==============================================================================


#Input Handling ===============================================================
#Get Intersection sets (Gene symbol) from three different inputs 
#Might have been wise to do this process with python...
df <- get_df('/Users/m221138/Scarisbrick_Project/RNAseq/deseq2/klk6.overall.deg.csv')
s_df <- get_df('/Users/m221138/Scarisbrick_Project/RNAseq/deseq2/klk6.overall.deg.sex.adj.csv')
m_df <- get_df('/Users/m221138/Scarisbrick_Project/RNAseq/deseq2/klk6.male.deg.csv')
f_df <- get_df('/Users/m221138/Scarisbrick_Project/RNAseq/deseq2/klk6.female.deg.csv')

df <- remove_na(df)
s_df <- remove_na(s_df)
m_df <- remove_na(m_df)
f_df <- remove_na(f_df)
    
df_gene_list <- row.names(df)
s_df_gene_list <- row.names(s_df)
f_df_gene_list <- row.names(f_df)
m_df_gene_list <- row.names(m_df)

common_gene_list <- intersect(intersect(intersect(df_gene_list,m_df_gene_list),f_df_gene_list),s_df_gene_list)

df <- get_subset_df(df, common_gene_list)
s_df <- get_subset_df(s_df, common_gene_list)
f_df <- get_subset_df(f_df, common_gene_list)
m_df <- get_subset_df(m_df, common_gene_list)

args <- commandArgs(trailingOnly=TRUE)
predefined_gene_list <- args[1]
predefined_gene_list <- read.csv(predefined_gene_list, header=FALSE)$V1
predefined_gene_list <- as.character(predefined_gene_list)

output_dir <- args[2]
output_file <- paste(output_dir,'.heatmap.pdf', sep="")

#print (output_file)
#print (length(predefined_gene_list))

subset_df <- get_subset_df(df, predefined_gene_list)
subset_s_df <- get_subset_df(s_df, predefined_gene_list)
subset_f_df <- get_subset_df(f_df, predefined_gene_list)
subset_m_df <- get_subset_df(m_df, predefined_gene_list)
#==============================================================================


#Making Barcodes to mark significant genes=====================================
heatmap_ready_df <- data.frame(sex_adj_overall=subset_s_df$log2FoldChange,
							   overall=subset_df$log2FoldChange, 
                               female=subset_f_df$log2FoldChange,
                               male=subset_m_df$log2FoldChange)

subset_df_gene_list <- row.names(subset_df)
pvalue_cutline <- 0.05
gene_name_with_barcode_list <- c()

for (gene_name in subset_df_gene_list)
{
    barcode_list <- c(0,0,0,0)
    subset_s_df_pval <- subset_s_df[gene_name,"pvalue"]
    subset_df_pval <- subset_df[gene_name,"pvalue"]
    subset_f_df_pval <- subset_f_df[gene_name,"pvalue"]
    subset_m_df_pval <- subset_m_df[gene_name,"pvalue"]
    
    barcode_list[1] <- get_barcode(subset_s_df_pval, pvalue_cutline)
    barcode_list[2] <- get_barcode(subset_df_pval, pvalue_cutline)
    barcode_list[3] <- get_barcode(subset_f_df_pval, pvalue_cutline)
    barcode_list[4] <- get_barcode(subset_m_df_pval, pvalue_cutline)

    gene_name_with_barcode <- paste(gene_name,'_', barcode_list[1], barcode_list[2],barcode_list[3],barcode_list[4],sep="")
    #print (gene_name_with_barcode)
    gene_name_with_barcode_list <- c(gene_name_with_barcode_list, gene_name_with_barcode)
}

rownames(heatmap_ready_df) <- gene_name_with_barcode_list
#=============================================================================

#Creating Figures ==============================================

heatmap_ready_df <- as.matrix(heatmap_ready_df)
break_list = seq(-1.0,1.0, by=0.05)
color = colorRampPalette(rev(brewer.pal(n = 7, name = "RdYlBu")))(length(break_list))

heatmap_ready_df

heatmap_size <- length(subset_df_gene_list)
pdf(output_file)
if (heatmap_size <= 10)
{
	pheatmap(heatmap_ready_df, breaks=break_list, color=color,cluster_cols=FALSE, fontsize = 7, cellwidth=20, cellheight=7)
}
if (heatmap_size > 10 && heatmap_size <= 30)
{
	pheatmap(heatmap_ready_df, breaks=break_list, color=color,cluster_cols=FALSE, fontsize = 5, cellwidth=20, cellheight=10)
}
if (heatmap_size > 30 && heatmap_size <= 100)
{
	pheatmap(heatmap_ready_df, breaks=break_list, color=color,cluster_cols=FALSE, fontsize = 4, cellwidth=20)
}
if (heatmap_size > 100)
	pheatmap(heatmap_ready_df, breaks=break_list, color=color,cluster_cols=FALSE, fontsize = 2, cellwidth=20)
dev.off()

#================================================================
