#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
library(shiny)
library(ggplot2)
library(readr)
colnames("職業類別")
job <- colnames(firstsalary2)
# Define UI for application that draws a histogram

ui <- fluidPage(
  
  # Application title
  titlePanel("勞動部職類別 初任人員薪資"), 

  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("salary", "行業別",    
                  choices=colnames(First[4:9]),
                  selected = "所有行業"),
      hr(), 
      helpText("Data from 勞動部.")
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("meanPlot")  
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Fill in the spot we created for a plot
  output$meanPlot <- renderPlot({

      # Render a barplot
    barplot(First[,grep(input$salary,c(colnames(First))),1:30],
            main=input$salary,
            ylab="salary",
            xlab="Year",
            col=rainbow(5),
            width = 0.2)
  })
}
# Run the application 
shinyApp(ui = ui, server = server)
