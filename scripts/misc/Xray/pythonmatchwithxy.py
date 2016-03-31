#!/usr/bin/python3
from astropy.coordinates import SkyCoord
from astropy.io import fits
from astropy import units as u
import os
import sys
from operator import itemgetter
import numpy as np
from astropy import wcs
import subprocess

#Define the angle to rotate
angle = float(sys.argv[1])
angle = np.deg2rad(angle)
#Import data of the images 
os.system('cp ../fits/ds9xray60.fits ../fits/ds9xray60mod.fits')
imagemuse = fits.open('../fits/CenterEXPtoredIMAGE_FOV_0001.fits')
imagechandra = fits.open('../fits/ds9xray60mod.fits')
datachandra= imagechandra[0].data
museWCS=wcs.WCS(imagemuse[0].header)
chandraWCS=wcs.WCS(imagechandra[0].header)
# Create template for regions for ds9
os.system('head -n 3 ../fits/contoursandregions/xraybrightmanual.reg > ../fits/contoursandregions/newreg.reg')

# Loop for best fit


#Default crval and crpix
try:
    refstar = int(sys.argv[2])
except:
    refstar=2

refstar=str(refstar)+'p'
refstarc = subprocess.check_output(['sed','-n', refstar, 'catalogchandra.txt']).decode('utf-8')
refstarm = subprocess.check_output(['sed','-n', refstar, 'catalogmuse.txt']).decode('utf-8')
refstarname = refstarc.split()[0]

refcoordc = SkyCoord(refstarc.split()[1] , refstarc.split()[2] , unit=(u.hour, u.deg), frame='fk5')
refcoordm = SkyCoord(refstarm.split()[1] , refstarm.split()[2] , unit=(u.hour, u.deg), frame='fk5')


chandraWCS.wcs.pc = [[np.cos(angle),-np.sin(angle)], [np.sin(angle), np.cos(angle)]]
chandraWCS.wcs.crval=[refcoordm.ra.value  ,refcoordm.dec.value]
chandraWCS.wcs.crpix =[float(refstarc.split()[3])  , float(refstarc.split()[4]) ]
header = chandraWCS.to_header()
fits.writeto('../fits/ds9xray60mod.fits', datachandra, header, clobber=True)

ramuse=[]
decmuse=[]
rachandranew=[]
decchandranew=[]

ii=0.

with open('catalogchandra.txt','r') as fc, open('newcatchandra','w') as fnew, open('../fits/contoursandregions/newreg.reg','a') as freg:
    for line in fc:
        temp = subprocess.check_output(['xy2sky',imagechandra.filename(), line.split()[3], line.split()[4]])
        fnew.write(line.split()[0]+' '+temp.decode('utf-8'))
        rachandranew.append(temp.decode('utf-8').split()[0])
        decchandranew.append(temp.decode('utf-8').split()[1])
        ii=.1
        freg.write(\
        'circle('+ str(temp.decode('utf-8').split()[0]) +','+ str(temp.decode('utf-8').split()[1]) +','+str(ii)+'")\n')
 
 
with open('catalogmuse.txt') as fm:
    for line in fm:
        ramuse.append(line.split()[1])
        decmuse.append(line.split()[2])




c = SkyCoord(ramuse, decmuse, unit=(u.hour, u.deg), frame='fk5')
catalog = SkyCoord(rachandranew, decchandranew, unit=(u.hour, u.deg), frame='fk5')
idx, d2d, d3d = c.match_to_catalog_sky(catalog)
matches = catalog[idx]  
dra = (matches.ra - c.ra).arcsec  
ddec = (matches.dec - c.dec).arcsec
#print(np.rad2deg(angle), dra, ddec)
with open('shift.txt','a') as file:
            file.write(str(refstarname)+'('+str(refstar)+') ' +  str(np.rad2deg(angle)) +' '+ \
                    '|mean ra|: '+str(abs(np.mean(dra))) + ' |mean dec|: ' + str(abs(np.mean(ddec))) 
                    + ' mean both: '+\
                    str(abs(np.mean([abs(np.mean(dra)), abs(np.mean(ddec))])))+\
                    '\n')

try:
    sys.argv[3]
    cmd3 = 'ds9 -scale log -scale minmax ../fits/ds9xray60mod.fits -frame new ../fits/EXPtoredIMAGE_FOV_0001.fits -regions load all ../fits/contoursandregions/newreg.reg  &'
    os.system(cmd3)
except:
    a=5
    #print('done')


