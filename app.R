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
                          choices=c("Offense Data Vs Denstiny", "Bail Amount Vs Frequency", "Date of Birth Vs Bail Amount"),
                          selected=1
                          )
                ),
            mainPanel("Histograms",
                conditionalPanel(
                  condition = "input.histograms == 'Offense Data Vs Denstiny'",
                  plotOutput("hist1", click = "plot_click"),
                    verbatimTextOutput("info")
                ),
                conditionalPanel(
                  condition = "input.histograms == 'Bail Amount Vs Frequency'",
                  plotOutput("hist2", click = "plot_click"),
                  verbatimTextOutput("info2")
                 ),
                 conditionalPanel(
                   condition = "input.histograms == 'Date of Birth Vs Bail Amount'",
                   plotOutput("hist3", click = "plot_click"),
                   #tableOutput("test")
                   verbatimTextOutput("info3")
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
            mainPanel("Correlation Coeffieients", 
                      img(src="corr.png", width=500, height=500), 
                      img(src="heatmap.png", width=500, height=500))
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
  my_data <- as_tibble(data)
  my_data$offense_date <- as.Date(data$offense_date, format = "%m/%d/%y")
  my_data2015 <- my_data %>% filter(offense_date > '2015-01-01')
  my_dataBail <- my_data %>% filter(bail_amount < 100000)
  my_dataDOB <- foo(as.Date(data$dob, format = "%m/%d/%y"), 1920)
  bail_in_thousands <- data$bail_amount / 1000
  output$hist1 <- renderCachedPlot({
    #my_data <- as_tibble(data)
    hist(my_data2015$offense_date, breaks = 'months',
         xlab = "Offense Date",
         ylab = "Density")
  }, cacheKeyExpr = { input$n })
  output$hist2 <- renderCachedPlot({
    #my_data <- as_tibble(data)
    hist(my_dataBail$bail_amount, breaks = "fd", 
         main = "Histogram of Bail Amount",
         xlab = "Bail Amount",
         ylab = "Frequency")
  }, cacheKeyExpr = { input$n })
  output$hist3 <- renderCachedPlot({
    plot(my_dataDOB, bail_in_thousands,
         xlab = "Date of Birth",
         ylab = "Bail Amount in Thousands of $")
  }, cacheKeyExpr = { input$n })
  output$info <- renderText({
    paste0("density = ", input$plot_click$y)
  })
  output$info2 <- renderText({
    y <- input$plot_click$y
    if (is.numeric(y)) {#only render if y is numeric.
      paste0("bail = $", round(input$plot_click$x, digits=2), "\nfrequency = ", round(y))
    }
    else {
      paste0("bail = $\nfrequency = ")
    }
  })
  output$info3 <- renderText({
    y <- input$plot_click$y
    if (is.numeric(y)) {
      paste0("bail = $", round(y, digits=2))
    }
    else {
      paste0("bail = $")
    }
  })
  # output$test <- renderText({
  #   nearPoints(my_data, input$plot_click, xvar = "dob", yvar = "bail_amount")
  # })
  output$table <- renderDataTable({
    table
  })
  #plotOutput("normal")
}

shinyApp(ui, server)
