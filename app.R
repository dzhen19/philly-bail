library(tidyverse)
library(shiny)
library(reticulate)
library(markdown)
library(leaflet)
library(lubridate)
library(data.table)

parsed1 <- read_csv("parsed1.csv")
map <- function() {
  zip <- read_csv("latitudeLongitudeBail(1).csv")
  m <- leaflet(data=zip) %>%
    addTiles() %>% 
    setView(lng = -75.1624776, lat = 39.9562897, zoom = 13) %>%
    addCircleMarkers(radius = 5)
    #addCircleMarkers(lat= 39.9562897, lng= -75.1624776, popup = "Philadelphia, PA")
  
  m  # Print the map
}
hist1 <- function() {
  data = read_csv("parsed1.csv")
  p <- hist(as.Date(data$offense_date, format = "%d/%m/%y"), breaks = 'months')
  
}

# Define UI for miles per gallon app ----
ui <- fluidPage(
  # App title ----
  headerPanel("Philly Bail Stats"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    checkboxGroupInput("dist", "Crime type:",
                       c("Normal" = "norm",
                         "Uniform" = "unif",
                         "Log-normal" = "lnorm",
                         "Exponential" = "exp"))
  ),
  
  # Main panel for displaying outputs ----
  mainPanel(
    # Output: Tabset w/ plot, summary, and table ----
     tabsetPanel(type = "tabs",
                 tabPanel("Map", map()),#plotOutput("plot")),
                 tabPanel("Summary", plotOutput("hist1")),
                 tabPanel("Table", tableOutput("table"))
    )
    #includeMarkdown("Diceware.rmd")
  )
)

# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  x <- seq(5, 15, length=1000)
  y <- dnorm(x, mean=10, sd=3)
  #p <- plot(x, y)#, type="l", lwd=1)
  data <- read_csv("parsed1.csv")
  table <- as.data.table(read_csv("parsed1.csv"))
  #seemingly no way to make data table in r shiny
  # output$normal <- renderPlot({
  #   plot(x, y)
  # })
  output$hist1 <- renderPlot({
    hist(as.Date(data$offense_date, format = "%d/%m/%y"), breaks = 'months')
  })
  output$table <- renderDataTable({
    table
  })
  #plotOutput("normal")
}

shinyApp(ui, server)
