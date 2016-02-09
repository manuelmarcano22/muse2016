#!/usr/bin/python2
""" Program to create a list of the ARC to be use for the wavelenght calibration and see their lamps. """

from astropy.io import fits
import os
import numpy as np


direc = os.environ['ESOREX_OUTPUT_DIR']
os.chdir(direc)
os.system("cat mastersof.txt | grep ARC | awk '{ print $1 }' > arctodos.txt") 

filearc = open('filearc.txt', 'w')


templist=[0,0,0,0,0,0]
dict1 = {'T':'True', 'F':'False'}
with open('arctodos.txt') as fp:
	for line in fp:
		temp1 = line.split()
		temp = fits.open(temp1[0])
		templist[0] = temp[0].header[559]
		templist[1] = temp[0].header[562]
		templist[2] = temp[0].header[565]
		templist[3] = temp[0].header[568]
		templist[4] = temp[0].header[571]
		templist[5] = temp[0].header[574]
		print np.where(templist)[0][0]+1
		filearc.write(temp1[0]+' ' +'ARC'+' #'+str(np.where(templist)[0][0]+1)+'\n')
		temp.close()
filearc.close()
os.system('rm arctodos.txt')			
