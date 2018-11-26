## plot1.R
## Question: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
##prerequisite: the file summarySCC_PM25.rds is in the working directory

cat("Running script plot1.R... \n")

## Read the required datafiles
NEI <- readRDS("summarySCC_PM25.rds")


## Compute the sum of Emissions of PM2.5 per year
total_pm25_year <- tapply(NEI$Emissions/1000, NEI$year, sum, na.rm = TRUE)

## Open png device
png("plot1.png", width=480, height=480)

## Construct the plot
barplot(total_pm25_year, main = "Total Emissions of PM2.5 per year", 
        xlab = "Year", ylab = "Total Emissions of Pm2.5 (x1000 tons)")

## Close the device
dev.off()

cat("plot1 saved into plot1.png \nEnd script plot1.R \n")
