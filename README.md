###RNA-seq Pipeline for Sung Lab

#Intended Workflow 1 > 2 > 3 > 4
#1. Trimming : trimmomatic
> trimmomatic.py

#2. Reference Genome Indexing: STAR
> generate_genome_indexs.py

#3. Alignmnet : STAR
> star_align.py

#4. Annotation & DEG : DESEQ

#Others
#Defined functions for multiple usage
> FL.py
