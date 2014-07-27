## Name: assignment2_plot4.R 
##
## This R program will be used to accomplish the following: 
## 1. Make a single plot to answer the following question: 
##    "Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?"

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

## Replace "." in the column name with "-" for easier referencing of the column for merging later on
colnames(scc) <- gsub("\\.", "_", names(scc))

## Check which columns contain the values of "coal", this column list will be used for filtering later 
colsum <- which(sapply(scc, function(x) any(grep("*[Cc]oal",x))))

## Select only SCC records that are "Coal Combustion" related
## Based on the result of the "colsum" dataframe above, there are 4 columns that contain string of "coal"
scc_list <- subset(scc, grepl("*[Cc]oal*", scc$Short_Name) | grepl("*[Cc]oal*", scc$EI_Sector) 
               | grepl("*[Cc]oal*", scc$SCC_Level_Three) | grepl("*[Cc]oal*", scc$SCC_Level_Four), 
               select=names(scc))

## Merge the two dataframe by joining on the "SCC" column
## Select only records with coal combustion related emission
nei_df <- merge(nei, scc_list, by="SCC")

## Create dataframe by summarizing emission total by year
emission_brkdwn <- ddply(nei_df, .(year), summarize, sum(Emissions))

## Provide meaningful column names
colnames(emission_brkdwn) <- c("year", "total_emission")

## Initialize the pgn file
png(filename='assignment2_plot4.png', width = 480, height = 480, units = "px", pointsize = 12, bg = "white")

## Plot the emission trending data
with(emission_brkdwn, plot(year, total_emission, 
                           main="Coal Combustion Emission (in tons) by Year",
                           type="l", col="green", xlab="Year", ylab="Total Emission"))

dev.off()