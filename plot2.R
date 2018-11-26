## plot2.R
## Question: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips=="24510") from 1999 to 2008?
##prerequisite: the file summarySCC_PM25.rds is in the working directory

cat("Running script plot2.R... \n")

## Read the required datafiles

NEI <- readRDS("summarySCC_PM25.rds")


## Subset the data to Baltimore City, Maryland (fips == "24510")
NEI_baltimore<- subset(NEI, fips == "24510")

##Compute the sum of emission for each year 
total_pm25_year_baltimore <- tapply(NEI_baltimore$Emissions, NEI_baltimore$year, sum, na.rm = TRUE)

## Open png device
png("plot2.png", width=480, height=480)

## Construct the plot
barplot(total_pm25_year_baltimore, main = "Total Emissions of PM2.5 per year in Baltimore, Maryland",
        xlab = "Year", ylab = "Total Emissions of Pm2.5 (tons)")

## Close the device
dev.off()

cat("plot2 saved into plot1.png \n End script plot2.R \n")