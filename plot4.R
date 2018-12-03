## plot4.R
## Question: Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

cat("Running script plot4.R... \n")

## Check if required package is installed, else install then load
if(!"ggplot2" %in% rownames(installed.packages())) {install.packages("ggplot2")}
if(!"plyr" %in% rownames(installed.packages())) {install.packages("plyr")}
library(ggplot2)
library(plyr)

## Read the required datafiles
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Subset to coal combustion related source
SCC_coal_comb<-subset(SCC, grepl("[Cc][Oo][Aa][Ll]", Short.Name) & grepl("[Cc][Oo][Mm][Mb]", Short.Name))
NEI_coal_comb<-subset(NEI, SCC %in% SCC_coal_comb$SCC)

##Compute Total emissions of PM2.5 per year for coal combustion-related sources
df_comb_coal_pm2.5<-ddply(NEI_coal_comb, .(year), function(x) sum(x$Emissions))

##Rearrange the dataframe
colnames(df_comb_coal_pm2.5)[2]<-"total_emissions"

## Open png device
png("plot4.png", width=480, height=480)

## Construct the plot
plot4<-ggplot(df_comb_coal_pm2.5, aes(factor(year), total_emissions/1000))
plot4<-plot4 + geom_bar(stat="identity", fill = "grey")
plot4<-plot4+xlab("Year")+ylab("Total Emissions of PM2.5 (x1000 tons)")
plot4<-plot4+ggtitle("Total emissions of PM2.5 in USA for coal combustion-related sources")
plot4<-plot4+theme_bw()
plot4<-plot4+guides(fill=FALSE)
print(plot4)

## Close the device
dev.off()

cat("plot4 saved into plot4.png \nEnd script plot4.R \n")
