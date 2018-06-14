# Create a destination folder for downloaded data if it doesn't already exists.
if(!file.exists("./data")){dir.create("./data")}

# Variables to make for a bit more readable code for downloading and extracting data
folder <- file.path(getwd(),"data")
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
f <- file.path(folder,"HouseholdPowerConsumption.zip")

# Download and unzip data
if (!file.exists(f)){
        download.file(url,f, mode = "wb")
        unzip(f, exdir = folder)
}

# Load data from file
datafile <- "./data/household_power_consumption.txt"
data <- read.table(datafile, sep=";", stringsAsFactors=F
                   , dec=".", header = T, na.strings = "?")

# Change format of the Date column
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

# Add combined Date and Time field
data$DateTime <- strptime(paste(data$Date, data$Time), "%Y-%m-%d %H:%M:%S")

# Subset
data <- subset(data, subset = (Date >= "2007-02-01" & Date <= "2007-02-02"))

# Make DateTime possible to filter and graph by time of day etc
data$DateTime <- as.POSIXct(data$DateTime)

# Open up an empty image
png("plot4.png", width = 480, height = 480)

# Arrange for four graphs in a 2 by 2 matrix
par(mfrow = c(2,2))

# Add plot 1 to image
hist(as.numeric(data$Global_active_power)
             , main = "Global Active Power"
             , xlab = "Global Active Power (kilowatts)"
             , col = "red"
        )
# Add plot 2
plot(data$Global_active_power ~ data$DateTime, type = "l",
     ylab = "Global Active Power (kilowatts)", xlab = "")

# Add plot 3
plot(data$Sub_metering_1 ~ data$DateTime
        , type = "l"
        , ylab = "Energy Sub Metering"
        , xlab = "" 
        )
lines(data$Sub_metering_2 ~ data$DateTime, col = "red")
lines(data$Sub_metering_3 ~ data$DateTime, col = "blue")
legend("topright"
       , lty = 1
       , col = c("black", "red", "blue")
       , legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3") )

# Add plot 4
plot(data$Global_reactive_power ~ data$DateTime
        , xlab = "datetime"
        , ylab = "Global_reactive_power"
        , type = "l"
     )

dev.off()