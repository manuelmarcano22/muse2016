#!/usr/bin/python2
# It creates a file with the path and the Frame tag depending on its TYPE as stated in Table 
# 6.1 in the MUSE PIPELINE MANUAL
#Need to be called thought bash script "createmastersof" to get the enviroment variables. 

from astropy.io import fits
import os
import glob

#Change to where the data is:
direc = os.environ['ESOREX_OUTPUT_DIR']
os.chdir(direc)

files = glob.glob('*.fz')
dictype = {'BIAS': 'BIAS','DARK': 'DARK','FLAT,LAMP':'FLAT','LAMP,FLAT': 'FLAT','FLAT,SKY':'SKYFLAT','SKY,FLAT': 'SKYFLAT','WAVE':'ARC','WAVE,MASK':'MASK','MASK,WAVE':'MASK','STD':'STD','ASTROMETRY':'ASTROMETRY','SKY':'SKY','OBJECT':'OBJECT','FLAT,LAMP,ILLUM':'ILLUM'}
mastersof = open('mastersof.txt','w')

for f in files:
    temp = fits.open(str(f))
    temppath = os.path.realpath(f)
    typetemp = temp[0].header['*DPR TYPE*'][0]
    mastersof.write(temppath   +' '+  dictype[typetemp] + ' # ' + temp[0].header["*INS MODE"][0] 
            +' '+ temp[0].header['*OBS NAME'][0]  +' '+ temp[0].header['*DATE-OBS*'][0] +' '+  str(temp[0].header['*TEMP11 VAL'][0])   + '\n')
    print temp[0].header['*DPR TYPE*'][0] , temp[0].header['*INS MODE'][0], temp[0].header['*OBS NAME'][0], temp[0].header['*DATE-OBS*'][0], temp[0].header['*TEMP11 VAL'][0]  
    temp.close()
mastersof.close()
os.system('sort -k2 -k3 -k5 -k6 mastersof.txt > temp.txt')
os.system('cp temp.txt mastersof.txt')
os.system('rm temp.txt')
