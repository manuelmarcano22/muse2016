# MUSE Data Reduction 2016

This is the repository for the created code and documents as part of a research project done in Spring 2016 at [IRAP](http://www.irap.omp.eu/en) under the supervision of [Dr. Natalie Webb](http://userpages.irap.omp.eu/~nwebb/).

####  The Reduction of the Data

The first part of the project consisted in downloading raw data from the instrument [MUSE](https://www.eso.org/sci/facilities/develop/instruments/muse.html). The raw data files can be download directly from the [ESO Archive](http://archive.eso.org/cms/eso-data.html).  

The data reduction was done using the official  [MUSE Instrument Pipeline Recipes]((https://www.eso.org/sci/software/pipelines/muse/muse-pipe-recipes.html). ) (also known as the MUSE Data Reduction Software or MUSE DRS)


This work was done using version 1.0.1. The pipeline distribution kit includes several packages. The ones used for this work are the following:

-  The [Common Pipeline Library](http://www.eso.org/sci/software/cpl/download.html) version 6.5.1
-  The [ESO Recipe Execution Tool](http://www.eso.org/sci/software/cpl/esorex.html) (EsoRex) version 3.11.1. 

All the data reduction was done calling EsoRex to exexute the MUSE DRS recipes from a bash (version 4.3.11) script.  The configuration files for each of the called MUSE recipes used, the bash scripts, useful python (Python 2.7.6) scripts and other text files can be found in the *scripts* folder. 

## In the Repo:

### *Documents*

The *Documents* folder contains several subfolders:

- The *Summaries* subfolder includes  brief personal summaries of relevant research papers. (In [Zotero](https://www.zotero.org/manuelmarcano22/items/collectionKey/ABUIC59V) )

- The *Logs* subfolder contains my personal daily [research log](Documents/Logs/WorkLog/worklog.md).  It includes (at least should)  my daily tasks, any questions (answered and unanswered), useful information and my current to-do list. This might move to another repo following the idea to have it in a webserver with jekyll. For more info (https://github.com/fdschneider/jekyll-lablog).  A cool example can be found here (https://github.com/cboettig/labnotebook). 

### *scripts*

This folder contains the scripts used to reduce the download from [MUSE](https://www.eso.org/sci/facilities/develop/instruments/muse.html). Each subfolder corresponds to a given set of data download and contains three subfolders:

-  config: contains all the configuration files for the scripts called to reduce the data.

-  executables: contains all the callable routines used to generated the final data product.

-  products:  contains several text files with the names of the data files that are produced or are used as inputs by the scripts to reduce the data. 

