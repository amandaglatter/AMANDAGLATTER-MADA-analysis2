###############################
# analysis script
#
#this script loads the processed, cleaned data, does a simple analysis
#and saves the results to the results folder

#load needed packages. make sure they are installed.
library(ggplot2) #for plotting
library(broom) #for cleaning up output from lm()
library(here) #for data loading/saving
library(tidyverse)
#!! below is important
library(reshape2) #Amanda added this one, make sure it is installed!!



#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","processed_data","processeddata.rds")

#load data. 
mydata <- readRDS(data_location)

######################################
#Data exploration/description
######################################
#I'm using basic R commands here.
#Lots of good packages exist to do more.
#For instance check out the tableone or skimr packages

#summarize data 
mysummary = summary(mydata)

#look at summary
print(mysummary)

#do the same, but with a bit of trickery to get things into the 
#shape of a data frame (for easier saving/showing in manuscript)
summary_df = data.frame(do.call(cbind, lapply(mydata, summary)))

#save data frame table to file for later use in manuscript
summarytable_file = here("results", "summarytable.rds")
saveRDS(summary_df, file = summarytable_file)


#focus on just the alzheimer data by age group
alz_data <- group_by(mydata, Age.group) %>% summarize(total_alz=sum(Alzheimer.disease..G30., na.rm=TRUE))
alzp1 <- alz_data %>% ggplot(aes(x=Age.group, y=total_alz)) + geom_col() +
  xlab("Age Group") + ylab("Total Deaths by Alzheimers") +
  ggtitle("Deaths Attributed to Alzheimers in 2020 by Age Group")
print(alzp1)

#focus on causes of death by sex
female_data <- mydata %>% subset(Sex == "Female (F)", select = 
                                   -c(Age.group)) %>%
  group_by(Sex) %>% summarize(Septicima = sum(10), Malignant.Neoplasm= sum(11),
                              Diabetes=sum(12), Alzheimer=sum(13), Flu=sum(14),
                              Chromic.low.resp=sum(15),
                              Other.resp=sum(16), Nephritis=sum(17),
                              Abnormal=sum(18), Heart.diseases=sum(19),
                              Cerebrovascular=sum(20),
                              Covid.multiple=sum(21), 
                              Covid.underlying.cause=sum(22))
bysex_data <- mydata%>%group_by(Sex) %>% summarize(Septicima = sum(10), Malignant.Neoplasm= sum(11),
                              Diabetes=sum(12), Alzheimer=sum(13), Flu=sum(14),
                              Chromic.low.resp=sum(15),
                              Other.resp=sum(16), Nephritis=sum(17),
                              Abnormal=sum(18), Heart.diseases=sum(19),
                              Cerebrovascular=sum(20),
                              Covid.multiple=sum(21), 
                              Covid.underlying.cause=sum(22))
melt_bysex <- bysex_data %>% melt(measure.vars=c(2,3,4,5,6,7,8,9,10,11,12,13,14),
                                  variable.name("Cause.of.death"))


#make a scatterplot of data
#we also add a linear regression line to it

p1 <- mydata %>% ggplot(aes(x=ReportYear, y=Value)) + geom_point() + geom_smooth(method='lm') + scale_y_continuous(trans='log2')

#look at figure
plot(p1)

#save figure
figure_file = here("results","resultfigure.png")
ggsave(filename = figure_file, plot=p1) 

######################################
#Data fitting/statistical analysis
######################################

# fit linear model
 
lmfit <- lm(Value ~ ReportYear, mydata) 

# place results from fit into a data frame with the tidy function
lmtable <- broom::tidy(lmfit)

#look at fit results
print(lmtable)

# save fit results table  
table_file = here("results", "resulttable.rds")
saveRDS(lmtable, file = table_file)

  