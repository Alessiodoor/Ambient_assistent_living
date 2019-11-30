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

#discretizzazione di una lista di elementi in bins secondo equal-depth
#data: lista elementi
#bins: numero di intervalli
def discretize(data, bins):
    split = np.array_split(np.sort(data), bins)
    cutoffs = [x[-1] for x in split]
    cutoffs = cutoffs[:-1]
    discrete = np.digitize(data, cutoffs, right=True)
    return discrete, cutoffs

#discretizzazione di una specifica colonna del dataset, con estremi degli intervalli già impostati
#col: nome della colonna
#cutoffs: lista contenente estremi degli intervalli [fine1, inizio2, fine2, ..., inizioN]
def discretize_wcut(col, cutoffs, dicto):
	x1 = []
	x1.extend(dicto['sitting'][col])
	x1.extend(dicto['standing'][col])
	x1.extend(dicto['walking'][col])
	x1.extend(dicto['sittingdown'][col])
	x1.extend(dicto['standingup'][col])

	discrete = np.digitize(x1, cutoffs, right=True)
	cutoffs.append(max(x1))
	cutoffs.insert(0, min(x1))

	return discrete, cutoffs

#discretizzazione di una specifica colonna del dataset, generando automaticamente gli estremi degli intervalli
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

#crea un dataset discretizzato a partire da un dizionario, con intevalli fissi
#dicto: dizionario contenente il dataset originale
def discretization_wcut(dicto):
	cutoff = [-22, -14, -11, -8, -6, -4, -1, 1, 5]
	discrete_dat_x1, cutoff = discretize_wcut('x1', cutoff, dicto)

	print(len(discrete_dat_x1))
	print("discrete_dat_x1: ", discrete_dat_x1)
	print("cutoff: ", cutoff)

	cutoff = [63, 71, 85, 91, 94, 96, 99, 102, 110]
	discrete_dat_y1, cutoff = discretize_wcut('y1', cutoff, dicto)

	print("discrete_dat_y1: ", discrete_dat_y1)
	print("cutoff: ", cutoff)

	cutoff = [-139, -124, -115, -104, -98, -92, -77, -60, -31]
	discrete_dat_z1, cutoff = discretize_wcut('z1', cutoff, dicto)

	print("discrete_dat_z1: ", discrete_dat_z1)
	print("cutoff: ", cutoff)

	#...........
	cutoff = [-472, -233, -24, -18, -9, -3, 2, 6, 14]
	discrete_dat_x2, cutoff = discretize_wcut('x2', cutoff, dicto)

	print("discrete_dat_x2: ", discrete_dat_x2)
	print("cutoff: ", cutoff)

	cutoff = [-495, -225, -22, 10, 27, 71, 84, 88, 91]
	discrete_dat_y2, cutoff = discretize_wcut('y2', cutoff, dicto)

	print("discrete_dat_y2: ", discrete_dat_y2)
	print("cutoff: ", cutoff)

	cutoff = [-596, -332, -131, -124, -118, -99, -38, -26, -21]
	discrete_dat_z2, cutoff = discretize_wcut('z2', cutoff, dicto)

	print("discrete_dat_z2: ", discrete_dat_z2)
	print("cutoff: ", cutoff)

	#...........
	cutoff = [-12, 6, 12, 17, 22, 26, 30, 38, 63]
	discrete_dat_x3, cutoff = discretize_wcut('x3', cutoff, dicto)

	print("discrete_dat_x3: ", discrete_dat_x3)
	print("cutoff: ", cutoff)

	cutoff = [62, 88, 99, 104, 107, 108, 117, 123, 136]
	discrete_dat_y3, cutoff = discretize_wcut('y3', cutoff, dicto)

	print("discrete_dat_y3: ", discrete_dat_y3)
	print("cutoff: ", cutoff)

	cutoff = [-126, -107, -102, -96, -90, -86, -82, -77, -66]
	discrete_dat_z3, cutoff = discretize_wcut('z3', cutoff, dicto)

	print("discrete_dat_z3: ", discrete_dat_z3)
	print("cutoff: ", cutoff)

	#...........
	cutoff = [-209, -194, -185, -176, -168, -163, -157, -149, -100]
	discrete_dat_x4, cutoff = discretize_wcut('x4', cutoff, dicto)

	print("discrete_dat_x4: ", discrete_dat_x4)
	print("cutoff: ", cutoff)

	cutoff = [-121, -106, -99, -94, -91, -88, -83, -77, -71]
	discrete_dat_y4, cutoff = discretize_wcut('y4', cutoff, dicto)

	print("discrete_dat_y4: ", discrete_dat_y4)
	print("cutoff: ", cutoff)

	cutoff = [-174, -169, -166, -163, -160, -158, -155, -152, -145]
	discrete_dat_z4, cutoff = discretize_wcut('z4', cutoff, dicto)

	print("discrete_dat_z4: ", discrete_dat_z4)
	print("cutoff: ", cutoff)
	
	print('Writing discrete csv')

	csv_writer = csv.writer(open('Data_discrete.csv', 'w', newline=''), delimiter=';', quoting=csv.QUOTE_MINIMAL)
	csv_writer.writerow(['x1', 'y1', 'z1' ,'x2' ,'y2' ,'z2' ,'x3' ,'y3' ,'z3', 'x4', 'y4' ,'z4' ,'class'])
	with open('data_over_standingup.csv') as csv_file:
		cvs_reader = csv.reader(csv_file, delimiter = ',')
		next(cvs_reader)#salto titolo
		i = 0
		for row in cvs_reader:
			csv_writer.writerow([discrete_dat_x1[i], discrete_dat_y1[i], discrete_dat_z1[i], discrete_dat_x2[i], discrete_dat_y2[i], discrete_dat_z2[i], discrete_dat_x3[i], discrete_dat_y3[i], discrete_dat_z3[i], discrete_dat_x4[i], discrete_dat_y4[i], discrete_dat_z4[i], row[12]])	
			i += 1	

	print('Done')

#crea un dataset discretizzato a partire da un dizionario, generando gli estremi degli intervalli
#dicto: dizionario contenente il dataset originale
def discretization(dicto):
	discrete_dat_x1, cutoff = discrete_col('x1', 10, dicto)

	print(len(discrete_dat_x1))
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

	#plt.hist(discrete_dat_y1)
	#plt.show()
	
	print('Writing discrete csv')

	csv_writer = csv.writer(open('Data_discrete.csv', 'w', newline=''), delimiter=';', quoting=csv.QUOTE_MINIMAL)
	csv_writer.writerow(['x1', 'y1', 'z1' ,'x2' ,'y2' ,'z2' ,'x3' ,'y3' ,'z3', 'x4', 'y4' ,'z4' ,'class'])
	with open('data_over_standingup.csv') as csv_file:
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

with open('data_over_standingup.csv') as csv_file:
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

discretization_wcut(dicto)

