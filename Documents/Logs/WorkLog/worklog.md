# Feb-02-2016 IRAP Roche J042


## Commits

### The server

The HP computer was set up so I can connect to the server via ssh to the computer *kerr.cesr.fr*. 

At first I will begin working with the computer of a previous Dr. Webb student. To connect use:

```bash
ssh -X detoeuf@kerr.cesr.fr
```

The password was given by Dr. Webb.   

I added the files ~/.vimrc and ~/pythonrc and added the line *export PYTHONSTARTUP* to ~/.bashrc

### The GitHub Repository

I created a private git repository called *muse2016*. 

### Data Download from ESO

I downloaded the observation of the Cluster **NGC 6397**. The observation day was *2014-08-02*. The data can be download from the website [ESO Archive](archive.eso.org/eso/eso_archive_main.html) after creating an account. My username is *mmarcano22*


### Astropy:

The server does have ipython and the module Astropy installed for python2, but not for python3.  Useful commands:

```python
from astropy.io import fits`
```

### To read the header from a fit:
hdulist = fits.open("name-of-file")
hduheado = hdulist[0].header


## To-Dos
- [x] ~~Download data to start processing.~~ Downloaded data taken on 2014-08-02 for NGC 6397.


# Feb-03-2016 IRAP Roche J042

## Commits

### Questions and Problems:

- [x] ~~How to get the type information from header. Can fit it on the header. How many BIAS are needed?~~ All in *HIERARCH ESO ---*. 

- [x] MUSE cal bias and cal bias linearity?. Only cal_bias in the same day. Can use cal_bias simply

- [x] ~~Problem merging Bias works with max of 10 and min of 3.. When 11 doesn't work.~~ Wrong command to use it in parallel was missing the `taskset` described in Appendix C.

- [x] ~~No Darks that same day. 200 in total for MUSE. Which one to use?. Also different ExpTime for the darks from 1200 to 3600. Object is 60. In the Manual it says that the dark current is small so the dark is optional.~~  No darks for now.

- [x] ~~Many flats that day but only 3 with to that target RA and DEC. Only those 3?.~~ Downloaded all Flats of the night. 

- [x] ~~Got problem *"unable to find recipe muse_bias"*.~~. I created a new config file and included where all the libs where the path is: `/opt/reflex/install/lib/esopipes-plugins/muse-1.0.1`
- [x] ~~Use muse_bias.rc?~~ Not for now. 

- [x] ~~Appendix D Calibrations for Commissioning and Science Verification Data. Use those Geometry and Astrometric table and Solution?~~ Found them online.


- [x] ~~BADPIX_TABLE in flat? It is optional and says: "The use if a bad pixel table may actually degrade the tracing solution if it contains bad columns. ~~ Used the one in cal folder.

- [x] ~~Where to find DPR TYPE WAVE for the wavelength calibration. They should be in MUSE calibration template~. Will download it from online catalog.  

### Python

Created a little script that writes the full path and frame tag of files. *seetype.py*.

### Bash

The file createbias creates the sof for the recipe muse_bias and then uses EsoRex to get the master bias. 

The same for the flats.

### EsoRex

YOu can run esorex with a configuration file. with the flag `--config=`
In the file be sure to put the output directory, logfile dir.
If using EsoRex can use the .fz. In page 25 of Manual. 

Can work with up to 24 threads. Computer has 28. Found out that with `nproc`. So used `OMP_NUM_THREADS=24` before the esorex commands. Also need to use taskset. 

### BIAS

~~It works with the first 10 BIAS or the last 10. The moment I go from 10 to 11 it doesn't produced the final MASTER_BIAS.fits.~~. I needed to use to use `taskset` with for example `-c 0-5` with `--nifu=-1` and process them in parallel. 



## To-Dos
- [x] ~~Bias download data.~~ Downloaded 22 Bias from the day 2014-08-01
- [x] ~~Do master BIAS file~~
- [x] ~~Find out what darks to use.~~ Dont need the darks. Really low Current.
- [x] ~~Find out what Flats to use.~~ All the LAMP Flats of that night. 
- [x] ~~Do MASTER Flat.~~ **Did it with only three flats.**


# Feb-04-2016 IRAP Roche J042

## Commits

### Flats

I downloaded all the flats produced the night 2014-08-01. All FLAT,LAMPS.

### Static Calibration

The Static Calibration data seems to be in `/opt/reflex/install/calib/muse-1.0.1/cal` but for this particular first data set since it was taken before December 2014 I need to use the ones mentioned in Appendix D. Downloaded it from (ftp://ftp.eso.org/pub/dfs/pipelines/muse/muse-calib-legacy-2015-10-06.tar.gz).


### flatsatur.py

This program takes the average around 10 pixesl for each pixel. If in any is higher than 55000 then don't use that flat. All the flats passed the test.

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
- [x] ~~Find static calibration data.~~  Used the ones mentioned in Appendix D. See commit above.

# Feb-05-2016 IRAP Roche J042



### Multiprocessing

### Memory Overload RAM

There is a problem with the 60 flats and ARC that I have. I only have 30 GB of ram so need to run them in part then combine them to get the final one. Can do it with option

`output-prefix`

### task set

found in (https://www.eso.org/sci/activities/santiago/projects/sc-computing.html) should run it like:

`taskset -c 0-23 esorex ...`


### Data

The data is now in the path: `/mnt/data/MUSE` 



## To-Dos
- [x] Download all the arc-lamp and SKYFLATS 

# Feb-10-2016 IRAP Roche J042

## Commits

### Wavelength calibration

I wasn't able to get it done. The problem might have been two things, either that I didn't have an ARC for each lamp or that I was using two different instrument modes.

### Instruments Mode and OBS Name

In the data I downloaded for the day I had two different instrument mode as can be seen in the header. I had WFM-NOAA-E and WFM-NOAA-N. It stands for  Wide Field Mode with no AO (NOAO) correction in Nominal or Extended. The object is in WFM-NOAA-N. Only keep calibration files with this mode.


### FLATS

I have two types of flats according to the OBS NAME tag in the header "Calibration" and "muocal_nightcalib". I have 22 of one and 5 of the second. The "muocal_nightcalib" are the so called **ILLUM** in the manual and are the optional input flat for the muse_twilight recipe. According to Hayley use the one closes in temp and time to the SKYFLAT use for the twilight recipe.  

### More on FLATS and BIAS from Hayley

 Pay attention to time stamp. ESO takes 11 at a time. Use those eleven for the master bias and also for the flats. Also look at the temperature difference is no more than 0.5 C for the skyflat and the optional ILLUM to use. 

### ILLUM for recipe muse twilight. 

See FLATS commit above. 

### ARC (WAVE)

They seem to be taken in groups of 15. So three exposures per lamp. I have one with 14 probably because it was taken at 11:59 so the next one is at a later day. 

### vim

I installed vim in the home directory. It is in the folder vimlocal. The .vimrc is also in the home directory. But still haven't been able to get vim with xterm_clipboard support. 

### BASH

The .bashrc now have a line to include the path of the vim executable and to use xterm to be able to display colors. Also included the pythonstartup as was mentioned before.  

## Questions
- [x] ~~Do MASTER Flat with all flats of the night and BADPIXEL Table.~~ ~~but only with the "muocal_nightcalib" 5~. Wrong redo this. 
- [x] ~~Do the wavelength calibration~~ It worked with three Arc one for each lamp.
- [x] ~~Python and see max value of flats to see if oversaturated.~~ All of them passed the tested. Weird?
- [x] ~~Do MASTER Flat with all flats of the night~~ Still don't know if need all. 

# Feb-11-2016 IRAP Roche J042

## Commits

## Questions

- [ ] How taskset and OMP_NUM_THREAD work. Different numbers?
- [x] ~~How many flats to use?~~ Use a set of 11. The closest to your object. TO process the 11 can't do it in parallel have to do it serially. 


## To-Dos
- [x] ~~BIAS with a set of 11.~~Make sure is 11 in SCI mode read out. 
- [x] ~~Flat with a set of 11~~
- [x] Wavelengt_calibration with a set of 15. 
- [x] muse_twilight with one ILLUM. 
- [x] ~~Automate MASTER_BIAS and FLATS. The problem is that it consumes too much memory.~~ DO it in series not parallel. Longer but can fit in memory. 
- [x] ~~See how many arc can use due to memory limitation for the line spread function.~~ They appear to be taken in set of 15. 5 for each lamp. See how many can process. Can process all 15.  

# Feb-12-2016 IRAP Roche J042

## Commits

### Read-out Modes

There are two read-out modes. SC1.0 and FAST. FAST is only used in engineering mode and it is used for fast processing with 1x4 binning. That is why the set of flats and BIAS is a set of 22. 11 in FAST and 11 in SCI1, at least this dataset for August. Also object had some FAST mode. 

### MUSE NGC 6397 Article

There are two articles from the people that took the data of the cluster using MUSE and the VLT. The first one *MUSE crowded field 3D spectroscopy of over 12 000 stars in the globular cluster NGC 6397*. First author Tim-Oliver HUsser (http://arxiv.org/abs/1602.01649). For the second the first author is Sebastian Kamann (http://arxiv.org/abs/1602.01643).


### Python 

To write the header to a file can do:

```python
f = open('file.txt', 'w')
f.write(repr(tempfit[0].header[0:810]))
f.close
```
To append to the file change the 'w' for a 'a'. 



### SKY

Are (almost) empty sky fields. We could find for our dataset Maybe not needed in the Sky Creation section the manual reads: "It is only needed if the observed object fills the field-of-view to such an extent that a reasonable sky spectrum cannot obtained directly on the observation itself." Maybe that is why they didn't do it. 


### Twilight

I could the whole 7 SKYFLATs I downloaded because of lack of memory. I could only process 5 with the muse_twilight recipe. There is no way to process them in series like the other recipes with the option --nifu=0.


### STD and Astrometry.


Which one to use? I downloaded a few from around those days. The closes std is at RA: 290 DEC -45. THe obhect is at RA: 265 DEC: -22. For astrometry colest is RA: 283 DEC: -22 .




## Questions
- [ ] The flat with OBS name "muocal_nightcalib" and not "Calibration" is a ILLUM even if it doesn't say ILLUM in DPR TYPE?
- [ ] Could do twilight in series. No option nifu=0 so due to lack of memory only could do 5 not with the 7 available. Any way to do it ?
- [ ] Why doesn't work to include TWILIGHT_CUBE as input in the sof for muse_scibasic for objects. 
- [ ] What Astrometry to use? Use the calibration files?. Downloaded close to that day.  
- [ ] What STD to use? Use the ones given in the calibration files? Downloaded close to that day.  

## To-Do
- [ ] Make a CUBE from the object using the astrometry_wcs solution and std given in the calibration file. 
- [ ] Make a CUBE from the object creating the astrometry_wcs solution and std from the downloaded std and astrometry data for around those days. 





