#!/usr/bin/env python

import numpy as np
import argparse
from astropy.io import fits
import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
from pyraf import iraf
import re

# 
parser = argparse.ArgumentParser(description='Plot fitted spectra')
parser.add_argument('filename', metavar='file', nargs=1, help='spectra to fit')
parser.add_argument('--log', metavar='log name', help='Log file name')
parser.add_argument('--xmin', metavar='xmin',default='6400')
parser.add_argument('--xmax', metavar='xmax',default='6700')



args = parser.parse_args()
filename = args.filename[0]
source=re.match('(U\d{1,2})', filename)
source = source.group()


#Get log
if not args.log:
    args.log = source


def isfloat(value):
  try:
    float(value)
    return True
  except ValueError:
    return False


gaussiandata=[]
with open('./logs/'+args.log+'.log','r') as logf:
    for line in logf:
        if line != '\n':
            if all([ isfloat(j) for j in line.decode('utf-8').split()]):
                gaussiandata.append(line)

xdata=[]
ydata=[]
iraf.onedspec.wspectext(filename, output=source+'spectra.txt', header=False)

with open(source+'spectra.txt','r') as files:
    for line in files:
        xdata.append(line.split()[0])
        ydata.append(line.split()[1])

xdata = np.array(xdata, dtype=float)
ydata = np.array(ydata, dtype=float)


#Plot data
plt.plot(xdata,ydata,'k', ls='steps-mid')


def wtosigma(w):
    sigma = w/(np.sqrt(8*np.log(2)))
    return sigma

def gaussian(x, mu, sig):
    return 1./(np.sqrt(2. * np.pi)*sig) * np.exp(-np.power(x-mu,2.) / (2.* np.power(sig, 2.)))


# plot Gaussian
gauss2 = np.zeros(len(xdata))

for k in gaussiandata:
    mean = float(k.split()[0])
    cont = float(k.split()[1])
    core = float(k.split()[4])
    w = float(k.split()[5])
    print mean
    gauss2 +=  (gaussian(xdata, mean, wtosigma(w)))/core
gauss2 = cont + gauss2 
    
#plt.plot(xdata, cont + (mlab.normpdf(xdata, mean, wtosigma(w)))/core  )
plt.plot(xdata, gauss2)

# All the rest is to make the plot look nice, with labels on the axes for example
plt.axis([xdata[0], xdata[-1], 0.0, 2.5])
plt.xlim(xdata[0], xdata[-1])
plt.axhline(y=0, c='b')
plt.xlabel("Wavelength ($\AA$)")
plt.ylabel("Flux (10$^{-20}$ erg s$^{-1}$ cm$^{-2}$)")
plt.title("Fitted Spectra for "+source)

#plt.ylim(min(0.9, min(ydata)), max(ydata))
#plt.axhline(y=1.2, c='b')
#plt.legend(loc='upper left')


plt.show()

