#!/usr/bin/env python
import numpy as np
from scipy import integrate
import sys
from pyraf import iraf
import pysynphot as S
from astropy.io import ascii
import matplotlib.pyplot as plt

def getflux(star):
    cvs = star
    filename=cvs+'spectra.txt'
    tab = ascii.read(filename, names=['wave', 'flux']) 
    wave = tab['wave']  # First column
    flux = tab['flux']*10**(-20)  # Second column
    sp = S.ArraySpectrum(wave=wave, flux=flux, waveunits='angstrom', fluxunits='flam')

    bp_acs = S.ObsBandpass('acs,wfc1,f625w')
    obstar=S.Observation(sp, bp_acs, force='taper')
    obvega=S.Observation(S.Vega, bp_acs, force='taper')
        
    flux = -2.5 * np.log10(np.trapz(obstar.flux, x=obstar.wave)
            /np.trapz(obvega.flux, x = obvega.wave))
#    flux2 = -2.5 * np.log10(np.trapz(obstar.flux *obstar.wave ,x=obstar.wave)
            #/ np.trapz(obvega.flux *  obvega.wave ,x=obvega.wave)) + 25.731 
#    flux2 = -2.5 * np.log10(np.trapz(obstar.flux  ,x=obstar.wave)) - 25.731 

    plt.semilogy(obstar.wave, obstar.flux, 'k', label=cvs)
    plt.semilogy(obvega.wave, obvega.flux, 'r--', label='Vega')
    plt.xlim(4000,8000)
#    plt.show()

    return flux, obstar, obvega

#Old way
#
#
#    def find_nearest(array,value):
#        idx = (np.abs(array-value)).argmin()
#        return idx
#
#    def f(q):
#        return (0.49*(1+q)**(-1))/(0.6+q**(2/3.)*np.log(1+q**(-1/3.)))
#
#    def ratiodp(q,alpha,beta):
#        return 3**(1/3.)*(1+q)**(2/3.)*beta*np.sqrt(alpha*f(q))
#
##    cvs = sys.argv[1]
#    cvs = star
#    lmin = 5445.9
#    lmax = 7099.61
#
#    datax = []
#    datay = []
#    filename = '../'+cvs+'_nozap.fits'
#    iraf.onedspec.wspectext(filename, output=cvs+'spectra.txt', header=False)
#
#    with open(cvs+'spectra.txt') as f:
#        for line in f:
#            datax.append(line.split()[0])
#            datay.append(line.split()[1])
#
#    datax = np.array(datax, dtype=float)
#    datay = np.array(datay, dtype=float)
##    datayunits = [ i* units.erg/(units.s * units.cm*units.cm*units.Angstrom)   for i in datay]
##    halphapos = find_nearest(datax, 6563)
##    halpha=10**(-20)*datayunits[halphapos].to(units.erg /(units.Hz *units.cm**2 *units.s), equivalencies=units.spectral_density(6563*units.AA) )
##    halphaflux = -2.5*np.log10(halpha.value)- 48.6
# #   dataxunits =  [ i* units.Angstrom for i in datax]
##    minxstar = find_nearest(datax, lmin)
##    maxxstar = find_nearest(datax, lmax)
##    fluxstar = np.trapz(datay[minxstar:maxxstar])*10e-20
#    #dist =  2.34   #7.220485540633228e+19  # meters or 2.34 kpc
#    #distmodulus = 12.33
#    #m = 5.*np.log10() 
#
#    #VEga
##    minxvega = find_nearest(pysynphot.Vega.wave, lmin)
##    maxxvega = find_nearest(pysynphot.Vega.wave, lmax)
##    fluxvega = np.trapz(pysynphot.Vega.flux[minxvega:maxxvega])
#    
#
#
