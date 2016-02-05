# It creates a file with the path and the Frame tag depending on its TYPE as stated in Table 
# 6.1 in the MUSE PIPELINE MANUAL
from astropy.io import fits
import os
import glob

#Change to where the data is:
os.chdir('/mnt/data/MUSE/2014-08-02')

files = glob.glob('*.fz')
dictype = {'BIAS': 'BIAS','DARK': 'DARK','FLAT,LAMP':'FLAT','LAMP,FLAT': 'FLAT','FLAT,SKY':'SKYFLAT','SKY,FLAT': 'SKYFLAT','WAVE':'ARC','WAVE,MASK':'MASK','MASK,WAVE':'MASK','STD':'STD','ASTROMETRY':'ASTROMETRY','SKY':'SKY','OBJECT':'OBJECT','FLAT,LAMP,ILLUM':'ILLUM'}
mastersof = open('mastersof.txt','w')

for f in files:
    temp = fits.open(str(f))
    temppath = os.path.realpath(f)
    typetemp = temp[0].header['*DPR TYPE*'][0]
    mastersof.write(temppath+' '+dictype[typetemp]+'\n')
    print(temp[0].header['*DPR TYPE*'][0])
    temp.close()
mastersof.close()
os.system('sort -k2 mastersof.txt > temp.txt')
os.system('cp temp.txt mastersof.txt')
os.system('rm temp.txt')
