#!/usr/bin/Rscript

################################################################################
### 
## 
## Created on: 2014-09-05
## Author: Kazuki Yoshida
################################################################################


### Prepare environment
################################################################################

## Configure parallelization
library(doMC)           # Parallel backend to foreach (used in plyr)
registerDoMC()          # Turn on multicore processing
options(cores = 4)
options(mc.cores = 4)

## Load packages
library(reshape2)
library(magrittr)
library(dplyr)
library(ggplot2)
library(survival)

## Configure sink()
if (sink.number() != 0) {sink()}
..scriptFileName.. <- gsub("^--file=", "", Filter(function(x) {grepl("^--file=", x)}, commandArgs()))
if (length(..scriptFileName..) == 1) {
    sink(file = paste0(..scriptFileName.., ".txt"), split = TRUE)
}
options(width = 120)


### Load data
################################################################################

## Define directory
data_dir <- "~/mimic2/_definition_files/"

## Define files
dict_files <- Filter(f = function(elt) {grepl("^D_", elt)}, x = dir(data_dir))


## List of datasets
lstDat <- sapply(gsub(".txt","",dict_files), function(file) {

    read.csv(paste0(data_dir, file, ".txt"))
})

cat("### head \n")
lapply(lstDat, head)



################################################################################
## Stop sinking to a file if active
if (sink.number() != 0) {sink()}














