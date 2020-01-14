#RNA-seq Pipeline for Sung Lab

##Intended Workflow 1 > 2 > 3 > 4

1. Trimming : trimmomatic
> trimmomatic.py -i [input_list]

2. Reference Genome Indexing: STAR
> generate_genome_indexs.py -r [read_size]

3. Alignmnet : STAR
> star_align.py -i [input_list]

4. Annotation & DEG : DESEQ

5. Others
-Defined functions for multiple usage
> FL.py
