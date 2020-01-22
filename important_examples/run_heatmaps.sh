file_dir=/Users/m221138/Scarisbrick_Project/RNAseq/analysis/gene_list_v1/
while read p;
do
	Rscript /Users/m221138/RNAseq_pipeline/analysis/draw_pheatmap_klk6.r $file_dir$p
done <interest.list
