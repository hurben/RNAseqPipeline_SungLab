RNA-seq Pipeline for Sung Lab
=============================

Benjamin Hur
------------
Contact: hur.benjamin@mayo.edu

If you are not working at mforge, you might have to change some directories

### Intended Workflow 1 > 2 > 3 > 4

##### 1. Trimming : trimmomatic
> trimmomatic.py -i [input_list]

##### 2. Reference Genome Indexing: STAR
> generate_genome_indexs.py -r [read_size]

##### 3. Alignmnet : STAR
> star_align.py -i [input_list]

##### 4. DEG : DESeq2
> prepare_DESeq2.py -i [input_list]

> deseq2.r [input_data] [input_meta_data] [output_name]

##### 5. Others
> FL.py

Defined functions for multiple usage

> alignment_summary.py -i [input_list] [output_name]

Summarizing results of alignments performed by STAR. It summarizes unique mapping, multi loci, many loci, unmapped.... ETC.

> run_RSEM_from_bam.py

Not in use at the moment.

> DEG_to_VolcanoPlot.r

Drawing Volcano plots from < deseq2.r > results

##### important_examples/
1. The directory contains how [input_list] should look like.
2. Shell scripts (.sh) show the command line how to be excecuted.

Important note for [star_aligned.list].
I am strictly defining "#case" and "#control" to seperate samples for DESeq2. 
Might change in the future.
