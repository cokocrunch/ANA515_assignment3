setwd("C://Users/NicoWong/Documents/")
library(ggplot2)
library(plyr)
library(dplyr)
library(tidyverse)
library(lubridate)
library(stringr)


df <- read.csv("storm1995.csv",header = T)

df1<-select(df,BEGIN_DATE_TIME,END_DATE_TIME,EPISODE_ID,EVENT_ID,STATE,STATE_FIPS,CZ_NAME,CZ_TYPE,CZ_FIPS,EVENT_TYPE,SOURCE,BEGIN_LAT,BEGIN_LON,END_LAT,END_LON)

df1$BEGIN_DATE_TIME<- as.character(df1$BEGIN_DATE_TIME)
df1$END_DATE_TIME<- as.character(df1$END_DATE_TIME)


df1$BEGIN_DATE_TIME<- dmy_hms(df1$BEGIN_DATE_TIME,tz=Sys.timezone())
df1$END_DATE_TIME<- dmy_hms(df1$END_DATE_TIME,tz=Sys.timezone())

df1$STATE<-as.character(df1$STATE)
df1$CZ_NAME<-as.character(df1$CZ_NAME)
df1$STATE<-str_to_title(df1$STATE)
df1$CZ_NAME<-str_to_title(df1$CZ_NAME)

df1<-df1 %>%
  filter(CZ_TYPE=='C') %>% 
  select(-CZ_TYPE)

df1$STATE_FIPS<-as.character(df1$STATE_FIPS)
df1$CZ_FIPS<-as.character(df1$CZ_FIPS)
df1$CZ_FIPS<-str_pad(df1$CZ_FIPS,3,pad="0")

df1$FIPS<-paste(df1$STATE_FIPS,df1$CZ_FIPS,sep="")
df1$FIPS<-str_pad(df1$FIPS,5,pad="0")

df1 <- df1 %>%
  rename_all(tolower)

df2<-data.frame(state.name,state.area,state.region)

aff_df<-df1 %>% count(state)
new_df<-df2 %>% left_join(as.data.frame(aff_df), by=c("state.name"="state"))

ggplot(new_df, aes(x=state.area, y=n, color=state.region)) +
  geom_point() +xlab("Land area (square miles)")+ylab("# of storm events in 1995")
