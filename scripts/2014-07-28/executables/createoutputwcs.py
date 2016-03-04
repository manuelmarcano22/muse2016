#!/usr/bin/python2

from astropy.io import fits
import os
os.system('cp EXP2to3shapeIMAGE_FOV_0001.fits newWCS.fits')

headerco= fits.open('DATACUBE_FINAL_EXP02.fits')



