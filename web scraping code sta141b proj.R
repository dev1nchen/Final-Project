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


#Dataset Description
#Rk -- Rank
#Pos -- Position
#Age -- Player's age on February 1 of the season
#Tm -- Team
#G -- Games
#GS -- Games Started
#MP -- Minutes Played Per Game
#FG -- Field Goals Per Game
#FGA -- Field Goal Attempts Per Game
#FG% -- Field Goal Percentage
#3P -- 3-Point Field Goals Per Game
#3PA -- 3-Point Field Goal Attempts Per Game
#3P% -- FG% on 3-Pt FGAs.
#2P -- 2-Point Field Goals Per Game
#2PA -- 2-Point Field Goal Attempts Per Game
#2P% -- FG% on 2-Pt FGAs.
#eFG% -- Effective Field Goal Percentage
#This statistic adjusts for the fact that a 3-point field goal is worth one more point than a 2-point field goal.
#FT -- Free Throws Per Game
#FTA -- Free Throw Attempts Per Game
#FT% -- Free Throw Percentage
#ORB -- Offensive Rebounds Per Game
#DRB -- Defensive Rebounds Per Game
#TRB -- Total Rebounds Per Game
#AST -- Assists Per Game
#STL -- Steals Per Game
#BLK -- Blocks Per Game
#TOV -- Turnovers Per Game
#PF -- Personal Fouls Per Game
#PTS -- Points Per Game


