#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)
library(DT)
library(datasets)
library(ggplot2)
library(dplyr)
library(readr)
Mean <- read.csv("data_w6/100_104career_mean1.csv",header = TRUE)

# Define UI for application that draws a histogram
ui <- navbarPage("Salary",
                 tabPanel("Plot",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("cate", "行業別:", 
                                          choices= colnames(Mean[2:8]) ,
                                          selected = "所有行業") ,
                              radioButtons("plotType", "Plot type",
                                           c("Scatter"="p", "Line"="l")
                                         
                              )
                            ),
                            mainPanel(
                              plotOutput("plot")
                            )
                          )
                 ),
                 tabPanel("Summary",
                          verbatimTextOutput("summary")
                 ),
                 navbarMenu("More",
                            tabPanel("Table",
                                     DT::dataTableOutput("table")
                            ),
                            tabPanel("About",
                                     fluidRow(
                                       column(6,
                                              includeMarkdown("about.md")
                                       ),
                                       column(3,
                                              img(class="img-polaroid",
                                                  src=paste0("http://upload.wikimedia.org/",
                                                             "wikipedia/commons/9/92/",
                                                             "1919_Ford_Model_T_Highboy_Coupe.jpg")),
                                              tags$small(
                                                "Source: Photographed at the Bay State Antique ",
                                                "Automobile Club's July 10, 2005 show at the ",
                                                "Endicott Estate in Dedham, MA by ",
                                                a(href="http://commons.wikimedia.org/wiki/User:Sfoskett",
                                                  "User:Sfoskett")
                                              )
                                       )
                                     )
                            )
                 )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  output$plot <- renderPlot({
    plot(Mean[,input$plotType], type=input$plotType,names.arg = c("100","101","102","103","104"))
  })
  
  output$summary <- renderPrint({
    summary(cars)
  })
  
  output$table <- DT::renderDataTable({
    DT::datatable(cars)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

