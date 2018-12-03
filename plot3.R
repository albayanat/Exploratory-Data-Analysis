## plot3.R
## Question: Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
## which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
## Which have seen increases in emissions from 1999-2008?
##prerequisite: the file summarySCC_PM25.rds is in the working directory

cat("Running script plot3.R... \n")

## Check if required package is installed, else install then load
if(!"ggplot2" %in% rownames(installed.packages())) {install.packages("ggplot2")}
if(!"plyr" %in% rownames(installed.packages())) {install.packages("plyr")}
library(ggplot2)
library(plyr)


## Read the required datafiles
NEI <- readRDS("summarySCC_PM25.rds")

##Subset to Baltimore, MD (fips ==  "24510")
df_baltimore<-subset(NEI, fips ==  "24510")

##Compute Total emissions of PM2.5 per source and per year using ddply
df_baltimore_pm2.5<-ddply(df_baltimore, .(year, type), function(x) sum(x$Emissions))

##Rearrange the dataframe
df_baltimore_pm2.5$type <-as.factor(df_baltimore_pm2.5$type)
colnames(df_baltimore_pm2.5)[3]<-"total_emissions"

##remove unused large objects
rm(NEI,df_baltimore)

## Open png device
png("plot3.png", width=480, height=480)

## Construct the plot
plot3<-ggplot(df_baltimore_pm2.5, aes(factor(year), total_emissions, fill=type))
plot3<-plot3+geom_bar(stat="identity")+facet_grid(.~type)
plot3<-plot3+xlab("Year")+ylab("Total Emissions of PM2.5 (tons)")
plot3<-plot3+ggtitle("Total emissions of PM2.5 per type of source and per year in Baltimore, MD")
plot3<-plot3+theme_bw()
plot3<-plot3+guides(fill=FALSE)
print(plot3)

## Close the device
dev.off()

cat("plot3 saved into plot3.png \nEnd script plot3.R \n")
