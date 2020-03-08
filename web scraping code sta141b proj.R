library(tidyverse)
library(rvest)
#Read in url
url<-("https://www.basketball-reference.com/leagues/NBA_2020_per_game.html")
nbadata <- url %>% 
  read_html() %>% 
  html_table() %>% 
  .[[1]]

attach(nbadata)

#The variables names appeared multiple times in the dataset so we must remove them
nbadata<- nbadata[-c(23, 54, 77, 102, 133, 160, 187, 216, 239, 264, 291, 312,
                     337, 362, 385, 406, 430, 457, 480, 503, 528, 551, 579, 604, 631), ]

#Convert necessary columns from character to numeric
cols = c(1,4, 6:30)    
nbadata[,cols] = apply(nbadata[,cols],2,  function(x) as.numeric(as.character(x)))

#Replace "NAs" with 0s
nbadata<- nbadata%>%
  mutate_all(~replace(., is.na(.), 0))
