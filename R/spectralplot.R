#' Load data, choose a style, and choose output method
#'
#' This function loads a flowFrame of flowSet and invokes the plotting function.
#' Choose a theme: 'viridis', 'bigfoot', or 'aurora'.  Viridis is
#' colourblind accessible.
#' Choose to save to the working directory or display in current session.
#' Choose the number of bins (granularity) of the data.
#' If you misspell an option it will give an error.
#'
#' @param flowfile A flowSet or flowFrame
#' @param theme Choose a theme: 'viridis' (default), 'bigfoot', or 'aurora'
#' @param save FALSE: in console (default). TRUE : as png file in working directory
#' @param bins Choose the granularity of the data.
#' @param normalize Normalize the data to the max median signal (only for clean signals).  TRUE or FALSE (default)
#' @param params Default NULL. Specify parameters (in order) to plot. Only used if data are not from an Aurora, ID7000, or BigFoot instrument.
#' @return Images of full spectrum
#' @export

spectralplot<-function(flowfile, theme='viridis', save=FALSE, bins=512, normalize=FALSE, params=NULL){
  if((class(flowfile)[1]=="flowSet")==TRUE){
    fsApply(flowfile,function(x)spectralplottingtool(x,theme,save,bins,normalize))
  } else{
    spectralplottingtool(flowfile,theme,save,bins,normalize)
  }
}
