#star_align.py							#2020.01.14
#> aligning reads with star
#hur.benjamin@mayo.edu
#
#prior steps;
#[1] (optional) trimming adaptors: trimmomatic
#[2] reference genome indexing
#read the manual of STAR before you modify this code
#https://physiology.med.cornell.edu/faculty/skrabanek/lab/angsd/lecture_notes/STARmanual.pdf
#
#Star Alignment
#Important files: /research/labs/surgresearch/jsung/m221138/code/data.locations


if __name__ == '__main__':

	import sys
	import os
	sys.path.insert(1, '/research/labs/surgresearch/jsung/m221138/code')
	import FL
	import argparse

	#Browse data.locations, 
	#get the directory of ref
	#get the directory that will store indexing file 
	#  > Note that the index files should be stored at the same directory of the reference genome
	#get the directory of the gtf file
	ref_dir  = FL.access_data().get_ref_dir()
	mouse_ref_dir  = FL.access_data().get_mouse_ref()
	mouse_gtf_dir  = FL.access_data().get_mouse_gtf()

	parser = argparse.ArgumentParser()
	parser.add_argument('-i', '--input_file', dest = 'input_file', help='input should be list of files')
	args = parser.parse_args()
	input_file = args.input_file

	if input_file == None:
		print ("[Error] Please Define the read size of your reads")
		quit()

	input_file_open = open(input_file,'r')
	input_file_readlines = input_file_open.readlines()

	for i in range(len(input_file_readlines)):

		read = input_file_readlines[i]
		read = read.replace('\n','')

		if i == 0:
			file_dir = read + '/'

		else:
			token = read.split(',')
			PE_a_in = token[0]
			PE_b_in = token[1]

			token_for_dir = PE_a_in.split('_')
			out_file_prefix = token_for_dir[0] + '_' + token_for_dir[1]

			if os.path.isdir(out_file_prefix) == True:
				print ("[Notice] Note that %s folder exists. Removing anyway")
				os.system('rm -r %s' % out_file_prefix)
			else:
				os.system('mkdir %s' % out_file_prefix)

			PE_a_in = file_dir + token[0]
			PE_b_in = file_dir + token[1]

			cmd = 'STAR --runThreadN 8 --genomeDir %s --sjdbGTFfile %s --outFileNamePrefix ./%s/%s --outSAMtype BAM SortedByCoordinate --readFilesIn %s %s' % (ref_dir, mouse_gtf_dir, out_file_prefix, out_file_prefix, PE_a_in, PE_b_in)
			#your CL would look like this
			print (cmd)
			#run
			os.system(cmd)
