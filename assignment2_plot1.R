## Name: assignment2_plot1.R 
##
## This R program will be used to accomplish the following: 
## 1. Using the base plotting system, make a plot showing the total PM2.5 emission from all sources 
##    for each of the years 1999, 2002, 2005, and 2008.
## 2. Use the above base plot to answer the following question:   
##      a.  "Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?" 
## 

## Set working directory path
## setwd("../Coursera/ExploratoryDataAnalysis")

library("plyr")
library("reshape2")
library("datasets")

options(scipen=5)

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

## Create dataframe by summarizing emission total by year
emission_by_year <- ddply(nei, .(year), summarize, sum(Emissions))

## Provide meaningful column names
colnames(emission_by_year) <- c("year", "total_emission")

## Initialize the pgn file
png(filename='assignment2_plot1.png', width = 480, height = 480, units = "px", pointsize = 12, bg = "white")

## Plot the emission trending data
with(emission_by_year, plot(year, total_emission, main="Total Emission (in tons) by Year", type="l", col="blue", xlab="Year", ylab="Total Emission"))

dev.off()