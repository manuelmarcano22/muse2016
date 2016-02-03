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
- [x] ~~Download data to start processing.~~
Downloaded data taken on 2014-08-02 for NGC 6397.


# Feb-02-2016 IRAP Roche J042

## Summary


## Commits

### Questions and Problems:

- [x] ~~How to get the type information from header. Can fit it on the header. How many BIAS are needed?~~ All in *HIERARCH ESO ---*. For example.

- [ ] MUSE cal bias and cal bias linearity?. Only cal_bias in the same day.

- [x] ~~Problem merging Bias works with max of 10 and min of 3.. When 11 doesnt work.~~ Wrong command to use it in parrallell was missing the `taskset` described in Appendix C.

- [ ] They say "Since thre is only a single detector configuration available for MUSE, there is no real need to verify that the detector parameters of the raw data frames and calibartions mathc. 

- [ ] No Darks that same day. 200 in total for MUSE. Which one to use?. Also different ExpTime for the dakrs frm 1200 to 3600. Object is 60. In the Manueal ut says that the dark current is small so the dark is optional. 

- [ ] Many flats that day but only 3 with to that target RA and DEC. Only those 3?

- [x] ~~Got problem *"unable to find recipe muse_bias"*.~~. I created a new config file and included where all the libs where the path is: `/opt/reflex/install/lib/esopipes-plugins/muse-1.0.1`

- [ ] Use muse_bias.rc?

- [ ] Appendix D Callibations for Commisioning and Science Verification Data. Use those Geometry and Astrometric table and Solution?

- [ ] How taskset and OMP_NUM_THREAD work. Different numbers?

- [ ] BADPIX_TABLE in flat? It is optional and says: "The use if a bad pixel table may actually degrade the tracing solution if it contains bad colums. 

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
- [ ] Find out what darks to use
- [ ] Find out what Flats to use
- [x] Do MASTER Flat. **Did it with only three flats.**
- [ ] How many threads can use with taskset and OMP_NUM_THREAD?
