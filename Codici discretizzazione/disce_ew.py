import random
import numpy as np
import statistics 
import csv
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
#dat = np.arange(1,13)

dat = []
for i in range(10):
	dat.append(random.randint(0,10))

#discretizzazione di una lista di elementi in bins secondo equal-width
#data: lista elementi
#bins: numero di intervalli
def discretize(data, bins):
	mini = int(min(data))
	maxi = int(max(data))
	size = int(abs(maxi - mini)/bins)
	print(size)
    #split = np.array_split(np.sort(data), bins)
    #cutoffs = [x[-1] for x in split]
	cutoffs = [w for w in range(mini, maxi, size)]
	cutoffs = cutoffs[:-1]
	discrete = np.digitize(data, cutoffs, right=True)
	return discrete, cutoffs

#discretizzazione di una specifica colonna del dataset
#col: nome della colonna
def discrete_col(col, bins, dicto):
	x1 = []
	x1.extend(dicto['sitting'][col])
	x1.extend(dicto['standing'][col])
	x1.extend(dicto['walking'][col])
	x1.extend(dicto['sittingdown'][col])
	x1.extend(dicto['standingup'][col])

	discrete_dat, cutoff = discretize(x1, bins)
	cutoff.append(max(x1))
	cutoff.insert(0, min(x1))

	return (discrete_dat, cutoff)

#crea un dataset discretizzato a partire da un dizionario
#dicto: dizionario contenente il dataset originale
def discretization(dicto):
	discrete_dat_x1, cutoff = discrete_col('x1', 10, dicto)

	print("discrete_dat_x1: ", discrete_dat_x1)
	print("cutoff: ", cutoff)

	discrete_dat_y1, cutoff = discrete_col('y1', 10, dicto)

	print("discrete_dat_y1: ", discrete_dat_y1)
	print("cutoff: ", cutoff)

	discrete_dat_z1, cutoff = discrete_col('z1', 10, dicto)

	print("discrete_dat_z1: ", discrete_dat_z1)
	print("cutoff: ", cutoff)

	#...........
	discrete_dat_x2, cutoff = discrete_col('x2', 10, dicto)

	print("discrete_dat_x2: ", discrete_dat_x2)
	print("cutoff: ", cutoff)

	discrete_dat_y2, cutoff = discrete_col('y2', 10, dicto)

	print("discrete_dat_y2: ", discrete_dat_y2)
	print("cutoff: ", cutoff)

	discrete_dat_z2, cutoff = discrete_col('z2', 10, dicto)

	print("discrete_dat_z1: ", discrete_dat_z2)
	print("cutoff: ", cutoff)

	#...........
	discrete_dat_x3, cutoff = discrete_col('x3', 10, dicto)

	print("discrete_dat_x3: ", discrete_dat_x3)
	print("cutoff: ", cutoff)

	discrete_dat_y3, cutoff = discrete_col('y3', 10, dicto)

	print("discrete_dat_y3: ", discrete_dat_y3)
	print("cutoff: ", cutoff)

	discrete_dat_z3, cutoff = discrete_col('z3', 10, dicto)

	print("discrete_dat_z3: ", discrete_dat_z3)
	print("cutoff: ", cutoff)

	#...........
	discrete_dat_x4, cutoff = discrete_col('x4', 10, dicto)

	print("discrete_dat_x4: ", discrete_dat_x4)
	print("cutoff: ", cutoff)

	discrete_dat_y4, cutoff = discrete_col('y4', 10, dicto)

	print("discrete_dat_y4: ", discrete_dat_y4)
	print("cutoff: ", cutoff)

	discrete_dat_z4, cutoff = discrete_col('z4', 10, dicto)

	print("discrete_dat_z4: ", discrete_dat_z4)
	print("cutoff: ", cutoff)

	plt.hist(discrete_dat_x1)
	plt.title('Equal-width')
	plt.ylabel('Numero di istanze')
	plt.xlabel('Bins')
	plt.savefig('disce_ew.pdf')
	#plt.show()
	
	print('Writing discrete csv')

	csv_writer = csv.writer(open('Data_discrete.csv', 'w', newline=''), delimiter=';', quoting=csv.QUOTE_MINIMAL)
	csv_writer.writerow(['x1', 'y1', 'z1' ,'x2' ,'y2' ,'z2' ,'x3' ,'y3' ,'z3', 'x4', 'y4' ,'z4' ,'class'])
	with open('DatasetOverSampling.csv') as csv_file:
		cvs_reader = csv.reader(csv_file, delimiter = ',')
		next(cvs_reader)#salto titolo
		i = 0
		for row in cvs_reader:
			csv_writer.writerow([discrete_dat_x1[i], discrete_dat_y1[i], discrete_dat_z1[i], discrete_dat_x2[i], discrete_dat_y2[i], discrete_dat_z2[i], discrete_dat_x3[i], discrete_dat_y3[i], discrete_dat_z3[i], discrete_dat_x4[i], discrete_dat_y4[i], discrete_dat_z4[i], row[12]])	
			i += 1	

	print('Done')

#struttura del dizionario ricavato dal dataset
#{'class' : {'x1', 'y1', 'z1', 'x2', 'y2', 'z2', 'x3', 'y3', 'z3', 'x4', 'y4', 'z4'}}
dicto = {}
print('Reading csv...')

with open('DatasetOverSampling.csv') as csv_file:
	cvs_reader = csv.reader(csv_file, delimiter = ',')
	next(cvs_reader)#salto titolo

	for row in cvs_reader:
		key = row[12]
		if key in dicto.keys():
			i = 0
			for k in dicto[key].keys():
				dicto[key][k].append(round(float(row[i]), 0))
				i += 1
		else:
			dicto[key] = {'x1': [int(row[0])], 'y1': [int(row[1])], 'z1': [int(row[2])], 'x2': [int(row[3])], 'y2': [int(row[4])], 'z2': [int(row[5])], 'x3': [int(row[6])], 'y3': [int(row[7])], 'z3': [int(row[8])], 'x4': [int(row[9])], 'y4': [int(row[10])], 'z4': [int(row[11])]}
print('Done')

discretization(dicto)

