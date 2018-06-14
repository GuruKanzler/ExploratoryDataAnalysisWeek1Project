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


# Create Plot 2
data$DateTime <- as.POSIXct(data$DateTime)

plot(data$Global_active_power ~ data$DateTime, type = "l",
     ylab = "Global Active Power (kilowatts)", xlab = "")


# Save Plot 2 to file
dev.copy(png, file = "plot2.png", height = 480, width = 480)
dev.off()

