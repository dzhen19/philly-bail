library(shiny)
library(reticulate)
library(markdown)
# Define UI for miles per gallon app ----
ui <- pageWithSidebar(
  
  # App title ----
  headerPanel("Philly Bail Stats"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    div(style="display: inline-block",
        selectInput("wordNumber", "Number of Words:", c(1:20))
    )
  ),
  
  # Main panel for displaying outputs ----
  mainPanel(
    # Output: Tabset w/ plot, summary, and table ----
    tabsetPanel(type = "tabs",
                tabPanel("Plot", plotOutput("plot")),
                tabPanel("Summary", verbatimTextOutput("summary")),
                tabPanel("Table", tableOutput("table"))
    )
    #includeMarkdown("Diceware.rmd")
  )
)
# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  
}

shinyApp(ui, server)
