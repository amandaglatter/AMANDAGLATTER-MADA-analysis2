###############################
# processing script
#
#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the processed_data folder

#load needed packages. make sure they are installed.
library(here) #to set paths
library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)


#path to data
#note the use of the here() package and not absolute paths

data_location <- here::here("data","raw_data","Air_Quality_Measures_on_the_National_Environmental_Health_Tracking_Network.csv")

#load data. 

rawdata <- read.csv(data_location)

#take a look at the data
dplyr::glimpse(rawdata)

#When I glimpse at the data I notice a few issues.
#First, for many of the observations, there is no unit reported.
#This could be an issue. Later observations do report a unit.
#Next, there are multiple different measure names, meaning that the
#type of measurement varies. This could make things very complicated.
#As we discussed in the last module, multiple data types in one table
#is a common error.

#To simplify, I am first going to subset into just into a single
#measure name so we can narrow down the data we are looking at.
#This measure type will be "Number of person-days with maximum 8-hour average 
#ozone concentration over the National Ambient Air Quality Standard (monitor 
#and modeled data)"
#We know that the unit name for this category is "person-days," so the columns
#"Unit" and "UnitName" are of no use to us. Let's remove these columns.
#Let's focus on StateName, CountyName, ReportYear, and Value

subset1 <- rawdata %>% subset(MeasureName = "Number of person-days with maximum 8-hour average ozone concentration over the National Ambient Air Quality Standard (monitor and modeled data)
") %>% subset(select = c("StateName", "CountyName", "ReportYear", "Value"))

head(subset1)

#I will make a few more options for analysis from this point.

#Option 1
#Let's look at just California.

cali <- subset1 %>% subset(StateName == "California")

#Option 2
#Let's only look at the year 1999 for all states and counties.
ninenine <- subset1 %>% subset(Year = "1999")

#There's still stuff to clean up, but that's all I'll do for now. Onto you,
#next group member!

#I'm keeping the below code in case I want to use it in the future
#processeddata <- rawdata %>% dplyr::filter( Height != "sixty" ) %>% 
#                             dplyr::mutate(Height = as.numeric(Height)) %>% 
#                             dplyr::filter(Height > 50 & Weight < 1000)

# save data as RDS
# I suggest you save your processed and cleaned data as RDS or RDA/Rdata files. 
# This preserves coding like factors, characters, numeric, etc. 
# If you save as CSV, that information would get lost.
# See here for some suggestions on how to store your processed data:
# http://www.sthda.com/english/wiki/saving-data-into-r-data-format-rds-and-rdata

processeddata<-cali

# location to save file
save_data_location <- here::here("data","processed_data","processeddata.rds")

saveRDS(processeddata, file = save_data_location)


