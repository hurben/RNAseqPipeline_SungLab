#generate_genome_indexs.py							#2020.01.09
#hur.benjamin@mayo.edu
#
#Preprocess for Star Alignment, genome indexing
#Important files: /research/labs/surgresearch/jsung/m221138/code/data.locations
#
#read the star manual before you modify this code
#https://physiology.med.cornell.edu/faculty/skrabanek/lab/angsd/lecture_notes/STARmanual.pdf
#
#Memo to others: 
#It is better to type the CL directly for ref genome indexing.
#But I am doing this for future usage.

if __name__ == '__main__':

	import sys
	import os
	sys.path.insert(1, '/research/labs/surgresearch/jsung/m221138/code')
	import FL
	import argparse

	parser = argparse.ArgumentParser()
	parser.add_argument('-r', '--readsize', dest = 'read_size', help='readsize - 1, integer')
	parser.add_argument('-s', '--species', dest = 'species', help='mouse or human')
	args = parser.parse_args()

	read_size = args.read_size
	species = args.species

	#Browse data.locations, 
	#get the directory of ref
	#get the directory that will store indexing file 
	#  > Note that the index files should be stored at the same directory of the reference genome
	#get the directory of the gtf file
	if species == "mouse":
		ref_root_dir  = FL.access_data().get_dir('mm10_dir')
		ref_dir  = FL.access_data().get_dir('mm10_ref')
		gtf_dir  = FL.access_data().get_dir('mm10_gtf')
	if species == "human":
		ref_root_dir  = FL.access_data().get_dir('hg38_dir')
		ref_dir  = FL.access_data().get_dir('hg38_ref')
		gtf_dir  = FL.access_data().get_dir('hg38_gtf')

	if read_size == None:
		print ("[Error] Please Define the read size of your reads")
		quit()

	cmd = 'STAR --runThreadN 8 --runMode genomeGenerate --genomeDir %s --genomeFastaFiles %s --sjdbGTFfile %s --sjdbOverhang %s' % (ref_root_dir, ref_dir, gtf_dir, read_size)
	#your CL would look like this
	print (cmd)
	#run
	os.system(cmd)
