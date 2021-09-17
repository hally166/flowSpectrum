# flowSpectrum
An R package to produce full spectrum flow cytometry plots outside the acquisition software.

**Author: Christopher Hall, Babraham Institute, UK**

[Babraham Institute Flow Cytometry Facility](https://www.babraham.ac.uk/science-services/flow-cytometry)

## Purpose
The purpose of this package is to produce full spectrum flow cytometry plots outside the acquisition software.
There are three styles designed to roughly mimic the output styles of the Bigfoot, Aurora, and R Viridis.
The package takes flowFrames and flowSets as produced using the flowCore package.
* Only works with Aurora, Bigfoot , and ID7000 FCS files.  The SP6800 uses a proprietary format that flowCore can't read. 

## Usage
###Quick start
```spectralplot(ff)```

###More information
Load data into R using flowCore either via read.FCS() or read.flowSet(),

Use the spectralplot() function, choose a style, and choose where to output the resulting image.  The default (i.e. just ```spectralplot(ff)```) will produce a viridis plot in the R session.

```{r setup, out.width="100%"}
#install from Github using devtools
devtools::install_github('hally166/flowSpectrum')

#load the package
library(flowSpectrum)

#flowSpectrum has one demo file that can be loaded.  
ff<-read.FCS(system.file("extdata", "PE.fcs", package = "flowSpectrum"))

#create plots using spectralplot(). spectralpolt() will accept a flowFrame or a flowSet
spectralplot(ff,theme='viridis',save=FALSE)
```
![PE spectrum](/man/PE.png)


The theme options are 'viridis', 'bigfoot', and 'aurora'.
The save options are TRUE and FALSE.  TRUE will save a PNG into the working directory. FALSE will output to the R session.

Defaults are: theme='viridis', save=FALSE

### ToDo - 09July21

Handling negative numbers

Autogating
