## Name: assignment2_plot5.R 
##
## This R program will be used to accomplish the following: 
## 1. Make a single plot to answer the following question: 
##    "How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City (fips == "24510")? "

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

## Select only "motor vehicle" related emission with data collected for city of "Baltimore"
## Per "Description of NEI Data Categories" on the EPA website, type of "ON-ROAD" and "NONROAD" seem to be 
## Motor Vehicle related.  Both of those two categories are included in the final dataset for comparison.
baltimore_nei <- subset(nei, nei$fips == "24510" & (nei$type == "ON-ROAD" | nei$type = "NONROAD"), select=names(nei))


## Create dataframe by summarizing emission total by year
emission_brkdwn <- ddply(baltimore_nei, .(year), summarize, sum(Emissions))

## Provide meaningful column names
colnames(emission_brkdwn) <- c("year", "total_emission")


## Initialize the pgn file
png(filename='assignment2_plot5.png', width = 480, height = 480, units = "px", pointsize = 12, bg = "white")

## Plot the emission trending data
with(emission_brkdwn, plot(year, total_emission, main="Baltimore - Motor Vehicle Emission (in tons) by Year", type="l", col="brown", xlab="Year", ylab="Total Emission"))

dev.off()