#' Plotting function to output PNG or an R object of the spectrum.
#'
#' Can be wrapped in the data loading function, or directly with a
#' flowFrame or inside fsApply() for a flowSet.
#' This function tidies the fcs data from a flowFrame or flowSet.
#' Choose a theme: 'viridis', 'bigfoot', or 'aurora'.  Viridis is
#' colourblind accessible.
#' Choose to save to the working directory or display in current session.
#' Choose the number of bins (granularity) of the data.
#' You can normalize to the max median signal for "clean" files.
#' If you misspell an option it will give an error.
#'
#' @param flowfile A flowSet or flowFrame.
#' @param theme Choose a theme: 'viridis', 'bigfoot', or 'aurora'.
#' @param save FALSE: in console. TRUE : as png file in working directory.
#' @param bins Choose the granularity of the data.  Between 200 and 1000 works well for most data.
#' @param normalize Normalize the data to the max median signal (only for clean signals).  TRUE or FALSE
#' @param params Specify parameters (in order) to plot. Parameters will be selected based on the cytometer model.
#' @param guessPop Try to select only the positive spectral signal (200 events).  It is recommend to set normalize to TRUE when using guessPop.
#' @return Images of full spectrum
#' @author Christopher Hall, Babraham Institute
#' @seealso \code{\link[flowSpectrum]{spectralplot}}
#' @export

spectralplottingtool<-function(flowfile, theme, save, bins, normalize, params, guessPop, unstained){
  if(guessPop==TRUE & is.null(unstained)){
    print("you must specify an unstained control (flowFrame) for guessPop to work")
    stop("you must specify an unstained control (flowFrame) for guessPop to work")
    }
  data<-as.data.frame(exprs(flowfile))
  if (!is.null(params)){
    data2<-data[, params]
  } else if (flowfile@description$`$CYT`=="Aurora"){
    data2<-data[,-grep("SC|Time", names(data))]
  } else if (flowfile@description$`$CYT`=="Bigfoot"){
    data2<-data[,-grep("SC", names(data))]
    data2<-data2[,grep("-A", names(data2))]
    flowfile_colnames<-grep(pattern = "-A", unique(markernames(flowfile)), value=TRUE)
    colnames(data2)<-grep(pattern = "Spectral ", flowfile_colnames, invert = TRUE, value=TRUE)
    data2<-data2[,order(names(data2))]
  } else if (flowfile@description$`$CYT`=="ID7000"){
    data2<-data[,-grep("SC", names(data))]
    data2<-data2[,grep("-A", names(data2))]
  } else{
      print("This FCS file is not from an Aurora, Bigfoot, or ID7000.  I will try and guess the relevant parameters...or I might just fail. Consider setting the params argument")
      data2<-data[,-grep("SC|SS|FS|Ratio", names(data))]  
      data2<-data2[, grep("-A", names(data2))]
      
  }
  if(guessPop==TRUE & !is.null(unstained)){
    control_df<-exprs(unstained)
    control_df<-as.data.frame(control_df)
    control_df<-control_df[,-grep("SC", names(control_df))]
    control_df<-control_df[,grep("-A", names(control_df))]
    control_df<-control_df[!apply(control_df, 1, function(x) {any(x > as.numeric(keyword(flowfile)$`$P6R`))}),]
    todelete<-(apply(control_df, 2, median))
    sample_df<-data2[!apply(data2, 1, function(x) {any(x > as.numeric(keyword(flowfile)$`$P6R`))}),]
    sample_df<-sweep(sample_df, 2, todelete, "-")
    means<-apply(sample_df, 2, mean)
    tosort<-sort(means,decreasing = TRUE)[1]
    sample_pos<- sample_df[order(sample_df[,names(tosort)],decreasing = TRUE),]
    data2 <- sample_pos[1:200,]
  }
  dat_long2 <- tidyr::pivot_longer(data2, cols =1:length(colnames(data2)))
  if (normalize==FALSE){
    if (theme=='viridis'){
      p<-ggplot(dat_long2, aes(factor(name, level = as.list(unique(dat_long2['name']))$name), value) ) +
        scale_y_continuous(trans='log',breaks=scales::breaks_log(7),limits = c(1,as.numeric(gsub("\\D", "", flowfile@description$`$P2R`)))) +
        geom_bin2d(bins = bins) +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
              panel.grid.minor = element_blank()) +
        ggtitle(identifier(flowfile)) +
        xlab("Detector") +
        ylab("Intensity") +
        scale_fill_gradientn(colours=c(NA, "#440154FF", "#238A8DFF", "#55C667FF", "#B8DE29FF","#FDE725FF"),values=c(0,0.1,0.2,0.3,0.4,1))
    } else if (theme=='aurora') {
      p<-ggplot(dat_long2, aes(factor(name, level = as.list(unique(dat_long2['name']))$name), value) ) +
        scale_y_continuous(trans='log',breaks=scales::breaks_log(7),limits = c(1,as.numeric(gsub("\\D", "", flowfile@description$`$P2R`)))) +
        geom_bin2d(bins = bins) +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank()) +
        ggtitle(identifier(flowfile)) +
        xlab("Detector") +
        ylab("Intensity") +
        scale_fill_gradientn(colours=c("white", "blue","lightblue", "green","yellow","red"),values=c(0,0.1,0.2,0.3,0.4,1))
    } else if (theme == 'bigfoot') {
      p<-ggplot(dat_long2, aes(factor(name, level = as.list(unique(dat_long2['name']))$name), value) ) +
        scale_y_continuous(trans='log',breaks=scales::breaks_log(7),limits = c(1,as.numeric(gsub("\\D", "", flowfile@description$`$P2R`)))) +
        geom_bin2d(bins = bins) +
        theme(panel.background = element_rect(fill = "white",colour = "white",size = 0.5, linetype = "solid"),
              axis.text.x = element_text(colour = "white",angle = 90, vjust = 0.5, hjust=1),
              axis.text.y = element_text(colour = "white"),
              plot.background = element_rect(fill = "black"),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              plot.title = element_text(colour = "white"),
        ) +
        ggtitle(identifier(flowfile)) +
        xlab("Detector") +
        ylab("Intensity") +
        scale_fill_gradientn(colours=c("darkblue", "blue", "green", "yellow", "orange","red"),values=c(0,0.1,0.2,0.5,0.6,1))
    }
  } else if (normalize==TRUE){
    print("Normalize only works for clean signals. Use guessPop=TRUE or pre-gate data if necessary")
    medians<-apply(data2,2,median) #Calculate the medians and factorise the data
    df<-data.frame(medians/max(medians))
    df<-cbind(rownames(df),df)
    df$`rownames(df)`<-factor(df$`rownames(df)`, levels = df$`rownames(df)`)
    p<-ggplot(data=df, aes(x=df[,'rownames(df)'], y=df[,'medians.max.medians.'], group=1)) +
      geom_line(size=1)+
      geom_point(size=2)+
      theme_bw() +
      theme(axis.text.x = element_text(colour = "black",angle = 90, vjust = 0.5, hjust=1))+
      ggtitle(identifier(flowfile)) +
      xlab("Detector") +
      ylab("Normalized Intensity")
  }
  if(save==TRUE){
    ggsave(paste0(identifier(flowfile),"_",flowfile@description$`$DATE`,".png"), width = 20, height = 10)
  } else {p}
}
