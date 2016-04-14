#!/usr/bin/env python2
import pyraf
from pyraf import iraf
from PIL import Image
import argparse
import re
import numpy as np
import glob
import os


parser = argparse.ArgumentParser(description='Fit Gaussian to Spectra')
parser.add_argument('spectra', metavar='file', nargs=1, help='spectra to fit')
parser.add_argument('points', metavar='fitting points', nargs='*', help='Points to fit')
parser.add_argument('--log', metavar='log name', help='Log file name')
parser.add_argument('--xmin', metavar='xmin',default='6400')
parser.add_argument('--xmax', metavar='xmax',default='6700')
parser.add_argument('--plot',  action='store_true')



args = parser.parse_args()
source=re.match('(U\d{1,2})',args.spectra[0])
source = source.group()

if not args.log:
    args.log = source

# Create Cursor file
with open(source+'.cur', 'w') as filecur:
    filecur.write(
            '0 0 1 \n' +\
                args.xmin + ' 1 1 a \n' +
                args.xmax + ' 1 1 a \n' +
                args.xmin + ' 1 1 d \n' +
                args.xmax + ' 1 1 d \n' 
                )
    for i in args.points:
        filecur.write(
                i +' 1 1 g \n'
                )
    filecur.write(
            '0 0 1 q \n' 
            '0 0 1 a \n'
            '0 0 1 a \n'
            '0 0 1 y \n'
            '0 0 1 t \n'
            '0 0 1 q \n'
            )

iraf.splot(args.spectra[0],cursor=source+'.cur' , save_file=args.log+'.log', graphics='eps')

iraf.gflush


#print 'call:\n python2 rename.py '+ source +' '+args.log+'.log'
#print 'to plot: \n python2 plotspectra.py '+ args.spectra[0] 

##move log and images
#os.rename(args.log+'.log', './logs/'+args.log+'.log')
#imagesiraf = glob.glob('sgi*.eps')
#
#for i,j in enumerate(imagesiraf):
#    print j
#    im =  Image.open(j)
#    im.save('./plots/'+source+'_'+str(i)+'.png')
#    os.rename(j, './plots/'+source+'_'+str(i)+'.eps')
#



