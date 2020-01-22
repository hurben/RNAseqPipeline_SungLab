#/Users/m221138/Scarisbrick_Project/RNAseq/analysis/gene_list_v0
#
#Issue:
#[1] Unorganized gene list :(
#[2] Incorrect GeneSymbol

import sys
import os

raw_gene_list = '/Users/m221138/Scarisbrick_Project/RNAseq/analysis/gene_list_v0/raw_gene_list.tsv'
raw_gene_list_file = open(raw_gene_list,'r')
raw_gene_list_readlines = raw_gene_list_file.readlines()

output_dir = '/Users/m221138/Scarisbrick_Project/RNAseq/analysis/gene_list_v1'

data_dict = {}
feature_list = []

for i in range(len(raw_gene_list_readlines)):
	read = raw_gene_list_readlines[i]
	read = read.replace('\n','')
	token = read.split('\t')

	name_a = token[0]
	name_b = token[1]

	if name_a != '':
		if name_b != '':
			key = '%s_%s' % (name_a, name_b)
		if name_b == '':
			key = '%s' % (name_a)

		key = key.replace(' ','')
		key = key.replace('&','')
		key = key.replace('"','')
		feature_list.append(key)

		for j in range(2, len(token)):
			gene = token[j]
			if gene != '':
				gene = gene.capitalize()

				try: data_dict[key].append(gene)
				except KeyError: data_dict[key] = [gene]

			if gene == '':
				break

print (feature_list)
for feature in feature_list:
	output_txt = open('%s/%s.list'% (output_dir, feature),'w')
	gene_list = data_dict[feature]
	
	for gene in gene_list:
		output_txt.write('%s\n' % gene)
	output_txt.close()
