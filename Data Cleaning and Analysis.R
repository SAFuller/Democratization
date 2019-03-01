##Democratization and Terrorism Project


##libraries
library(countrycode)
library(magrittr)
library(tidyr)
library(readr)
##Read Data
force<-read.csv("UseofForceData.csv")
transition<-read.csv("BR-integrated-dataset.csv")

#Clean data
transition$ccode<-countrycode(transition$country, "country.name", "cown")
force$year<-paste0(19,force$year)

##gtd
gtd<-read_csv("globalterrorismdb.csv", col_types = cols(iyear = col_date(format = "%Y")))
gtd<-aggregate(eventid~country*iyear, data=gtd, FUN=length)
names(gtd)[names(gtd) == 'eventid'] <- 'numattack'

gtd2<-gtd %>%
  complete(iyear = seq.Date(min(iyear), max(iyear), by="year"),country)
gtd2$numattack[is.na(gtd2$numattack)]<-0

gtd2$year<-substr(gtd2$iyear,1,4)%>%as.numeric()

##merge

data<-merge(transition, force, by=c("ccode","year"))
data<-merge(data, gtd2, by.x=c("ccode","year"), by.y=c("country","year"), all= TRUE)
