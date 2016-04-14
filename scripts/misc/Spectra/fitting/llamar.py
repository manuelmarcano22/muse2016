#!/usr/bin/env python

import argparse
import os
import re

parser = argparse.ArgumentParser(description='Fit Gaussian to Spectra')
parser.add_argument('spectra', metavar='file', nargs=1, help='spectra to fit')
parser.add_argument('points', metavar='fitting points', nargs='*', help='Points to fit')
parser.add_argument('--log', metavar='log name', help='Log file name')
parser.add_argument('--name', metavar='name', help='name Images')
parser.add_argument('--xmin', metavar='xmin',default='6400')
parser.add_argument('--xmax', metavar='xmax',default='6700')
parser.add_argument('--plot',  action='store_true')
parser.add_argument('--smooth',  action='store_true')


args = parser.parse_args()
source=re.match('(U\d{1,2})',args.spectra[0])
source = source.group()

if not args.log:
    args.log = source

if not args.xmin:
    args.xmin = 6400
    args.xmax = 6700


cmd= 'python trypython.py '+args.spectra[0]+' '+ (' ').join(args.points)+' --log '+args.log +\
        ' --xmin '+args.xmin +' --xmax '+args.xmax

os.system(cmd)

cmd2 = 'python rename.py '+ source + ' ' + args.log+'.log '+args.name 
os.system(cmd2)

if args.plot:
    cmd3= 'python plotspectra.py '+args.spectra[0]+' --log '+args.log +\
                    ' --xmin '+args.xmin +' --xmax '+args.xmax

    os.system(cmd3)



