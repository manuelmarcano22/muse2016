#!/usr/bin/env bash

##
#Creates two files with all the images and PIXTABLE_REDUCED tables, copy them and rename them. 
##

#Souce Params file with enviroment variables
scripts=/home/detoeuf/Manuel/scripts/autocombine
source $scripts/config/params 

cd $ESOREX_OUTPUT_DIR

test -f $ESOREX_OUTPUT_DIR/listallwhiteImages.txt || touch $ESOREX_OUTPUT_DIR/listallwhiteImages.txt   # Test if it does exist
> $ESOREX_OUTPUT_DIR'/listallwhiteImages.txt'; for i in `ls $DATA_LOCATION/2014-0[7,8]-[0-9][0-9]/EXP0*IMA*1.fits*`; do echo `readlink -f $i` >> $ESOREX_OUTPUT_DIR/listallwhiteImages.txt ; done

test -f $ESOREX_OUTPUT_DIR/listallPixtableReduced.txt || touch $ESOREX_OUTPUT_DIR/listallPixtableReduced.txt   # Test if it does exist
> $ESOREX_OUTPUT_DIR'/listallPixtableReduced.txt'; for i in `ls $DATA_LOCATION/2014-0[7,8]-[0-9][0-9]/PIXTABLE_REDUCED_*.fits`; do echo `readlink -f $i` >> $ESOREX_OUTPUT_DIR/listallPixtableReduced.txt ; done

for i in `cat $ESOREX_OUTPUT_DIR/listallwhiteImages.txt`; do name1=$(echo $i | cut -f 5 -d '/'); name2=$(echo $i | cut -f 6 -d '/'); cp $i $ESOREX_OUTPUT_DIR ; echo $i $name2; mv $name2 $name1'_'$name2 ;  done

for i in `cat $ESOREX_OUTPUT_DIR/listallPixtableReduced.txt`; do name1=$(echo $i | cut -f 5 -d '/'); name2=$(echo $i | cut -f 6 -d '/'); cp $i $ESOREX_OUTPUT_DIR ; echo $i $name2; mv $name2 $name1'_'$name2 ;  done

##Delete a outlier I know exists:
rm 2014-07-27_EXP01IMAGE_FOV_0001.fits
rm 2014-07-27_PIXTABLE_REDUCED_0001_EXP01.fits

