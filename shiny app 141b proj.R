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
nbadata2<- nbadata[-c(23, 54, 77, 102, 133, 160, 187, 216, 239, 264, 291, 312,
                     337, 362, 385, 406, 430, 457, 480, 503, 528, 551, 579, 604, 631), ]

#Convert necessary columns from character to numeric
cols = c(1,4, 6:30)    
nbadata2[,cols] = apply(nbadata2[,cols],2,  function(x) as.numeric(as.character(x)))

#Replace "NAs" with 0s
nbadata2<- nbadata2%>%
  mutate_all(~replace(., is.na(.), 0))

#Remove %s from variable names
nbadata2<-nbadata2%>%
  rename(
    "FGPercentage" = "FG%",
    "3PPercentage" = "3P%",
    "2PPercentage"="2P%",
    "eFGPercentage"="eFG%",
    "FTPercentage"="FT%"
  )
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
#FGPercentage -- Field Goal Percentage
#3P -- 3-Point Field Goals Per Game
#3PA -- 3-Point Field Goal Attempts Per Game
#3PPercentage -- FG% on 3-Pt FGAs.
#2P -- 2-Point Field Goals Per Game
#2PA -- 2-Point Field Goal Attempts Per Game
#2PPercentage -- FG% on 2-Pt FGAs.
#eFGPercentage -- Effective Field Goal Percentage
#This statistic adjusts for the fact that a 3-point field goal is worth one more point than a 2-point field goal.
#FT -- Free Throws Per Game
#FTA -- Free Throw Attempts Per Game
#FTPercentage -- Free Throw Percentage
#ORB -- Offensive Rebounds Per Game
#DRB -- Defensive Rebounds Per Game
#TRB -- Total Rebounds Per Game
#AST -- Assists Per Game
#STL -- Steals Per Game
#BLK -- Blocks Per Game
#TOV -- Turnovers Per Game
#PF -- Personal Fouls Per Game
#PTS -- Points Per Game
library(plotly)
#p<-ggplot(data = nbadata, mapping = aes(x = FTPercentage, y = ORB, color=Player))+geom_point()+ theme(legend.position = "none")
#p <- ggplotly(p, hoverinfo=Player)
#p

#Shiny App
library(shiny)
cols2 = c(4,5 ,6:30)
ui <- fluidPage(
  headerPanel('NBA Stats'),
  sidebarPanel(
    selectInput('xcol','X Variable', names(nbadata2[cols2])),
    selectInput('ycol','Y Variable', names(nbadata2[cols2])),
    selected = names(nbadata[cols2])[[2]]),
  mainPanel(
    plotlyOutput('plot')
  )
)

server <- function(input, output) {
  
  x <- reactive({
    nbadata2[,input$xcol]
  })
  
  y <- reactive({
    nbadata2[,input$ycol]
  })
  
  
  output$plot <- renderPlotly(
    plot1 <- plot_ly(
      x = x(),
      y = y(), 
      color=nbadata2$Player,
      showlegend=FALSE,
      type = 'scatter',
      mode = 'markers'
    )%>%layout(xaxis = list(title = input$xcol), yaxis = list(title = input$ycol)))
  
  
}

shinyApp(ui,server)





