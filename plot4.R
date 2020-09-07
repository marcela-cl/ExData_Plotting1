# R version x64 4.0.2

Sys.setlocale("LC_TIME", "C")

library(data.table)
library(lubridate)

# download data and save it to the working directory

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists("epc.zip")){
    download.file(fileURL, destfile = "epc.zip", method = "curl")
    unzip(zipfile= "epc.zip", overwrite = TRUE)
    # file household_power_consumption.txt is generated
}

# read data with fread to create data.table dt

valid_classes <- c("character", "character", "numeric", "numeric", "numeric", 
                   "numeric", "numeric", "numeric", "numeric")
dt = fread("household_power_consumption.txt", stringsAsFactors = FALSE,
           na.strings="?", colClasses = valid_classes)

# combine Date and Time columns (first 2 cols of dt) to create datetime column
# and use package lubridate to change into POSIXCT type

dt$datetime <- paste(dt$Date, dt$Time)
dt$datetime <- dmy_hms(dt$datetime)

# subset dt considering the following dates

start_date <- ymd_hms("2007-02-01 00:00:00")
end_date <- ymd_hms("2007-02-02 23:59:59")

dt <- dt[(dt$datetime>=start_date) & (dt$datetime<=end_date)]
list_columns <- c(10,3,4,5,6,7,8,9)
dt <- dt[,..list_columns]

# plot graph and save it into "plot4.png"

png("plot4.png", width = 480, height = 480, units = "px")
par(mfrow=c(2,2))
with(dt, plot(datetime, Global_active_power, col="black", type = "l",
              xlab = "", ylab = "Global Active Power"))
with(dt, plot(datetime, Voltage, col="black", type = "l"))
with(dt, plot(datetime, Sub_metering_1, col = "black", type = "l",ylab = "", xlab = ""))
with(dt, points(datetime, Sub_metering_2, col = "red", type = "l", ylab = "", xlab = ""))
with(dt, points(datetime, Sub_metering_3, col = "blue", type = "l", ylab = "", xlab = ""))
title(ylab = "Energy sub metering")
legend("topright", col = c("black", "red", "blue"), lty = 1, bty = "n",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
with(dt, plot(datetime, Global_reactive_power, col="black", type = "l"))
dev.off()
