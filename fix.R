library(shiny) 

# Define UI for random distribution application 
shinyUI(pageWithSidebar( 
  
  # Application title 
  headerPanel("Tabsets"), 
  
  # Sidebar with controls to select the random distribution type 
  # and number of observations to generate. Note the use of the br() 
  # element to introduce extra vertical spacing 
  sidebarPanel( 
    tabsetPanel(id='dist',
                tabPanel("Normal", value='norm', textInput("dist1","Xdist1", c("norm"))), 
                tabPanel("Uniform", value='unif', textInput("dist2","Xdist2", c("unif"))), 
                tabPanel("Log-normal", value='lnorm', textInput("dist3","Xdist3", c("lnorm"))), 
                tabPanel("Exponential", value='exp', textInput("dist4","Xdist4", c("exp"))) 
    ), 
    br(), 
    sliderInput("n", 
                "Number of observations:", 
                value = 500, 
                min = 1, 
                max = 1000) 
  ), 
  
  # Show a tabset that includes a plot, summary, and table view 
  # of the generated distribution 
  mainPanel( 
    tabsetPanel( 
      tabPanel("Summary", verbatimTextOutput("summary")), 
      tabPanel("Plot", plotOutput("plot")), 
      tabPanel("Table", tableOutput("table")) 
    ) 
  ) 
)) 