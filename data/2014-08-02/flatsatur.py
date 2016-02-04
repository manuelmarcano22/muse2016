from astropy.io import fits
import numpy as np
import os
import fileinput
import re
import sys
import scipy.ndimage.filters as filters

import time
start = time.time()

#List of min values:
lista = np.zeros(24)
#Parameters of the filter
vecinos = 10 


for line in fileinput.input('mastersof.txt',inplace=True):
	if str(line.split()[1]) == 'FLAT':
		tempa=fits.open(str(line.split()[0]))
		for i in range(1,25):
			datamax = filters.uniform_filter(tempa[i].data, vecinos)
			difftop = datamax > 55000
			diff = difftop
		#	diffbot = datamax < 5000
		#	diff = difftop | diffbot
			mask = np.where(diff,0,1)
			lista[i-1] = mask.min()
		if mask.min() == 24 :
			sys.stdout.write(line)	
		else:
			sys.stdout.write(line.replace(line,'#'+line)) 
		tempa.close()
	else: 
		sys.stdout.write(line)	

fileinput.close()
print 'It took', time.time()-start, 'seconds.'

