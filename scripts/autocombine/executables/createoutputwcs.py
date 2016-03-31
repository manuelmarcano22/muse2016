#!/usr/bin/env python2

from astropy.io import fits
from astropy import wcs

datac = fits.open('DATACUBE_FINAL_EXP05.fits')
datacw = wcs.WCS(datac[1].header)
im=fits.open('newWCSe.fits')
imw = wcs.WCS(im[1].header)

