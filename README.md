# flowSpectrum
An R package to produce full spectrum flow cytometry plots outside the acquisition software.

**Author: Christopher Hall, Babraham Institute, UK**

Contact: christopher.hall@babraham.ac.uk

[Babraham Institute Flow Cytometry Facility](https://www.babraham.ac.uk/science-services/flow-cytometry)

## Purpose
The purpose of this package is to produce full spectrum flow cytometry plots outside the acquisition software.
There are three styles designed to roughly mimic the output styles of the Bigfoot, Aurora, and R Viridis.
The package takes flowFrames and flowSets as produced using the flowCore package.

## Useage
Load data info R using flowCore either via read.FCS() or read.flowset()
Envoke the spectralplot() function and choose a style and choose where to output the resulting image.

```{r setup, out.width="100%"}
library(flowSpectrum)
ff<-read.FCS(system.file("extdata", "PE.fcs", package = "flowSpectrum"))
spectralplot(ff,theme='viridis',save='no')
```
![PE spectrum](/man/PE.fcs_11-JUN-2021.png)


The theme options are 'viridis', 'bigfoot', and 'aurora'.
The save options are TRUE and FALSE.  TRUE will save a PNG into the working directory. FALSE will output to the R session.

Defaults are theme='viridis', save='no'
