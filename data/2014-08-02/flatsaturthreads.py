from astropy.io import fits
import numpy as np
import os
import fileinput
import re
import sys
import scipy.ndimage.filters as filters
import thread

import time
start = time.time()

#List of min values:
lista = np.zeros(24)
#Parameters of the filter
vecinos = 10 


nuthreads = 24
listathreads = np.zeros(nuthreads)

def getlist(Threadid,fitfile,listat):
	tempa = fitfile
	datamax = filters.uniform_filter(tempa[Threadid+1].data, vecinos)
	difftop = datamax > 55000
	diff = difftop
	#	diffbot = datamax < 5000
	#	diff = difftop | diffbot
	mask = np.where(diff,0,1)
	listat[Threadid] = mask.min()


for line in fileinput.input('mastersof.txt',inplace=True):
	global listathreads
	if str(line.split()[1]) == 'FLAT':
		tempa=fits.open(str(line.split()[0]))
		for i in range(len(listathreads)):
			thread.start_new_thread(getlist,(i, tempa, listathreads,)) 
		if listathreads.sum() == 24 :
			sys.stdout.write(line)	
		else:
			sys.stdout.write(line.replace(line,'#'+line)) 
		tempa.close()
	else: 
		sys.stdout.write(line)	

fileinput.close()
print 'It took', time.time()-start, 'seconds.'

