## Name: assignment2_plot6.R 
##
## This R program will be used to accomplish the following: 
## 1. Compare emissions from motor vehicle sources in Baltimore City (fips == "24510") with emissions from motor vehicle sources 
##    in Los Angeles County, California (fips == "06037"). 
## 2. Make a single plot to answer the following question: 
##    "Which city has seen greater changes over time in motor vehicle emissions?"

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


## Select only "motor vehicle" related emission with data collected for city of "Baltimore" and "Los Angeles" 
## Per "Description of NEI Data Categories" on the EPA website, type of "ON-ROAD" and "NONROAD" seem to be 
## Motor Vehicle related.  Both of those two categories are included in the final dataset for comparison.

nei_df <- subset(nei, (nei$fips == "24510" | nei$fips == "06037") 
                 & (nei$type == "ON-ROAD" | nei$type = "NONROAD"), select=names(nei))


## Create dataframe by summarizing emission total by year and fips
emission_brkdwn <- ddply(nei_df, .(year, fips), summarize, sum(Emissions))

## Provide meaningful column names
colnames(emission_brkdwn) <- c("year", "fips", "total_emission")

## Add city column to the dataframe based on the fips value
emission_brkdwn$city <- sapply(emission_brkdwn$fips, switch, 
                               "24510" = "Baltimore", 
                               "06037" = "Los Angeles")

## Initialize the pgn file
png(filename='assignment2_plot6.png', width = 480, height = 480, units = "px", pointsize = 12, bg = "white")

## Using qplot to plot the emission comparison data
qplot(year, total_emission, data = emission_brkdwn, main="Emission Comparison Between LA and Baltimore",
      xlab="Year", ylab="Totatl Emission", fill=city, col=city, geom="path")

dev.off()
