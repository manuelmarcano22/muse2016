#!/usr/bin/python2
# It creates a file with the path and the Frame tag depending on its TYPE as stated in Table 
# 6.1 in the MUSE PIPELINE MANUAL
#Need to be called thought bash script "createmastersof" to get the enviroment variables. 

from astropy.io import fits
import numpy as np
import os
import glob

#Change to where the data is:
direc = os.environ['ESOREX_OUTPUT_DIR']
os.chdir(direc)

files = glob.glob('*.fz')
dictype = {'BIAS': 'BIAS','DARK': 'DARK','FLAT,LAMP':'FLAT','LAMP,FLAT': 'FLAT','FLAT,SKY':'SKYFLAT','SKY,FLAT': 'SKYFLAT','WAVE':'ARC','WAVE,MASK':'MASK','MASK,WAVE':'MASK','STD':'STD','ASTROMETRY':'ASTROMETRY','SKY':'SKY','OBJECT':'OBJECT','FLAT,LAMP,ILLUM':'ILLUM'}


def getlamp(temp):
    templist=[0,0,0,0,0,0]
    templist[0] = temp[0].header[559]
    templist[1] = temp[0].header[562]
    templist[2] = temp[0].header[565]
    templist[3] = temp[0].header[568]
    templist[4] = temp[0].header[571]
    templist[5] = temp[0].header[574]
    return np.where(templist)[0][0]+1


mastersof = open('mastersof.txt','w')

for f in files:
    temp = fits.open(str(f))
    temppath = os.path.realpath(f)
    typetemp = temp[0].header['*DPR TYPE*'][0]
    mastersof.write(temppath   +' '+  dictype[typetemp] + ' # ' + temp[0].header["*INS MODE"][0] 
            +' '+ temp[0].header['*OBS NAME'][0]  +' '+ temp[0].header['*DATE-OBS*'][0] +' '
            +  str(temp[0].header['*TEMP11 VAL'][0]) + ' '+ temp[0].header['*READ CURNAME*'][0]   
            +  (' lamp: #'+str(getlamp(temp)) if typetemp == 'ARC' else '')  
            + (' RA:'+ str(temp[0].header['RA']) if typetemp=='ASTROMETRY' or typetemp=='STD' or typetemp=='OBJECT' else '')   
            + (' DEC:'+ str(temp[0].header['DEC']) if typetemp=='ASTROMETRY' or typetemp=='STD' or typetemp=='OBJECT'  else '' )    
            + '\n')
    print temp[0].header['*DPR TYPE*'][0] , temp[0].header['*INS MODE'][0] \
        , temp[0].header['*OBS NAME'][0], temp[0].header['*DATE-OBS*'][0], temp[0].header['*TEMP11 VAL'][0],temp[0].header['*READ CURNAME*'][0] \
        , (' lamp: #'+str(getlamp(temp)) if typetemp == 'WAVE' else '')  , (' RA:'+ str(temp[0].header['RA']) if typetemp=='ASTROMETRY' or typetemp=='STD' else '') \
        , (' DEC:'+ str(temp[0].header['DEC']) if typetemp=='ASTROMETRY' or typetemp=='STD'  else '' )    


    temp.close()
mastersof.close()
os.system('sort -k5 -k2 -k3  -k6 mastersof.txt > temp.txt')
os.system('cp temp.txt mastersof.txt')
os.system('rm temp.txt')
