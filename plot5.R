## plot5.R
## Question: How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

cat("Running script plot5.R... \n")

## Check if required package is installed, else install then load
if(!"ggplot2" %in% rownames(installed.packages())) {install.packages("ggplot2")}
if(!"plyr" %in% rownames(installed.packages())) {install.packages("plyr")}
library(ggplot2)
library(plyr)

## Read the required datafiles
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subset to data related to motor vehicle sources (use SCC.Level.Two) in Baltimore
SCC_vehicle<-subset(SCC, grepl("vehicle", SCC.Level.Two,ignore.case=TRUE ))
NEI_baltimore_vehicle<-subset(NEI, SCC %in% SCC_vehicle$SCC &  fips ==  "24510")

##Compute Total emissions of PM2.5 per year for motor vehicle sources
df_baltimore_vehicle_pm2.5<-ddply(NEI_baltimore_vehicle, .(year), function(x) sum(x$Emissions))

##Rearrange the dataframe
colnames(df_baltimore_vehicle_pm2.5)[2]<-"total_emissions"

## Open png device
png("plot5.png", width=480, height=480)

## Construct the plot
plot5<-ggplot(df_baltimore_vehicle_pm2.5, aes(factor(year), total_emissions))
plot5<-plot5 + geom_bar(stat="identity", fill = "grey")
plot5<-plot5+xlab("Year")+ylab("Total Emissions of PM2.5 (tons)")
plot5<-plot5+ggtitle("Total emissions of PM2.5 in Baltimore for motor vehicle sources")
plot5<-plot5+theme_bw()
plot5<-plot5+guides(fill=FALSE)
print(plot5)
## Close the device
dev.off()

cat("plot5 saved into plot5.png \nEnd script plot5.R \n")
