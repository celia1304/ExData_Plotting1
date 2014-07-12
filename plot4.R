## Initialize file names
fileName <- 'household_power_consumption.txt'
subFile <- "household_power_consumption_sel.txt"

## Check if the subset of file already exists
if (!file.exists(subFile)) {
    
    ## check if the source file already exists
    if (!file.exists(fileName)) {
        
        url1<- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
        download.file(url1,"./hpc.zip")
        unzip("./hpc.zip")
        
    }
    
    ## Read the header row
    h1 <- read.table(fileName, header = TRUE, sep = ';', nrow=1)
    
    ## Read the needed data row
    r1 <- read.table(fileName, header = FALSE, sep =';', skip=65000, nrow=5000)
    colName <- c(names(h1))
    colnames(r1) <- colName
    
    ## Select only Feb 1 & 2, 2007 data into dataframe
    DF <- subset(r1, r1$Date =="1/2/2007" | r1$Date == '2/2/2007', select=names(r1))
    
    ## Write the selected data to an output file for re-use
    write.table(DF, subFile, sep=';')
}

## Read the source data into dataframe 
f2 <- read.table(subFile, header=TRUE, sep=";")

## Concatenate and reformat Date and Time column into proper datetime field
f2$DateTime <- strptime(paste(f2$Date, f2$Time), "%d/%m/%Y %H:%M:%S", tz="")

png(filename='plot4.png', width = 480, height = 480, 
    units = "px", pointsize = 12, bg = "white")

##plot 4

## Set the frame of 2 rows + 2 columns
par(mfrow=c(2,2))

## graph-1
with(f2, plot(DateTime, Global_active_power, type="l", col="black", 
              xlab="", ylab="Global Active Power"))

## graph-2
with(f2, plot(DateTime, Voltage, type="l", col="black", 
              xlab="datetime", ylab="Voltage"))

## graph-3
with(f2, plot(DateTime, Sub_metering_1, type="l", col="black", 
              xlab="", ylab="Energy sub metering"))

lines(f2$DateTime, f2$Sub_metering_2, type="l", col="red")

lines(f2$DateTime, f2$Sub_metering_3, type="l", col="blue")

legend("topright", pch="_", col=c("black", "red", "blue"), 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## graph-4
with(f2, plot(DateTime, Global_reactive_power, type="l", col="black", 
              xlab="datetime", ylab="Global_reactive_power"))

## Close the PNG file
dev.off()