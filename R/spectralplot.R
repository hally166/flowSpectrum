#' Load data, choose a style, and choose output method
#'
#' This function loads a flowFrame of flowSet and invokes the plotting function.
#' Choose a theme: 'viridis', 'bigfoot', or 'aurora'.  Viridis is
#' colourblind accessible.
#' Choose to save to the working directory or display in current session.
#' Choose the number of bins (granularity) of the data.
#' You can normalize to the max median signal for "clean" files.
#' If you misspell an option it will give an error.
#'
#' @param flowfile A flowSet or flowFrame.
#' @param theme Choose a theme: 'viridis' (default), 'bigfoot', or 'aurora'.
#' @param save FALSE: in console (default). TRUE : as png file in working directory.
#' @param bins Choose the granularity of the data. Between 200 and 1000 works well for most data.
#' @param normalize Normalize the data to the max median signal (only for clean signals).  TRUE or FALSE (default).
#' @param params Specify parameters (in order) to plot. If NULL (default), parameters will be selected based on the cytometer model.
#' @param guessPop Try to select only the positive spectral signal (200 events).  It is recommend to set normalize to TRUE when using guessPop.
#' @param unstained flowFrame of the negative data, only needed if guessPop = TRUE
#' @return Images of full spectrum
#' @author Christopher Hall, Babraham Institute
#' @seealso \code{\link[flowSpectrum]{spectralplottingtool}}
#' @examples
#' 
#' ## flowSpectrum has one demo file that can be loaded.  
#' ff <- read.FCS(system.file("extdata", "PE.fcs", package = "flowSpectrum"))
#' 
#' ## create plots using spectralplot().
#' spectralplot(ff, theme='viridis', save=FALSE, bins=512, normalize=FALSE, params=NULL)
#' 
#' ## load flowSet and run spectralPlot()
#' fs <- read.flowSet(list.files('C:/Users/Chris/testspectra', full.names = TRUE))
#' spectralPlot(fs)
#' 
#' ## If the parameters are out of order, or you want a custom order, you need to create a character vector
#' params <- grep("-W|-H|Time|SC",ff@parameters@data$name,value = TRUE, invert=TRUE)
#' 
#' ## If the spectra is "unclean"
#' spectralPlot(fs, guessPop = TRUE, normalize = TRUE)
#' 
#' @export

spectralplot<-function(flowfile, theme='viridis', save=FALSE, bins=512, normalize=FALSE, params=NULL, guessPop=FALSE, unstained=NULL){
  if((class(flowfile)[1]=="flowSet")==TRUE){
    fsApply(flowfile,function(x)spectralplottingtool(x,theme,save,bins,normalize,params,guessPop,unstained))
  } else if ((class(flowfile)[1]=="ncdfFlowSet")==TRUE){
    fsApply(flowfile,function(x)spectralplottingtool(x,theme,save,bins,normalize,params,guessPop,unstained))
  } else {
    spectralplottingtool(flowfile,theme,save,bins,normalize,params,guessPop,unstained)
  }
}
