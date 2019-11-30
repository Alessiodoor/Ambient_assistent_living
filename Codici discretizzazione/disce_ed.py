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

#discretizzazione di una specifica colonna del dataset
#col: nome della colonna
def discrete_col(col, bins, dicto):
	x1 = []
	x1.extend(dicto[('debora', 'sitting')][col])
	x1.extend(dicto[('debora', 'standing')][col])
	x1.extend(dicto[('debora', 'walking')][col])
	x1.extend(dicto[('debora', 'sittingdown')][col])
	x1.extend(dicto[('debora', 'standingup')][col])

	x1.extend(dicto[('katia', 'sitting')][col])
	x1.extend(dicto[('katia', 'standing')][col])
	x1.extend(dicto[('katia', 'walking')][col])
	x1.extend(dicto[('katia', 'sittingdown')][col])
	x1.extend(dicto[('katia', 'standingup')][col])

	x1.extend(dicto[('wallace', 'sitting')][col])
	x1.extend(dicto[('wallace', 'standing')][col])
	x1.extend(dicto[('wallace', 'walking')][col])
	x1.extend(dicto[('wallace', 'sittingdown')][col])
	x1.extend(dicto[('wallace', 'standingup')][col])

	x1.extend(dicto[('jose_carlos', 'sitting')][col])
	x1.extend(dicto[('jose_carlos', 'standing')][col])
	x1.extend(dicto[('jose_carlos', 'walking')][col])
	x1.extend(dicto[('jose_carlos', 'sittingdown')][col])
	x1.extend(dicto[('jose_carlos', 'standingup')][col])

	discrete_dat, cutoff = discretize(x1, bins)
	cutoff.append(max(x1))
	cutoff.insert(0, min(x1))

	return (discrete_dat, cutoff)

#restituisce tutti i valori di una determinata colonna
#col: nome della colonna
#position: restituisce solo i valori di una attività (sitting, standing, walking, sittingdown, standingup)
#position: restituisce solo i valori di un determinati soggetto
def get_col(col, dicto, position = None, user = None):
	x1 = []
	if position is not None and user is None:
		print('only pos')
		x1.extend(dicto[('debora', position)][col])

		x1.extend(dicto[('katia', position)][col])

		x1.extend(dicto[('wallace', position)][col])

		x1.extend(dicto[('jose_carlos', position)][col])

		return x1
	if position is None and user is not None:
		print('only user')
		x1.extend(dicto[(user, 'sitting')][col])
		x1.extend(dicto[(user, 'standing')][col])
		x1.extend(dicto[(user, 'walking')][col])
		x1.extend(dicto[(user, 'sittingdown')][col])
		x1.extend(dicto[(user, 'standing')][col])	

		return x1
	if position is not None and user is not None:
		print('all')
		x1.extend(dicto[(user, position)][col])

		return x1

	print('pos and user')
	x1.extend(dicto[('debora', 'sitting')][col])
	x1.extend(dicto[('katia', 'sitting')][col])
	x1.extend(dicto[('wallace', 'sitting')][col])
	x1.extend(dicto[('jose_carlos', 'sitting')][col])

	x1.extend(dicto[('debora', 'sittingdown')][col])
	x1.extend(dicto[('katia', 'sittingdown')][col])
	x1.extend(dicto[('wallace', 'sittingdown')][col])
	x1.extend(dicto[('jose_carlos', 'sittingdown')][col])

	x1.extend(dicto[('debora', 'standing')][col])
	x1.extend(dicto[('katia', 'standing')][col])
	x1.extend(dicto[('wallace', 'standing')][col])
	x1.extend(dicto[('jose_carlos', 'standing')][col])

	x1.extend(dicto[('debora', 'standingup')][col])
	x1.extend(dicto[('katia', 'standingup')][col])
	x1.extend(dicto[('wallace', 'standingup')][col])
	x1.extend(dicto[('jose_carlos', 'standingup')][col])

	x1.extend(dicto[('debora', 'walking')][col])
	x1.extend(dicto[('katia', 'walking')][col])
	x1.extend(dicto[('wallace', 'walking')][col])
	x1.extend(dicto[('jose_carlos', 'walking')][col])

	return x1

#stampa i valori degli accellerometri di un soggetto in una determinata posizione
def acc_positions(i, user, position, dicto):
	x1 = dicto[(user, position)]['x1'][i]
	y1 = dicto[(user, position)]['y1'][i]
	z1 = dicto[(user, position)]['z1'][i]

	x2 = dicto[(user, position)]['x2'][i]
	y2 = dicto[(user, position)]['y2'][i]
	z2 = dicto[(user, position)]['z2'][i]

	x3 = dicto[(user, position)]['x3'][i]
	y3 = dicto[(user, position)]['y3'][i]
	z3 = dicto[(user, position)]['z3'][i]

	x4 = dicto[(user, position)]['x4'][i]
	y4 = dicto[(user, position)]['y4'][i]
	z4 = dicto[(user, position)]['z4'][i]

	print('Col: ' + str(i) + ' user: ' + user + ' position: ' + position)
	print('anca:', x1, y1, z1)
	print('coscia:', x2, y2, z2)
	print('caviglia:', x3, y3, z3)
	print('braccio:', x4, y4, z4)

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
	
	print('Writing discrete csv')

	csv_writer = csv.writer(open('Data_discrete.csv', 'w', newline=''), delimiter=';', quoting=csv.QUOTE_MINIMAL)
	csv_writer.writerow(['user', 'gender', 'age', 'how_tall_in_meters', 'weight', 'body_mass_index', 'x1', 'y1', 'z1' ,'x2' ,'y2' ,'z2' ,'x3' ,'y3' ,'z3', 'x4', 'y4' ,'z4' ,'class'])
	with open('Dataset.csv') as csv_file:
		cvs_reader = csv.reader(csv_file, delimiter = ';')
		next(cvs_reader)#salto titolo
		i = 0
		for row in cvs_reader:
			csv_writer.writerow([row[0], row[1], row[2], row[3], row[4], row[5], discrete_dat_x1[i], discrete_dat_y1[i], discrete_dat_z1[i], discrete_dat_x2[i], discrete_dat_y2[i], discrete_dat_z2[i], discrete_dat_x3[i], discrete_dat_y3[i], discrete_dat_z3[i], discrete_dat_x4[i], discrete_dat_y4[i], discrete_dat_z4[i], row[18]])	
			i += 1	

	print('Done')

