from astropy.io import fits
import numpy as np
import os
import fileinput
import re
import sys
import scipy.ndimage.filters as filters
import multiprocessing as mp
from getlist import getlist
import time

start = time.time()
pool = mp.Pool(processes = 20)


for line in fileinput.input('mastersof.txt',inplace=True):
	if str(line.split()[1]) == 'FLAT':
		tempa=fits.open(str(line.split()[0]))
	        results = [pool.apply(getlist, args=(tempa[x].data,)) for x in range(1,25)]
		if np.array(results).sum() == 24 :
			sys.stdout.write(line)	
		else:
			sys.stdout.write(line.replace(line,'#'+line)) 
		tempa.close()
	else: 
		sys.stdout.write(line)	

fileinput.close()
print 'It took', time.time()-start, 'seconds.'

