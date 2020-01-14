class access_data:

	#if you have your own data.locations file, modify this directory
	data_profile = '/research/labs/surgresearch/jsung/m221138/code/data.locations'
	data_profile_readlines = open(data_profile,'r').readlines()

	def search_module(self, data_type):
		data_profile_readlines = self.data_profile_readlines

		for i in range(len(data_profile_readlines)):
			read = data_profile_readlines[i]
			read = read.replace('\n','')
			token = read.split('\t')
			if token[0] == data_type:
				dir_of_interest = token[1]
				break
		return dir_of_interest

	def get_mouse_ref(self):
		dir_of_interest = self.search_module('mm10_ref')
		return dir_of_interest
				
	def get_mouse_gtf(self):
		dir_of_interest = self.search_module('mm10_gtf')
		return dir_of_interest

	def get_ref_dir(self):
		dir_of_interest = self.search_module('mm10_dir')
		return dir_of_interest

	def get_trim_jar(self):
		dir_of_interest = self.search_module('trim_jar')
		return dir_of_interest

	def get_adapter_info(self):
		dir_of_interest = self.search_module('adapter_info')
		return dir_of_interest

	def get_adapter_r1_info(self):
		dir_of_interest = self.search_module('adapter_r1_info')
		return dir_of_interest




if __name__ == "__main__":
	import sys
	import os
	print ("This script is not meant to be run")
else:
	print ("Loading FL")


