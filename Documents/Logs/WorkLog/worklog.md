# Feb-02-2016 IRAP Roche J042

## Summary


## Commits

### The server

The HP computer was set up so I can connect to the server via ssh to the computer *kerr.cesr.fr*. 

At first I will begin working with the computer of a previous Dr. Webb student. TO connect use:

```bash
ssh -X detoeuf@kerr.cesr.fr
```

The password was given by Dr. Webb. Can use **ds9** to visualize the server.  

I added the files ~/.vimrc and ~/pythonrc and added the line *export PYTHONSTARTUP* to ~/.bashrc
### The GitHub Repository

I created a private git repository called *muse2016*. 

### Data Download from ESO

I downloaded the frim the observation of the Cluster **NGC 6397**. The observation day was *2014-08-02*. The data can be download from the website [ESO Archive](archive.eso.org/eso/eso_archive_main.html).


### Astropy:

The server does have ipython and the module Astropy installed. Useful commands:

```python
from astropy.io import fits`
```

### To read the header from a fit:
hdulist = fits.open("name-of-file")
hduheado = hdulist[0].header


## To-Dos
- [x] ~~Download data to start processing.~~ Downloaded data taken on 2014-08-02 for NGC 6397.


# Feb-03-2016 IRAP Roche J042

## Summary


## Commits

### Questions and Problems:

- [x] ~~How to get the type information from header. Can fit it on the header. How many BIAS are needed?~~ All in *HIERARCH ESO ---*. For example.

- [x] MUSE cal bias and cal bias linearity?. Only cal_bias in the same day. Can use cal_bias simply

- [x] ~~Problem merging Bias works with max of 10 and min of 3.. When 11 doesnt work.~~ Wrong command to use it in parrallell was missing the `taskset` described in Appendix C.


- [x] ~~No Darks that same day. 200 in total for MUSE. Which one to use?. Also different ExpTime for the dakrs frm 1200 to 3600. Object is 60. In the Manueal ut says that the dark current is small so the dark is optional.~~  No darks for now.

- [x] ~~Many flats that day but only 3 with to that target RA and DEC. Only those 3?.~~ All Flats of the night. 

- [x] ~~Got problem *"unable to find recipe muse_bias"*.~~. I created a new config file and included where all the libs where the path is: `/opt/reflex/install/lib/esopipes-plugins/muse-1.0.1`

- [x] ~~Use muse_bias.rc?~~ Not for now. 

- [x] ~~Appendix D Callibations for Commisioning and Science Verification Data. Use those Geometry and Astrometric table and Solution?~~ FOund them online.


- [x] ~~BADPIX_TABLE in flat? It is optional and says: "The use if a bad pixel table may actually degrade the tracing solution if it contains bad colums. ~~ Used the one in cal folder.

- [x] ~~Where to find DPR TYPE WAVE for the wavelength calibration. They should be in MUSE calibration template~. Will download it from online catalog.  

### Python

Created a little script that writes the full path and frame tag of files

### Bash

The file createbias creates the sof for the recipe muse_bias and then uses EsoRex to get the master bias. 

The same for the flats.

### EsoRex

YOu can run esorex with a configuration file. with the flag `--config=`
In the file be sure to put the output directory, logfile dir.
If using EsoRex can use the .fz. In page 25 of Manual. 

Can work with up to 24 threads. Computer has 28. Found out that with `nproc`. So used `OMP_NUM_THREADS=24` before the esorex commands. Also need to use taskset. 

### BIAS

~~It works with the first 10 BIAS or the last 10. The moment I go from 10 to 11 it doesnt produced the final MASTER_BIAS.fits.~~. I needed to use to use `taskset` with for example `-c 0-5` with `--nifu=-1` and process them in parrallell. 



## To-Dos
- [x] ~~Bias download data.~~ Downloaded 22 Bias from the day 2014-08-01
- [x] Do master BIAS file
- [x] ~~Find out what darks to use.~~ Dont need the darks. Really low Current.
- [x] ~~Find out what Flats to use.~~ All the LAMP Flats of that night. 
- [x] ~~Do MASTER Flat.~~ **Did it with only three flats.**




# Feb-04-2016 IRAP Roche J042

## Summary


## Commits

### Flats

I downloaded all the flats produced the night 2014-08-01. Todos son FLAT,LAMPS.

### Static Calibration

The Static Calibration data seems to be in `/opt/reflex/install/calib/muse-1.0.1/cal` but for this particular first data set since it was taken before December 2014 I need to use the ones mentioned in Appendix D. Downloaded it from (ftp://ftp.eso.org/pub/dfs/pipelines/muse/muse-calib-legacy-2015-10-06.tar.gz).


### flatsatur.py

This program takes the average around 10 pixesl for each pixel. If in any is higher than 55000 then dont use that flat.

### ds9

To load an specific extension do:

```bash
ds9 <file>[#ofextension]
```
Open all of them in the same window:

```bash
ds9 -multiframe <file> opens all the 24 
```

Open then and can see them individually:

```bash
ds9 -mecube <file> 
```




## To-Dos
- [x] ~~Python and see max value of flats to see if oversaturated.~~ Function called flatsatruthreads using getlist.py
- [x] ~~Find static calibration data.~~  Used the ones mentioned in Appendix D.

# Feb-04-2016 IRAP Roche J042

## Summary


## Questions

- [ ] How taskset and OMP_NUM_THREAD work. Different numbers?
- [ ] They say "Since thre is only a single detector configuration available for MUSE, there is no real need to verify that the detector parameters of the raw data frames and calibartions mathc. 


### Multiprocessing

### Memory Overload RAM

There is a problem with the 60 flats and ARC that I have. I only have 30 GB of ram so need to run them in part then combine them to get the final one. Can do it with option

`output-prefix`

### task set

found in (https://www.eso.org/sci/activities/santiago/projects/sc-computing.html) should run it like:

`taskset -c 0-23 esorex ...`


### Data

The data is now in the path: `/mnt/data/MUSE` 


## Commits

## To-Dos
- [x] Download all the arc-lamp and SKYFLATS 

# Feb-10-2016 IRAP Roche J042

## Summary

### Wavelength calibration

I wasnt able to get it done. The problem might have been two things, either that I didn't have an ARC for each lamp or that I was using two different instrument modes.

### Instruments Mode and OBS Name

In the data I downloaded for the day I had two different instrument mode as can be seen in the header. I had WFM-NOAA-E and WFM-NOAA-N. It stands for  Wide Field Mode with no AO (NOAO) correction in Nominal or Extended. 

### FLATS

I have two types of flats according to the OBS NAME tag in the header "Calibration" and "muocal_nightcalib". I have 22 of one and 5 of the second.  

## Questions
- [x] ~~Do MASTER Flat with all flats of the night and BADPIXEL Table.~~ but only with the "muocal_nightcalib" 5.
- [x] ~~Do the wavelength calibration~~ It worked with three Arc one for each lamp.
- [x] ~~Python and see max value of flats to see if oversaturated.~~ All of them passed the tested. Weird?
- [x] ~~Do MASTER Flat with all flats of the night~~ Still dont know if need all. 
- [ ] How many flats to use?
- [ ] How many threads can use with taskset and OMP_NUM_THREAD?
- [ ] Automate MASTER_BIAS and FLATS. The problem is that it comsumes too much memory. 
- [ ] How many threads can use with taskset and OMP_NUM_THREAD?

