## check if the source file already exists
setwd("../Coursera/ExploratoryDataAnalysis")

library("plyr")
library("reshape2")
library("lattice")
library("datasets")
library("ggplot2")

options(scipen=10)

pm25_file <- "summarySCC_PM25.rds"
code_file <- "Source_Classification_Code.rds"

if (!file.exists(pm25_file) | !file.exists(code_file)) {
    
    url1<- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url1,"./fnei.zip")
    unzip("./fnei.zip")
    
}

nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")

colnames(scc) <- gsub("\\.", "_", names(scc))

nei_table <- table(nei$type, nei$year)

baltimore_nei <- subset(nei, nei$fips == "24510", select=names(nei))

emission_by_year <- ddply(baltimore_nei, .(year), summarize, sum(Emissions))

colnames(emission_by_year) <- c("year", "total_emission")

png(filename='plot2.png', width = 480, height = 480, units = "px", pointsize = 12, bg = "white")

with(emission_by_year, plot(year, total_emission, main="Baltimore City, Total Emission (in tons) by Year", type="l", col="blue", xlab="Year", ylab="Total Emission"))

dev.off()