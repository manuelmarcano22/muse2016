#!/usr/env/bin python2

import sys
import os
import glob
from PIL import Image

source = sys.argv[1]
logs = sys.argv[2]
name = sys.argv[3]

#move log and images
os.rename(logs, './logs/'+logs)
imagesiraf = glob.glob('sgi*.eps')

for i,j in enumerate(imagesiraf):
    print j
    im =  Image.open(j)
    im.save('./plots/'+name+'_'+source+'_'+str(i)+'.png')
    os.rename(j, './plots/'+name+'_'+source+'_'+str(i)+'.eps')




