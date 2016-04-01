#!/usr/bin/python2

#Cluster all the images, then creates a folder and move the images and tables group to their folder. 
from astropy.io import fits
import re
import numpy as np
import astropy.units as u
from astropy.coordinates import SkyCoord
import glob
import os
import matplotlib.pyplot as plt
from sklearn import cluster

with open('../config/params') as file:
    for line in file:
        if re.search('ESOREX_OUTPUT_DIR=', line):
            direc = line.split('=')[1]
os.chdir(direc.replace("\n", ""))

coordinates=[]
ra=[]
dec=[]
filenames=[]
integrationtime=[]

for file in glob.glob('*FOV*.fits'):
    tempfits = fits.open(file)
    filenames.append(tempfits.filename())
    coordinates.append(SkyCoord(tempfits[0].header['RA'], tempfits[0].header['DEC'],unit=(u.deg,u.deg)))
    ra.append(tempfits[0].header['RA'])
    dec.append(tempfits[0].header['DEC'])
    integrationtime.append(tempfits[0].header['EXPTIME'])   

labels = filenames

data = np.array(zip(ra,dec)) 
area = np.pi * (10 * np.ones(len(ra)))**2

k_means = cluster.KMeans(n_clusters=23)
k_means.fit(data)

ra = np.ones(len(ra)) * -1 * ra # To plot
plt.scatter(ra, dec , s=area ,c=k_means.labels_)

for label, x, y in zip(k_means.labels_, ra,dec):
        plt.annotate(
            label, 
            xy = (x, y), xytext = (np.random.rand()*50, 
            np.random.rand()*50 ),\
                    textcoords = 'offset points', ha = 'right', va = 'bottom',
                    arrowprops = dict(arrowstyle = '->', connectionstyle = 'arc3,rad=0'))

plt.show()
integrationtotal = [ (np.array(integrationtime)[np.where( k_means.labels_ == i)], np.sum(np.array(integrationtime)[np.where( k_means.labels_ == i)],)    ) for i in set(k_means.labels_)]


ra = ra * -1
with open('listacluster.txt','w') as files:
    for i,j,k in zip(ra,dec,k_means.labels_):
        files.write(str(i)+' '+str(j)+' '+str(k)+'\n')
            

num =   len(set(k_means.labels_))
print num
os.system('sort -k3 -n listacluster.txt > listaclustersorted.txt ; rm listacluster.txt; ')  

for i in set(k_means.labels_):
    if not os.path.exists('region'+str(i)):
            os.makedirs('region'+str(i))  
    listawhere = np.where(k_means.labels_ == i)
    nameswhere = np.array(filenames)[listawhere]
    expwhere = [ re.findall('\d{1,3}', k.split('_')[1]) for k in nameswhere ]
    for j in nameswhere:
        cmdcp1 = 'mv '+j+' region'+str(i)
        os.system(cmdcp1)
        cmdcp2 = 'mv ' + j.split('_')[0]+ \
                '_PIXTABLE_REDUCED_0001_EXP'+\
                re.findall('\d{1,3}', j.split('_')[1])[0] + '.fits region'+str(i)
        os.system(cmdcp2)