#mostra il grafico dell'andamento di una determinata colonna, è possibile impostare anche soggetto e attività
def and_col(col, dicto, user = None, position = None):
	values = get_col(col, dicto, user = user, position = position)
	plt.figure(figsize = (16, 10))
	plt.plot(range(0, len(values)), values)
	plt.show()

def and_col_all(coord, dicto):
	col = str(coord) + '1'
	print(col)
	values_1 = get_col(col, dicto)

	col = str(coord) + '2'
	print(col)
	values_2 = get_col(col, dicto)

	col = str(coord) + '3'
	print(col)
	values_3 = get_col(col, dicto)

	col = str(coord) + '4'
	print(col)
	values_4 = get_col(col, dicto)
	plt.figure(figsize = (16, 10))
	plt.plot(range(0, len(values_1)), values_1, 's', label = '1')
	plt.plot(range(0, len(values_2)), values_2, 'v', label = '2')
	plt.plot(range(0, len(values_3)), values_3, '<', label = '3')
	plt.plot(range(0, len(values_4)), values_4, 'o', label = '4')
	plt.legend()
	plt.show()
	
#struttura del dizionario ricavato dal dataset
#{('user', 'class') : {'x1', 'y1', 'z1', 'x2', 'y2', 'z2', 'x3', 'y3', 'z3', 'x4', 'y4', 'z4'}}
dicto = {}
print('Reading csv...')

with open('Dataset.csv') as csv_file:
	cvs_reader = csv.reader(csv_file, delimiter = ';')
	next(cvs_reader)#salto titolo

	for row in cvs_reader:
		key = (row[0], row[18])
		if key in dicto.keys():
			i = 6
			for k in dicto[key].keys():
				dicto[key][k].append(int(row[i]))
				i += 1
		else:
			dicto[key] = {'x1': [int(row[6])], 'y1': [int(row[7])], 'z1': [int(row[8])], 'x2': [int(row[9])], 'y2': [int(row[10])], 'z2': [int(row[11])], 'x3': [int(row[12])], 'y3': [int(row[13])], 'z3': [int(row[14])], 'x4': [int(row[15])], 'y4': [int(row[16])], 'z4': [int(row[17])]}
print('Done')

discretization(dicto)

#and_col_all('y', dicto)
'''print('x1')
col = sorted(get_col('x1', dicto))

print(col[:10])
print(col[-10:])

print('y1')
col = sorted(get_col('y1', dicto))

print(col[:10])
print(col[-10:])

print('z1')
col = sorted(get_col('z1', dicto))
print(col[:10])
print(col[-10:])

print('x2')
col = sorted(get_col('x2', dicto))

print(col[:10])
print(col[-10:])

print('y2')
col = sorted(get_col('y2', dicto))

print(col[:10])
print(col[-10:])

print('z2')
col = sorted(get_col('z2', dicto))
print(col[:10])
print(col[-10:])

print('x3')
col = sorted(get_col('x3', dicto))

print(col[:10])
print(col[-10:])

print('y3')
col = sorted(get_col('y3', dicto))

print(col[:10])
print(col[-10:])

print('z3')
col = sorted(get_col('z3', dicto))
print(col[:10])
print(col[-10:])

print('x4')
col = sorted(get_col('x4', dicto))

print(col[:10])
print(col[-10:])

print('y4')
col = sorted(get_col('y4', dicto))

print(col[:10])
print(col[-10:])

print('z4')
col = sorted(get_col('z4', dicto))

print(col[:10])
print(col[-10:])'''
'''
col = get_col('y1', user = 'debora', position = 'sitting')

print('mean', sum(col)/len(col))
print("Standard Deviation ", statistics.stdev(col))
print('min', min(col))
print('max', max(col))'''

'''
print('min-max x1 debora')
print('sitting')
print(min(dicto[('debora', 'sitting')]['x2']))
print(max(dicto[('debora', 'sitting')]['x2']))'''
'''print('standing')
print(min(dicto[('debora', 'standing')]['x1']))
print(max(dicto[('debora', 'standing')]['x1']))
print('walking')
print(min(dicto[('debora', 'walking')]['x1']))
print(max(dicto[('debora', 'walking')]['x1']))
print('sittingdown')
print(min(dicto[('debora', 'sittingdown')]['x1']))
print(max(dicto[('debora', 'sittingdown')]['x1']))
print('standingup')
print(min(dicto[('debora', 'standingup')]['x1']))
print(max(dicto[('debora', 'standingup')]['x1']))'''
'''
print('min-max x1 katia')
print('sitting')
print(min(dicto[('katia', 'sitting')]['x2']))
print(max(dicto[('katia', 'sitting')]['x2']))

print('min-max x1 katia')
print('sitting')
print(min(dicto[('wallace', 'sitting')]['x2']))
print(max(dicto[('wallace', 'sitting')]['x2']))

print('min-max x1 katia')
print('sitting')
print(min(dicto[('jose_carlos', 'sitting')]['x2']))
print(max(dicto[('jose_carlos', 'sitting')]['x2']))'''










