#alignment_summary.py							#2020.01.15
#hur.benjamin@mayo.edu
#
#Summarizing overall alignment results

def get_info(input_list, token_position):

	info_string = input_list[token_position].split('\t')[1]
	return info_string

if __name__ == '__main__':

	import sys
	import os
	sys.path.insert(1, '/research/labs/surgresearch/jsung/m221138/code')
	import FL
	import argparse

	parser = argparse.ArgumentParser()
	parser.add_argument('-i', '--input', dest = 'input_list_file', help='list of input files')
	parser.add_argument('-o', '--output', dest = 'output_prefix', help='prefix of output files')
	args = parser.parse_args()

	input_list_file = args.input_list_file
	output_prefix = args.output_prefix

	input_list_file = open(input_list_file,'r')
	input_list_readlines = input_list_file.readlines()

	output_txt = open(output_prefix + '.summary','w')
	output_txt.write('SampleName\tUniqMapping\tMultiLoci\tManyLoci\tUnmapped(mismatch)\tUnmapped(too short)\tUnmapped(others)\n')

	for i in range(len(input_list_readlines)):
		read = input_list_readlines[i]
		read = read.replace('\n','')

		if i == 0:
			file_dir = read
		else:
			sample_name = read
			sample_file = '%s/%s/%sLog.final.out' % (file_dir, sample_name, sample_name)
			sample_file_line_list = open(sample_file).read().splitlines()

			uniq_map = get_info(sample_file_line_list, 9)
			multi_loci = get_info(sample_file_line_list, 24)
			many_loci = get_info(sample_file_line_list, 26)

			many_mismatch = get_info(sample_file_line_list, 28)
			read_short = get_info(sample_file_line_list, 29)
			read_unclass = get_info(sample_file_line_list, 30)

			output_txt.write('%s\t%s\t%s\t%s\t%s\t%s\t%s\n' % (sample_name, uniq_map, multi_loci, many_loci, many_mismatch, read_short, read_unclass))
