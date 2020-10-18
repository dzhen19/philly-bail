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
foo <- function(x, year=1968){
  m <- year(x) %% 100
  year(x) <- ifelse(m > year %% 100, 1900+m, 2000+m)
  x
}
hist1 <- function() {
  data = read_csv("parsed1.csv")
  p <- hist(as.Date(data$offense_date, format = "%d/%m/%y"), breaks = 'months')
}

# Define UI for miles per gallon app ----
ui <- navbarPage("Philly Bail Stats",
          tabPanel("Map",
                   # Sidebar panel for inputs ----
            sidebarPanel(
              checkboxGroupInput("dist", "Crime type:",
                      c("Normal" = "norm",
                          "Uniform" = "unif",
                          "Log-normal" = "lnorm",
                          "Exponential" = "exp"))
                   ),
            mainPanel("Map", map())
          ),
          tabPanel("Histograms",
            # Sidebar panel for inputs ----
            sidebarPanel(
              #Offense Data Vs Destiny
              #Bail Amount Vs Frequency
              selectInput("histograms",
                          "Which Histogram Do Ya Want?",
                          choices=c("Offense Data Vs Denstiny", "Bail Amount Vs Frequency", "Date of Birth Vs Bail Amount in Thousands"),
                          selected=1
                          )
                ),
            mainPanel("Histograms",
                conditionalPanel(
                  condition = "input.histograms == 'Offense Data Vs Denstiny'",
                  plotOutput("hist1")
                ),
                conditionalPanel(
                  condition = "input.histograms == 'Bail Amount Vs Frequency'",
                  plotOutput("hist2")
                 ),
                 conditionalPanel(
                   condition = "input.histograms == 'Date of Birth Vs Bail Amount in Thousands'",
                   plotOutput("hist3")
                 )
            ),
          ),
          tabPanel("Table",
            # Sidebar panel for inputs ----
            sidebarPanel(
              checkboxGroupInput("dist", "Crime type:",
                    c("Normal" = "norm",
                      "Uniform" = "unif",
                      "Log-normal" = "lnorm",
                      "Exponential" = "exp"))
              ),
            mainPanel("Table", tableOutput("table"))
          )
      )
    #includeMarkdown("Diceware.rmd")


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
  output$hist1 <- renderCachedPlot({
    my_data <- as_tibble(data)
    my_data$offense_date <- as.Date(data$offense_date, format = "%m/%d/%y")
    x <- my_data %>% filter(offense_date > '2015-01-01')
    hist(x$offense_date, breaks = 'months',
         xlab = "Offense Date",
         ylab = "Density")
  }, cacheKeyExpr = { input$n })
  output$hist2 <- renderCachedPlot({
    my_data <- as_tibble(data)
    y <- my_data %>% filter(bail_amount < 100000)
    hist(y$bail_amount, breaks = "fd", 
         main = "Histogram of Bail Amount",
         xlab = "Bail Amount",
         ylab = "Frequency")
  }, cacheKeyExpr = { input$n })
  output$hist3 <- renderCachedPlot({
    x <- foo(as.Date(data$dob, format = "%m/%d/%y"), 1920)
    
    bail_in_thousands <- data$bail_amount / 1000
    plot(x, bail_in_thousands,
         xlab = "Date of Birth",
         ylab = "Bail Amount in Thousands")
  }, cacheKeyExpr = { input$n })
  output$table <- renderDataTable({
    table
  })
  #plotOutput("normal")
}

shinyApp(ui, server)
