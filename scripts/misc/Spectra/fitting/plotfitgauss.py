#!/usr/bin/env python

import numpy as np
import argparse
from astropy.io import fits
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
from pyraf import iraf
import re
from scipy import optimize

# 
parser = argparse.ArgumentParser(description='Plot fitted spectra')
parser.add_argument('filename', metavar='file', nargs=1, help='spectra to fit')
parser.add_argument('--xmin', metavar='xmin',default='6400')
parser.add_argument('--xmax', metavar='xmax',default='6700')



args = parser.parse_args()
filename = args.filename[0]
filename = filename+"_nozap_normalized.fits"
source=re.match('(U\d{1,2})', filename)
source = source.group()

xdata=[]
ydata=[]

iraf.onedspec.wspectext(filename, output=source+'spectra_norm.txt', header=False)


with open(source+'spectra_norm.txt','r') as files:
    for line in files:
        xdata.append(line.split()[0])
        ydata.append(line.split()[1])

xdata = np.array(xdata, dtype=float)
ydata = np.array(ydata, dtype=float)



def find_nearest(array,value):
    idx = (np.abs(array-value)).argmin()
    return idx



def wtosigma(w):
    sigma = w/(np.sqrt(8*np.log(2)))
    return sigma

def gaussian(x, mu, sig):
    return 1./(np.sqrt(2. * np.pi)*sig) * np.exp(-np.power(x-mu,2.) / (2.* np.power(sig, 2.)))

minx = find_nearest(xdata, float(args.xmin))
maxx = find_nearest(xdata, float(args.xmax))
xdata = xdata[minx:maxx]
ydata = ydata[minx:maxx]
###try fit

def gaussian(x, height, center, width, offset):
    return height*np.exp(-(x - center)**2/(2*width**2)) + offset

def two_gaussians(x,c1,c2, h,w, offset):
    return (gaussian(x, h, c1, w,  offset) + gaussian(x, h, c2, w, offset))

errfunc2 = lambda p, x, y: (two_gaussians(x, *p) - y)**2

guess2 = [6555, 6569, 1.5, 10, 1]  # I removed the peak I'm not too sure about
optim2, sucess = optimize.leastsq(errfunc2, guess2[:], args=(xdata, ydata))
print optim2
print 'DP:'+ str(optim2[1]-optim2[0])
#
## plot Gaussian
#
#
#gauss2 = np.zeros(len(xdata))
#
#
#
#
#for k in gaussiandata:
#    mean = float(k.split()[0])
#    cont = float(k.split()[1])
#    core = float(k.split()[4])
#    w = float(k.split()[5])
#    print mean
#    gauss2 +=  (gaussian(xdata, mean, wtosigma(w)))/core
#gauss2 = cont + gauss2 
#    
##plt.plot(xdata, cont + (mlab.normpdf(xdata, mean, wtosigma(w)))/core  )
#plt.plot(xdata, gauss2)
#
# All the rest is to make the plot look nice, with labels on the axes for example
plt.plot(xdata,ydata,'k', ls='steps-mid')
plt.plot(xdata, two_gaussians(xdata, *optim2))
plt.axis([xdata[0], xdata[-1], 0.0, 2.5])
plt.xlim(xdata[0], xdata[-1])
plt.ylim(0.5, 1.5)
plt.axhline(y=0, c='b')
plt.xlabel("Wavelength ($\AA$)")
plt.ylabel("Flux (10$^{-20}$ erg s$^{-1}$ cm$^{-2} \AA^{-1}$)")
plt.title("Fitted Spectra for "+source)

#plt.ylim(min(0.9, min(ydata)), max(ydata))
#plt.axhline(y=1.2, c='b')
#plt.legend(loc='upper left')


plt.show()

