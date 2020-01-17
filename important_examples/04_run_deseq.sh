for i in overall female male
do
	data_file=klk6.$i.tsv
	meta_file=klk6.$i.meta.tsv
	output_file=klk6.$i.deg.tsv
	echo "Proceeding >" $data_file $meta_file $output_file
	Rscript /Users/m221138/RNAseq_pipeline/deseq2.r $data_file $meta_file $output_file
done
