## Name: assignment2_plot3.R 
##
## This R program will be used to accomplish the following: 
## 1. Use the ggplot2 plotting system to make a plot to answer the following question: 
##      a.  "Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
##          which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City?"
##      b.  "Which have seen increases in emissions from 1999-2008? "
## 

## Set working directory path
## setwd("../Coursera/ExploratoryDataAnalysis")

library("plyr")
library("reshape2")
library("datasets")
library("ggplot2")

## Initialize file name variable 
pm25_file <- "summarySCC_PM25.rds"
code_file <- "Source_Classification_Code.rds"

## Check if source files already exist before retrieving data from the website
if (!file.exists(pm25_file) | !file.exists(code_file)) {
    
    url1<- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url1,"./fnei.zip")
    unzip("./fnei.zip")
    
}


## Read the input files
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

## Create dataframe with only "Baltimore City" related emission data
baltimore_nei <- subset(nei, nei$fips == "24510", select=names(nei))

## Create dataframe by summarizing emission total by year and type
emission_brkdwn <- ddply(baltimore_nei, .(year, type), summarize, sum(Emissions))

## Provide meaningful column names
colnames(emission_brkdwn) <- c("year", "type", "total_emission")

## Initialize the pgn file
png(filename='assignment2_plot3.png', width = 480, height = 480, units = "px", pointsize = 12, bg = "white")

## Plot the emission trending data
ggplot(data=emission_brkdwn, aes(x=year, y=total_emission, group=type, col=type, shape=type))+geom_line()+geom_point()

dev.off()