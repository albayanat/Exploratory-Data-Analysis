## plot6.R
## Question: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips=="06037"). 
## Which city has seen greater changes over time in motor vehicle emissions?
##prerequisite: the files summarySCC_PM25.rds and Source_Classification_Code.rds are in the working directory

cat("Running script plot6.R... \n")

## Check if required package is installed, else install then load
if(!"ggplot2" %in% rownames(installed.packages())) {install.packages("ggplot2")}
if(!"plyr" %in% rownames(installed.packages())) {install.packages("plyr")}
library(ggplot2)
library(plyr)

## Read the required datafiles
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subset to data related to motor vehicle sources (use SCC.Level.Two) in Baltimore and in Los Angeles
SCC_vehicle<-subset(SCC, grepl("vehicle", SCC.Level.Two,ignore.case=TRUE ))
NEI_BC_LA_vehicle<-subset(NEI, SCC %in% SCC_vehicle$SCC &  (fips ==  "24510"| fips =="06037"))

##Compute Total emissions of PM2.5 per year for motor vehicle sources
df_BC_LA_vehicle_pm2.5<-ddply(NEI_BC_LA_vehicle, .(year, fips), function(x) sum(x$Emissions))

##Rearrange the dataframe
colnames(df_BC_LA_vehicle_pm2.5)[3]<-"total_emissions"
df_BC_LA_vehicle_pm2.5<- transform(df_BC_LA_vehicle_pm2.5, city = ifelse(fips == "24510", "Baltimore City", "Los Angeles County"))

##remove unused large objects
rm(NEI,SCC, SCC_vehicle,NEI_BC_LA_vehicle)

## Open png device
png("plot6.png", width=480, height=480)

## Construct the plot
plot6<-ggplot(df_BC_LA_vehicle_pm2.5, aes(factor(year), total_emissions, fill = city))
plot6<-plot6 + geom_bar(stat="identity")
plot6<-plot6+facet_grid(.~city)
plot6<-plot6+xlab("Year")+ylab("Total Emissions of PM2.5 (tons)")
plot6<-plot6+ggtitle("Total emissions of PM2.5 for motor vehicle sources")
plot6<-plot6+theme_bw()
plot6<-plot6+guides(fill=FALSE)
print(plot6)
## Close the device
dev.off()

cat("plot6 saved into plot6.png \nEnd script plot6.R \n")
