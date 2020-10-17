library(shiny)
library(reticulate)
library(markdown)
library(leaflet)

map <- function() {
  m <- leaflet() %>%
    addTiles() %>% 
    setView(lng = -75.1624776, lat = 39.9562897, zoom = 13) %>%
    addMarkers(lat= 39.9562897, lng= -75.1624776, popup = "Philadelphia, PA")
  m  # Print the map
}
distribution <- function() {
  x <- seq(5, 15, length=1000)
  #y <- dnorm(x, mean=10, sd=3)
  y <- seq(5, 15, length=1000)
  p <- plot(x, y, type="l", lwd=1)
  p
}

# Define UI for miles per gallon app ----
ui <- pageWithSideBar(
  
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
    # tabsetPanel(type = "tabs",
    #             tabPanel("Map", distribution()),#plotOutput("plot")),
    #             tabPanel("Summary", map()),
    #             tabPanel("Table", tableOutput("table"))
    # )
    #includeMarkdown("Diceware.rmd")
  )
)

# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  
}

shinyApp(ui, server)