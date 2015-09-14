# Dependencies
library(readr)
library(xts)
library(reshape2)
library(RColorBrewer)
library(ggplot2)
library(toOrdinal)
library(lubridate)
library(magrittr)

#Utility functions for handling particularly common tasks
download_set <- function(location){
  location <- paste0("http://datasets.wikimedia.org/aggregate-datasets/maps/", location,
                     "?ts=", gsub(x = Sys.time(), pattern = "(-| )", replacement = ""))
  con <- url(location)
  return(readr::read_delim(con, delim = "\t"))
}

#Create a dygraph using our standard format.
make_dygraph <- function(data, x, y, title, is_single = FALSE, legend_name = NULL, use_si = TRUE){
  
  if(is_single || length(unique(data[,2])) == 1){
    data <- xts(data[,3], data[[1]])
    if(is.null(legend_name)){
      names(data) <- "events"
    } else {
      names(data) <- legend_name
    }

  } else if(ncol(data) < 3){
    name <- names(data)[2]
    data <- xts(data[,-1], order.by = data[[1]])
    names(data) <- name
  } else {
    data <- xts(data[,-1], order.by = data[[1]])
  }
  return(dygraph(data, main = title, xlab = x, ylab = y) %>%
           dyLegend(width = 400, show = "always") %>%
           dyOptions(strokeWidth = 3,
                     colors = brewer.pal(max(3,ncol(data)), "Set2"),
                     drawPoints = FALSE, pointSize = 3, labelsKMB = use_si,
                     includeZero = TRUE) %>%
           dyCSS(css = "./assets/css/custom.css"))
}


