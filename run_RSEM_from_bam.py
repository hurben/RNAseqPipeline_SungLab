#run_rsem_from_bam.py							#2020.01.15
#hur.benjamin@mayo.edu
#
#run RSEM for "TPM" calculation.

if __name__ == '__main__':

	import sys
	import os
	sys.path.insert(1, '/research/labs/surgresearch/jsung/m221138/code')
	import FL
	import argparse

	parser = argparse.ArgumentParser()
	parser.add_argument('-i', '--input', dest = 'input_list_file', help='list of input files')
	parser.add_argument('-s', '--species', dest = 'species', help='species')
	args = parser.parse_args()

	input_list_file = args.input_list_file
	species = args.species

	rsem_dir = FL.access_data().get_dir('rsem_cal')

	if species == "human":
		ref_dir = FL.access_data().get_dir('hg38_ref_rsem')
	if species == "mouse":
		ref_dir = FL.access_data().get_dir('mm10_ref_rsem')
		print ("Currently I did not prepare this reference")
		quit()

	input_list_file = open(input_list_file,'r')
	input_list_readlines = input_list_file.readlines()

	for i in range(len(input_list_readlines)):
		read = input_list_readlines[i]
		read = read.replace('\n','')
		if i == 0:
			file_dir = read
		else:
			sample_name = read
			sample_file = '%s/%s/%sAligned.toTranscriptome.out.bam' % (file_dir, sample_name, sample_name)

			rsem_cmd = '%s -p 8 --alignments --paired-end %s %s %s' % (rsem_dir, sample_file, ref_dir, sample_name)
			print (rsem_cmd)
			os.system(rsem_cmd)

