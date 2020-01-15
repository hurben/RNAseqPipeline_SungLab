RNA-seq Pipeline for Sung Lab
=============================

Benjamin Hur
------------
Contact: hur.benjamin@mayo.edu

### Intended Workflow 1 > 2 > 3 > 4

##### 1. Trimming : trimmomatic
> trimmomatic.py -i [input_list]

##### 2. Reference Genome Indexing: STAR
> generate_genome_indexs.py -r [read_size]

##### 3. Alignmnet : STAR
> star_align.py -i [input_list]

##### 4. Annotation & DEG : DESEQ
> N/A at the moment

##### 5. Others
-Defined functions for multiple usage
> FL.py


##### important_examples/
1. The directory contains how [input_list] should look like.
2. Simple shell files that shows the command line how to be excecuted.

Note that [star_aligned.list] I am strictly defining "#case" and "#control" to seperate samples for DESeq2. 
Might change in the future.

