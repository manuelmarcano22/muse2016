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



