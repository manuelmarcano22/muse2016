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

I created a private git repository called *muse2016* (https://github.com/manuelmarcano22/muse2016). 

### Data Download from ESO

I downloaded the observation of the Cluster **NGC 6397**. The observation day was *2014-08-02*. The data can be download from the website [ESO Archive](archive.eso.org/eso/eso_archive_main.html) after creating an account. My username is *mmarcano22*


### My IRAP account

My username is `mpichardo` and webmail is `mpichardo@irap.omp.eu`

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

- [x] ~~MUSE cal bias and cal bias linearity?.~~ Only cal_bias in the same day. Can use cal_bias simply

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


Which one to use? I downloaded a few from around those days. The closes std is at RA: 290 DEC -45. The object is at RA: 265 DEC: -22. For astrometry closest is RA: 283 DEC: -22 .

#### Questions
- [x] ~~What Astrometry to use? Use the calibration files?. Downloaded close to that day.~~ Hayley on Feb-25-16 suggested not to do Astrometry. Use the one from the calibration file but do the STD.  
- [x] ~~What STD to use? Use the ones given in the calibration files? Downloaded close to that day.~~ There should always be at least one that day. Use it. When possible avoid having to use the one from the calibration file. Advice given by Dr. Hayley Finley on Feb-25-16.   


## To-Do
- [x] ~~Download all STD and ASTROMETRY for near the date.~~ 17 Astrometry and 39 STD. 

# Feb-15-2016 Paul Sabatier

## Journee Scientific

### MUSE carfantan Galpack3D

# Feb-16-2016 Paul Sabatier

## Journee Scientific

### Relevant talk for MUSE

MUSE Carfantan and Nicholas Bouche talikng about Galpack3D 


# Feb-17-2016 IRAP Roche J042

## Commits

### Results of muse_scibasic


Apparently I have 19 exposures. Produced also 19 OBJECT_RED. Each with Data, DQ and STAT. Data, Data quality and statistics. Need to search for the middle one. 

#### Questions
- [x] ~~Take a look at Object Reds. Good or Bad?~~ I guess bad.~~ Have the same ugly feature that the final CUBE obtained.~~ It was ds9 displaying it. Works with QFitsViewer


### Creating the DataCube

I tried to created it but got a really bad ones with a lot of empty black spaces with 'nan'. It might be due to the bad_pixel table. It will try to do it again without the bad pixel table from the calibration files. This was done only for the first exposure "0001".  

In the article they say:

> To combine the pixtables from the individual exposures of each pointing into a single datacube, we had to account for the small offsets that occur during position angle changes, because the rotation centre is not perfectly aligned with the optical axis of the instrument (“derotator wobble”). We did so by creating a broadband image from each pixtable, measuring the coordinates of the brighter stars in the field of view, and feeding the measured average offsets to the pipeline when creating the final datacube for each pointing

#### Questions
- [x] ~~What does this mean?~~ Look at the Header "HIERARCH ESO INS DROT POSANG". It changes from exposure to exposure. It seems to "wobble". [Derotator](https://www.eso.org/sci/facilities/paranal/instruments/muse/inst.html). The derotator compensates for the field rotation happening at the VLT Nasmyth focus. It is a classical derotator based on two prisms: when rotated by an angle α, the image plane rotates by the angle 2α.
- [x] ~~Can see that in OBJECT_RED or where?~~  Can see it in IMAGEFOV for sure. 



## To-Do
- [x] ~~Make a CUBE from the object using the astrometry_wcs solution and std given in the calibration file.~~ ~~Very bad quality one.~~ It was ds9. Display with QFits Viewer. 
- [x] ~~Downloaded the data for another day.~~ This time 2014-July-27


# Feb-18-2016 IRAP Roche J042

## Commits

### QFitsView

I wasn't able to display the datacube in ds9. In QFitsView  the problem was how I was loading the fits. You have to make sure to click the checkbox "All extensions" when opening a datacube. This translate to the command `readfitsall` in **DPUSER**. Also check the scale, how much % is showing. 

### "white light" image. 

This can be done in QFitsView by clicking on *Options*, then *Cube Display* then instead of Single select *Average*.


### New Data ILLUM

The new data does not include an ILLUM Flat. Apperently. Is this normal? Maybe because the temperature didnt change much that day. *It is a proceddure of ESO at VLT according to De. Finley so there should be one and I should use it.* Just pay attention on which one to use for the scibasic STD and scibasic OBJECT. 

### Header information

To see with what routine and with what files a certain fits file  was created using an ESORex recipe look in the header the information with Python with the tag:  `fitsfile[0].header['*PRO REC*']`


### Literature Review

 Dr. Webb mentioned a study about the two population of CV for the particular cluster. Also look for the Hubble optical study after the Chandra paper done. Also search information for the distinction between CV and double degenerated. This can't be distinguished in X-Rays. 

## Other Questions
- [x] ~~Why doesn't work to include TWILIGHT_CUBE as input in the sof for muse_scibasic for objects.~~ Apparently it did work. I checked looking the header of a PIXOBJECT ['*PRO REC*'] and it has the TWILIGHT CUBE as input.  


# Feb-18-2016 IRAP Roche J042

## Commits

### DATA_CUBE

Using a standard STD nearby (only one exposure) and all the optional input like "badpixel tables", but without any darks or ILLUM. 


#### Questions
- [x]  ~~Process without ILLUM?~~ I dont have any for that night apparently. 


# Feb-22-2016 IRAP Roche J042

## Commits

### Literature Review


## To-Do
- [x] ~~Install [ZAP](http://zap.readthedocs.org/en/latest/).~~ Did it with pip install --user zap 
- [x] ~~Make a CUBE from the object creating the astrometry_wcs solution and std from the downloaded std and astrometry data for around those days.~~ Created one with astrometry from lacibration file, but STD from observation taken around that day for the data set of July 27 2014.  
- [x] ~~Papers about Population CV, Optical observation of cluster and double degeneated in optical.~~ See Lit Review sections. 
- [x] ~~Create Mendeley Account~~ Created a Zotero account. Zotero is open-source and Mendeley is propietary and owned by Elsevier (:thumbsdown:). 

# Feb-24-2016 IRAP Roche J042

## Commits

### Limited Wavelength DATACUBES

I created a IMAGEFOV, Datacube, PIXTABLE_REDUCED and PIXTABLE_COMBINED for all the 45 different exposures. Now to do is to try to see how to combine them. I will meet with Dr. Finley to learn how to do this. 

### MUSE Pipeline Version 1.2.1

 Until this point I am currently using version 1.0.1 of the muse software pipeline. There is version 1.2.1 that was released. This included a new recipe for easy aligment.


## To-Do
- [x] ~~All the Datacubes and extra fits for the 45 exposures.~~ Did it with reduced wavelenght from 4000 to 5000 to reduce computing time and try to get the offsets.



# Feb-25-2016 IRAP Roche J042

## Commits

### Combining the data from 2014-07-27

The data from the first night of observation (2014-07-27) consist of 5 60 seconds exposures of 9 different central regions (except for the very central one. Only 4 exposures and an extra one of the NE region). This gives a total of 45 different exposures. 

The distribution goes like this:

- Central region exposures 1-4 (only 4 of this region)
- North of Central Region 20-24
- Sourh  of Central Region 15-19
- East of Central Region 10-14
- West of Central Region 5-9
- NE of Central Region 40-45  (notice there are 6 of this region) 
- NW of Central Region 30-34
- SE of Central Region 35-39
- SW of Central REgion 25-29

To combine them Dr. Webb suggested, as a first try, to manually find the offsets (using ds9, for example) for a given group of 5. Then the combination can be done by setting the environment variables `MUSE_XCOMBINE_RA_OFFSETS` and `MUSE_XCOMBINE_DEC_OFFSETS` and using the recipe *muse_scipost* and the PIXTABLE_OBJECT or combining the *PIXTABLE_REDUCED* with the *muse_exp_combine* recipe. This is described in section 6.6 of the MUSE Pipeline User Manual Issue 9 Date 2015-04-28. 

From the manual about the offsets:

>The coordinate offsets are given by setting the environment variables MUSE_XCOMBINE_RA_OFFSETS
>and MUSE_XCOMBINE_DEC_OFFSETS. Each of these variables has to contain as many floating-point
>numbers, separated by commas, as exposures to combine are involved.
>Each number is the direct difference of the measured position to the reference position (no cosδ!), the
>values are interpreted in units of degrees:
>RA_OFFSET = RAmeasured − RAreference
>DEC_OFFSET = DECmeasured − DECreference
>It is important that the offsets are given in the order of increasing DATE-OBS of the exposures involved.
>If one of the exposures has been chosen as the reference the offsets of 0 for this exposure have to be
>explicitly given when setting the environment variables


### Second night of observation (2014-07-28)

On the second night of observation (2014-07-28) they also observed the central region of the cluster (from the header "HIERARCH ESO OBS NAME = 'NGC6397-center-cross_obs2' / OB name"). There are 21 different Objects, and also no STD or ILLUM. 


### MUSE Pipeline Version 1.2.1

There is a new version of the Pipeline. This new version is will be installed locally in `detoeuf/musepipeline1.2.1`. The problem installing it was having to upgrade to a version of 6.6.1 for the [CPL](https://www.eso.org/sci/software/cpl/). The things to remember are the following:

- configure cpl with the flags `--with-wcs` and `with-fftw`. For this computer there were in `/usr/local` not in `/usr/include`. Only normal precision and not single. 

- CPL was installed in `/usr/local/lib`. This is were the configure of muse-1.2.1 was looking first. We couldn't configure the installation without installing the new version there, I don't know why it was so picky. 

- Need to rebuild [EsoRex](http://www.eso.org/sci/software/cpl/esorex.html) after installing CPL. This is still a problem. For now I am using the one installed at *$HOME/musepipeline1.2.1*

### Meeting with Hayley Finley OMP B144

Things to remember from the meeting:

- Use STD of the night when possible. There should be one every night and I should favor the use of it instead of the calibration one. This is not true for the SKY and Astrometry. At least for this data set were is a globular cluster. 

- Use the ILLUM closest in temperature and time for the scipost OBJECT and scipost STD. There should be several per night taking as a protocol for the instrument. Maybe not necessary in the science verification run. For example the tag for the ILLUM is FLAT,LAMP but should be different according to the Manual (VLT-MAN-ESO-14670-6186). 

- Based on her previous experience reducing the data the use of the optional fits from the calibration file "vignetting_mask" is very important. It is noticeable specially in the borders. 

- Include filter list from the calibration.

### How to do the combination:

First, use the *align* recipe with all the images "IMAGE_FOV" from the same region you want to combine together. You can work with just the white one if that was one of the filters that was used as input for the recipe. The recipe *align* will produced a fits table called "OFFSET_LIST". Then there are two ways to combine the data. One way is using the PIXTABLE_REDUCED produced by scipost and then with the recipe "muse_exp_combine" using the produced "OFFSET_LIST". This approach is explain in more detail in section 7.3.3 "Working with Data Cubes" of the MUSE Pipeline Manual version 1.2.1 (ftp://ftp.eso.org/pub/dfs/pipelines/muse/muse-pipeline-manual-1.2.1.pdf)". The basic idea is to create with *muse_exp_combine* different datacubes with different lambdamin and lambdamax and then merging them together using the too *muse_cube_combine*. It has to be done this way due to limited RAM memory. 

The first step after obtaining the offset list is to create with *exp_combine* an image with **all** the different exposures you want to combine and the offsetlist. This can be created by limiting the wavelength range. It is necessary to choose a small enough range using the options --lambdamax and --lambdamin to be able to process in memory all of them. The recipe will produce a DATACUBE and IMAGE_FOV. The datacube won't be used for anything but the IMAGE_FOV created will be use as the "OUTPUT_WCS" input frame in subsequent calls to the recipe *exp_combine* to create all the datacubes in different wavelength that later will be combined. This is a recommendation from Dr. Hayley Finley to avoid getting a weird distorted incomplete final merged datacube. 

With our "OUTPUT_WCS" the next step is to create different datacubes with different range of wavelength (for example a BLUE and a RED one). It is important to remember that **they need to overlap in at least about 2 wavelength**. This is again done with the options --lambdamin and --lambdamax for the recipe "exp_combine". The input files in the sof for each call of *exp_combine* will be:

1. All the PIXTABLE_REDUCED from the different exposures to merge.
2. The OFFSET_LIST created by the *align* recipe.
3. The filter list from the calibrations file
4. The first IMAGE_FOV that was also created with *exp_combine*. This will be our shape and will have the tag "OUTPUT_WCS". This seems a bit redundant but if this image with the tag  "OUTPUT_WCS" is not provided in the sof, the default for the function *muse_cube_combine* is to use the first file of the list as our "shape".

The function will be called to created as many datacubes as needed in different wavelength overlapping in about 2 wavelenght. Then the combination is done calling the tool *muse_cube_combine*.

```
muse_cube_combine CUBE_COMBINED.fits CUBE_blue.fits CUBE_green.fits CUBE_red.fits 
```


##  Questions
- [x] ~~4 different channels of IMAGEFOV?~~ This are the 4 different filters I specified. This change depending on the filters I chose when running the recipe. 


## To-Do
- [x] ~~Download data from the second observation of the center.~~ Downloaded all data from 2014-07-28 observation. Now have to create cleanmaster.txt 


# Feb-26-2016 IRAP Roche J042

## Commits

### Readline

I created the file `~/.inputrc` to enable vi edit mode in bash and python. To the file I added the lines:

```bash
set editing-mode vi

$if mode=vi
  set keymap vi-command
    set keymap vi-insert
```

To source the file in the current bash session use `bind -f ~/.inputrc`


### MUSE Pipeline Version 1.2.1

Maybe because I tried to run the recipe *muse_align* with data created with an older version of cpl or fftw the script cpl_fft_image was complaining. Maybe this is not the reason but hopefully. The old data is in the folder oldata and I will create new data. This will run over the weekend. I am running the EsoRex, CPL and musepipeline installed locally at `/home/detoeuf/musepipeline1.2.1/`.



###  Questions
- [x] ~~How to deal with different kind of data. STD for first night only for example. Can I combine them into one for both nights?~~ I also have STD for the second night. Can combine them after reducing both data separately. 
- [x] ~~The flat with OBS name "muocal_nightcalib" and not "Calibration" is a ILLUM even if it doesn't say ILLUM in DPR TYPE?. I dont have one for the new dataset 2014-July-27 or 2014-July-28~~ I should have one and maybe it is because the data was taking during science verification and the header wasn't standardized as it says in the current version of the Manual. This will be checked when new data arrives. 
- [x] ~~Could do twilight in series. No option nifu=0 so due to lack of memory only could do 5 not with the 7 available. Any way to do it ?~~ She haven't tried it but since the recipe creates a CUBE can create two and then add them running *muse_cube_combine*.
- [x] ~~How many exposures of STD?. Currently using the closest one. No STD for second night.~~ I do have for the second night. Use at least one. There should be at least one per night.   


# Feb-29-2016 IRAP Roche J042

## Commits

### GitHub wiki

I started to write a wiki for the GitHub repository. It can be found in (https://github.com/manuelmarcano22/muse2016/wiki).


# Mar-01-2016 IRAP Roche J042

## Commits

### Problems with scibasic "recipe"

If I run with esorex in $HOME/musepipeline1.2.1/bin/esorex it doesn't work. The process freezes and the checksum doesn't work. This is the same for both creating OBJECT and STD. It doesn't give me the same error with the one installed in /usr/local/bin. The only difference is the CPL version, 6.6 vs 6.6.1, but with both the checksums doesn't work.

I try putting the option to check the checksum to FALSE in esorexrc to see if this was the problem. It works like that. I will try creating the objects with `esorex.caller.no-checksum=TRUE` 


### New recipe dir

I change the local installation of the muse pipeline to `/home/detoeuf/muse1.2.1` and now it includes the version 6.6.1 of CPL and not the 6.6. This was to try to fix the problem when executing the recipe *muse_scibasic* for objects and standards, but it didn't work. 



# Mar-02-2016-to-Mar-04-2016 IRAP Roche J042

## Commits



##  Questions
- [x] ~~Can run without checksum?~~ Will do this. At least for scibasic and scipost


## To-Do
- [x]  ~~Update params of other days with correct recipe directory and maybe that it doesnt do the checksum.~~ Still dont know why didnt work the checksum after changed to new CPL. 
- [x] ~~Re-run everything with new recipe version.~~ For first and second night. 
- [x] ~~Create cleanmastersof with new data from second day of observation.~~ And ran all the recipes. 
- [x] ~~Get all the offsets to combine the datasets.~~ 
- [x] ~~Figure out how to use [ZAP][@zap].~~ Easy way in the command line `python -m zap INPUT_CUBE.fits`


### MUSE_exp_Combine and MUSE_cube_combine

The problem was that the IMAGEFOV that I was using as OUTOUT_WCS didn't have the right information about the third axis (wavelenght). I had to modify the header of the image including the following information about the third axis:

NAXIS   =                    3
NAXIS3  =                 3681
CTYPE3  = 'AWAV    '
CUNIT3  = 'Angstrom'
CD3_3   =                 1.25
CRPIX3  =                   1.
CRVAL3  =     4749.75341796875
CD1_3   =                   0.
CD2_3   =                   0.
CD3_1   =                   0.
CD3_2   =                   0.

To get the OUTPUT_WCS working I did the following process:

1. Open a Datacube with all the wavelength and save as image in QFitView. 
2. Then modify the header of the previously exported image to add or modify the keywords mentioned above. I did with some trouble in vim. There must be a better way. 

This process is to be able to get the resulting wavelength limited DATACUBE from the recipe muse_exp_combine with the full wavelength range. It will have NaN for the wavelengths that are outside the specified wavelength range in the muse_exp_combine.rc. After the three datacubes (red,green and blue) are created they can be combine with `muse_cube_combine`.


### RAM Memory

The server now has more ram memory. I think 64 GB, so now I can run the recipes in parallel with the options in some of the recipes `nifu=-1`.


## To-Do
- [x] ~~Combine the four exposures of the center of the cluster taken the first night.~~ 


### White Dwarfs

Look for info on White Dwarfs population and type of CVs. Most should be magnetic.  


# Mar-07-2016 IRAP Roche J042

## Commits

### Heliu-Core White Dwarfs

NGC 6397 has population of so called "nonflickereres". This seem to be He WD with an massive Carbon-Oxygen WD. These are mentioned first in [Cool98][@Cool98NF], a spectra of one is studied in [Edmond98][@Edmonds98], three more are mention in [Taylor01][@taylor01]. And a comprehensive list of He WD can be found in [Strickler][@strickler09]. These can be interesting to studied since they can be sources for the LISA mission according to [Benacquista13][@benacquista13].


### nonflickerers (NF)

Using the coordinates of the first NF mentioned by [Cool98][@Cool98NF], and finding the coordinates in the paper [Strickler][@strickler09] I extracted the spectra. It is in the data folder. 

### Hubble image

To be able to find the correct source I looked in a Hubble image. There I can locate the star with the astrometry and then try to locate it in my datacube. The fits file image is called *hlsp_acsggct_hst_acs-wfc_ngc6397_f606w_v2_img.fits* and it is located in the data folder. 



# Mar-08-2016 IRAP Roche J042

## Commits

### Terrible Mistake

Doing the combine datacube for the second night I discovered that the Offset list was only done for two exposures. The spectra for day 2 looks much better. 

### Second day observation

I finally was done reducing the observation for the second day. The next step is to combine them with the first day. 


### IRAF

IRAF is installed in the server and I can access it like:

```bash
marcano@edelweiss.cesr.fr
```
and then do: `.xiraf_redhat`

## To-Do
- [x] ~~Get combined DataCube for second day.~~ 
- [x] ~~Install IRAF and Pyraf with Ureka from the STScI.~~ No need now. Can use the one in the server. See details above.  



# Mar-09-2016 IRAP Roche J042

## Commits

### ZAP and sky-lines

In my field I don't have much sky. This is the reason maybe they didn't take any SKY frames. When I compared my spectra after processing it with ZAP, it takes a lot of signal. Compare the fits of the U23 and some He lines are missing. Take spectra with both doing in the DPUSER command line in QFitsView

```bash
DPUSER> buffer1 = readfitsextension("pathtocube.fits",1)
DPUSER> buffer2 = 3dspec(buffer1,206,137, /sum)
DPUSER> buffer3 = 3dspec(buffer1,206,137, 4,  /sum)
```

Where the 4 is the radius if the selection is "circular".


### Combination first night

It wasn't done right so there are some sharp transition between different wavelength. So I have to redo changing the wavelength ranges. This doesn't appear for the second night.  


## To-Do
- [x] ~~Rerun combined with good align for first day~~
- [x] ~~Combine first and second day~~
- [x] ~~Recombine First and Second night with good first night.~~ No need to do it again. I did this with the PIXTABLE_REDUCED which are product of the scipost routine and used to combined. I think that the combination of one night or of several night depend on the combination of the other.   



# Mar-10-2016 IRAP Roche J042

### http://manuelpm.me/muselabbook16/

I started the new Github repository (https://github.com/manuelmarcano22/muselabbook16/tree/gh-pages) for  what it should be my new labbook journal following the examples from [Jekyll-lablog](https://github.com/fdschneider/jekyll-lablog), this  [labnotebook](https://github.com/cboettig/labnotebook) and also [labnotebookmadsenlab](http://notebook.madsenlab.org/labnotebook.html).

It is using [Jekyll](https://jekyllrb.com/), build locally in my computer then pushed to the branch gh-pages to create the project [GitHub page](https://pages.github.com/).



# Mar-11-2016 IRAP Roche J042

### qLMXB

Cool stuff look into it how to extract it. 


```bash
DPUSER> 3dspec(buffer1,237, 332,1, /sum)
```

Strange line at 6404 Angstrom. And a dip at 7600 and peak at 7626. The last dip and peak is common. Check that is not earth like it seems in Fig. 2 with the spectra in the first MUSE NGC 6397 paper. 

Now found out if line is real and not only noise. Get spectra with different methods in QFitsView. 

### White Image of Whole Cluster

To try to locate sources seen by Chandra outside of the Core Radius, I have to download and process for all the observation days. This is to try to locate new X-rays source seen by Chandra outside of the Core Radius.   


## To-Do
- [x] ~~Recombine first night to get good combine cube without sharp jumps in wavelength.~~ Did with overlap 



# Mar-14-2016 IRAP Roche J042

### FLAT,SKY

For some observations night there are not SKYFLATs in the correct instrument mode (WFM-N). This is the case for 2014-07-29, 2014-07-31. So I had to do the following thing:

- Use SKYFLATS taking at 22h UT on 2014-07-27, for  2014-07-27, 2014-07-28 and 2014-07-30.
- Use SKYFLATS taking at 22h UT on 2014-08-02, for both 2014-07-31 and 2014-08-01.

All the observations are taking around 1h to 2h UT. 


### U24 (LMXB)

To try to see if the emission line seeing for U24 around 640.5 nm, I extracted the spectra around that area with QFitsView to the different datasets (First Night only, Second Night and both Nights), using different options (sum, average, median). This is done with DPUSER script to be run using QFitsView. The script is in the folder misc and with the extension`.dpuser`.



##  Questions
- [ ] Using same SKYFLATS for two different days. 
- [ ] Correct spectra? Can see the redshift?
- [ ] He and H$\alpha$ line present, normal? 

## To-Do
- [ ] Try to figure out weird line in supposed place of the qLMXB U24. 
- [ ] Download data for all days to search CVs outside Core-Radius
- [ ] Process spectra in IRAF
- [ ] Get  the spectra of the CVs.
- [ ] Get spectra of the He WD. Specially of NF2 since I have one to compared with. 
- [ ] Find information about the white dwarfs in the cluster
- [ ] Python routines to update productssof.txt and use this for routines. 
- [ ] Do a CUBE with and without using the bad pixel table.
- [ ] Make CUBE with lsf from calibration and created one. 


# References

[@musecluster1]: http://dx.doi.org/10.1002/aris.201 "Husser T-O, Kamann S, Dreizler S, Wendt M, Wulff N, Bacon R, et al. MUSE crowded field 3D spectroscopy of over 12,000 stars in the globular cluster NGC 6397 - I. The first comprehensive spectroscopic HRD of a globular cluster. ArXiv e-prints [Internet]. 2016 Feb 1 [cited 2016 Feb 23];1602:arXiv:1602.01649. Available from: http://adsabs.harvard.edu/abs/2016arXiv160201649H"

[@musecluster2]: http://adsabs.harvard.edu/abs/2016arXiv160201643K "Kamann S, Husser T-O, Brinchmann J, Emsellem E, Weilbacher PM, Wisotzki L, et al. MUSE crowded field 3D spectroscopy of over 12,000 stars in the globular cluster NGC 6397 - II. Probing the internal dynamics and the presence of a central black hole. ArXiv e-prints [Internet]. 2016 Feb 1 [cited 2016 Feb 23];1602:arXiv:1602.01643. Available from: http://adsabs.harvard.edu/abs/2016arXiv160201643K"


[@zap]: http://adsabs.harvard.edu/abs/2016arXiv160208037S "Soto KT, Lilly SJ, Bacon R, Richard J, Conseil S. ZAP -- Enhanced PCA Sky Subtraction for Integral Field Spectroscopy. ArXiv e-prints [Internet]. 2016 Feb 1 [cited 2016 Feb 29];1602:arXiv:1602.08037. Available from: http://adsabs.harvard.edu/abs/2016arXiv160208037S"

[Cool98NF]: http://stacks.iop.org/1538-4357/508/i=1/a=L75 "Cool AM, Grindlay JE, Cohn HN, Lugger PM, Bailyn CD. Cataclysmic Variables and a New Class of Faint Ultraviolet Stars in the Globular Cluster NGC 6397. ApJ [Internet]. 1998 [cited 2016 Mar 7];508(1):L75. Available from: http://stacks.iop.org/1538-4357/508/i=1/a=L75"

[@Edmonds99]: http://stacks.iop.org/0004-637X/516/i=1/a=250 "Edmonds PD, Grindlay JE, Cool A, Cohn H, Lugger P, Bailyn C. Cataclysmic Variables and a Candidate Helium White Dwarf in the Globular Cluster NGC 6397. ApJ [Internet]. 1999 [cited 2016 Feb 23];516(1):250. Available from: http://stacks.iop.org/0004-637X/516/i=1/a=250"

[@taylor01]: http://stacks.iop.org/1538-4357/553/i=2/a=L169  "Taylor JM, Grindlay JE, Edmonds PD, Cool AM. Helium White Dwarfs and BY Draconis Binaries in the Globular Cluster NGC 6397. ApJ [Internet]. 2001 [cited 2016 Mar 7];553(2):L169. Available from: http://stacks.iop.org/1538-4357/553/i=2/a=L169"

[@strickler09]: http://adsabs.harvard.edu/abs/2009ApJ...699...40S "Strickler RR, Cool AM, Anderson J, Cohn HN, Lugger PM, Serenelli AM. Helium-core White Dwarfs in the Globular Cluster NGC 6397. The Astrophysical Journal [Internet]. 2009 Jul 1 [cited 2016 Mar 7];699:40–55. Available from: http://adsabs.harvard.edu/abs/2009ApJ...699...40S"

[@benacquista13]: http://www.livingreviews.org/lrr-2013-4 "Benacquista MJ, Downing JMB. Relativistic Binaries in Globular Clusters. Living Reviews in Relativity [Internet]. 2013 [cited 2016 Mar 7];16. Available from: http://www.livingreviews.org/lrr-2013-4"

