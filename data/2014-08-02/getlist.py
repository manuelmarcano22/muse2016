import numpy as np
import scipy.ndimage.filters as filters

def getlist(tempa):
	#datamax = filters.uniform_filter(tempa[Threadid+1].data, vecinos)
        vecinos = 10
	datamax = filters.uniform_filter(tempa, vecinos)
	difftop = datamax > 55000
	diff = difftop
	#	diffbot = datamax < 5000
	#	diff = difftop | diffbot
	mask = np.where(diff,0,1)
	return mask.min()
