#!/usr/bin/python2
from astropy.io import fits
import numpy as np
import scipy.ndimage.filters as filters
import matplotlib.pyplot as plt
import functools

#try with an image
a = fits.open('MUSE.2014-08-01T12:05:38.555.fits.fz')

vecinos = 10
datamax = filters.uniform_filter(a[3].data, vecinos)

#Median but very slow
datamax = filters.median_filter(a[3].data, vecinos)
#median_filter = functools.partial(filters.generic_filter,function=np.median,size=(100,100))
#datamax = median_filter(a[3].data)


difftop = datamax > 55000
diff = difftop
#diffbot = datamax < 5000
#diff = difftop | diffbot
mask = np.where(diff,0,1) 
print mask.min()

plt.imshow(a[1].data * mask)
plt.colorbar()
plt.show()

