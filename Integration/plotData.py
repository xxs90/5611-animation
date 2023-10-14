import os
import matplotlib.pyplot as plt
import numpy as np

time_lists = []
energy_lists = []
length_error_lists = []


folder_path = ['./data/substeps_1', './data/substeps_10', './data/substeps_100', 
			   './data/relaxation_steps_10', './data/relaxation_steps_1', './data/relaxation_steps_100' ] 

for folder in folder_path:

	# List all files in the folder
	files = os.listdir(folder)

	# Filter out only the .txt files
	txt_files = [file for file in files if file.endswith('.txt')]
	print(txt_files)

	fig, axs = plt.subplots(2, 1, figsize=(10, 10))

	for txt_file in txt_files:
		relaxation_step = txt_file.split('_')[1]
		sub_step = txt_file.split('_')[3].split('.')[0]
		
		time_list = []
		energy_list = []
		length_error_list = []

		with open(os.path.join(folder, txt_file), 'r') as f:
			lines = f.readlines()

			for line in lines:
				line_split = line.split(':')[0]
				if line_split == "Time":
					time_list.append(float((line.split(':')[1]).split(' ')[1]))
				elif line_split == "Total energy":
					energy_list.append(float((line.split(':')[1]).split(' ')[1]))
				elif line_split == "Total length error":
					length_error_list.append(float((line.split(':')[1]).split(' ')[1]))
				else:
					pass

			f.close()

		folder_name = folder.split('/')[2]
		fig.suptitle("Graph for " + folder_name)
		label = "relaxation_step = " + relaxation_step + ", sub_step = " + sub_step
		axs[0].plot(time_list, energy_list, label=label)
		axs[0].set_title('Energy vs Time')
		axs[0].set(xlabel='Time (s)', ylabel='Energy (J)')
		

		axs[1].plot(time_list, length_error_list, label=label)
		axs[1].set_title('Length Error vs Time')
		axs[1].set(xlabel='Time (s)', ylabel='Length Error (m)')
		
		axs[0].legend()
		axs[1].legend()

		file_name = "./plots/" + folder_name + '.png'
		fig.savefig(file_name)
		
	print(file_name, "saved successfully")
	plt.close()
	

	print("All files saved successfully")

