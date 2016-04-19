#!/usr/bin/env python
import numpy as np
import os
import re
from pyraf import iraf
import subprocess
id=[]
VIvega=[]
with open('NGC6397R.RDVIQ.cal.adj.zpt') as f:
    f.readline()
    f.readline()
    f.readline()
    for line in f:
        id.append(line.split()[0])
        VIvega.append(line.split()[5])
VIvega = np.array(VIvega, dtype=float)
vimag=2.137
diff = [(int(i), float(j), abs(float(j-vimag))) for i,j in list(zip(id,VIvega))]
dtype = [('id',int), ('VIMAG', float), ('abs',float)]
diff = np.array(diff,dtype=dtype)
top=np.sort(diff, order='abs')
filelist=[]
#diff=sorted(enumerate(VIvega), key=lambda x: abs(x[1]-vimag))
for root,dirs,files in os.walk('.'):
        for file in files:
            for j in top[0:1000]: 
                                pattern='0{'+str(int(9-len(str(j[0]))))+'}'+str(j[0])
                #                print(pattern)
                                if re.findall(pattern,file):
                                            print(j)
                                            print(file)
                                            a='find ./* -name '+file
                                            b = subprocess.check_output(a,shell=True)
                                            #iraf.splot(b.replace('\n',''))
                                            filelist.append(b)
