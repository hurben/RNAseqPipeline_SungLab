import sys
import os
import pandas as pd


def list_to_txt(input_list,output_txt):
	for value in input_list:
		output_txt.write('\t%s' % value)

def define_sig_level(input_list):
	count = 0
	for value in input_list:
		if value < 0.05:
			count = count + 1
	return count



input_list_file = sys.argv[1]
input_list_file = open(input_list_file,'r')
input_list_readlines = input_list_file.readlines()

output_file = sys.argv[2]
output_txt = open(output_file,'w')

file_list = []
gene_list = []
data_profile_dict = {}

for i in range(len(input_list_readlines)):
	each_file = input_list_readlines[i]
	each_file = each_file.replace('\n','')
	file_list.append(each_file)

	each_file_df = pd.read_csv(each_file, sep=",", header=0)
	r, c = each_file_df.shape
	print (each_file)
	print (each_file_df.head())
	print (r,c)

	for j in range(r):

		gene = each_file_df.iloc[j,0]
		gene_list.append(gene) 
		#much faster to remove duplicates at line #37 
		log2fc = each_file_df.iloc[j,2]
		pvalue = each_file_df.iloc[j,5]
		padj = each_file_df.iloc[j,6]
		#i = row, j = col
		data_profile_dict[gene, each_file] = [log2fc, pvalue, padj]

gene_list = list(set(gene_list))


#header
output_txt.write('gene')
for file_name in file_list:
	output_txt.write('\t%s_log2FC' % file_name)
for file_name in file_list:
	output_txt.write('\t%s_pvalue' % file_name)
for file_name in file_list:
	output_txt.write('\t%s_adj_pvalue' % file_name)
output_txt.write('\tpvalue_sig_across_sex\tadj_pvalue_sig_acress_sex\n')


for gene in gene_list:

	fc_list = []
	pvalue_list =[]
	padj_list = []
	output_txt.write("%s" % gene)

	for file_name in file_list:
		log2fc = data_profile_dict[gene, file_name][0]
		pvalue = data_profile_dict[gene, file_name][1]
		padj = data_profile_dict[gene, file_name][2]

		fc_list.append(log2fc)
		pvalue_list.append(pvalue)
		padj_list.append(padj)

	list_to_txt(fc_list, output_txt)
	list_to_txt(pvalue_list, output_txt)
	list_to_txt(padj_list, output_txt)

	pval_sig = define_sig_level(pvalue_list)
	padj_sig = define_sig_level(padj_list)
	if gene == "Klk6":
		print (fc_list)
		print (pvalue_list)
		print (padj_list)
		print (pval_sig)

	output_txt.write('\t%s' % pval_sig)
	output_txt.write('\t%s' % padj_sig)
	output_txt.write('\n')


output_txt.close()











