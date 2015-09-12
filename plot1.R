rm(list=ls())
#make sure the file exists, otherwise it will stop the operation
filename="household_power_consumption.txt"
if(!file.exists(filename)){
    stop("file household_power_consumption.txt not found")    
}

#since I don't want to use grep(which is only available on unix like system) as has been suggested in forum, 
#I decided to do it slow way
#check class of columns to make read table faster
readToCheckClass <- read.table(filename,sep=";",header=TRUE,nrows = 1)
columnClasses <- sapply(readToCheckClass,class)
indexClasses <- c(columnClasses[1], rep("NULL",length(columnClasses)-1))

#read column for index
indexData <- read.table(filename,sep=";",header=TRUE, colClasses = indexClasses, na.strings="?", comment.char="", quote="")
beginIdx <- head(which(indexData$Date=="1/2/2007"),n = 1)
endIdx <- tail(which(indexData$Date=="2/2/2007"),n = 1)
readRow <- endIdx - beginIdx

#read the data with parameters to speed up read process
hpcData <- read.table(filename,sep=";",header=TRUE, colClasses = columnClasses, na.strings="?", comment.char="", quote="", skip = beginIdx-1, nrows = readRow)
names(hpcData) <- names(readToCheckClass)

#call graphic device first based on discussion https://class.coursera.org/exdata-032/forum/thread?thread_id=50
png(file="plot1.png",width=480,height=480)

#plot a histogram
hist(hpcData$Global_active_power, col="red", main="Global Active Power", xlab = "Global Active Power (kilowatts)")

#copy plot to png file
dev.off()