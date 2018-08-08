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
library(ggplot2)
library(dplyr)
library(readr)
library(readxl)


問卷結果<- read_excel("/Users/linjung-chin/Desktop/CS-X資料夾/001/week5/Shiny/002/A/B/001.xlsx")

all <- read.csv("/Users/linjung-chin/Desktop/CS-X資料夾/001/week5/Shiny/002/A/B/100_104career_mean1.csv",header = TRUE)
salary <- read.csv("/Users/linjung-chin/Desktop/CS-X資料夾/001/week5/Shiny/002/A/B/salary.csv",header = TRUE)
qa<-

# Define UI for application that draws a histogram
ui <- navbarPage("Salary",
                 tabPanel("Plot1",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("mean", "平均數-行業別:", 
                                          choices= colnames(all[2:8]) ,
                                          selected = "所有行業"),
                              hr(),
                              helpText("資料來源:財政部統計處")
                            ),
                            mainPanel(
                              plotOutput("plot")
                            )
                          ),
                 
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("median", "中位數-行業別:", 
                                          choices= colnames(all[9:15]) ,
                                          selected = "所有行業"), 
                              hr(),
                              helpText("資料來源:財政部統計處")
                            ),
                            mainPanel(
                              plotOutput("plot2")
                            )
                          ),
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("qa_salary", "薪水-行業別:", 
                                          choices= colnames(salary[2:15]) ,
                                          selected = "所有行業"),
                              hr(),
                              helpText("資料來源:問卷調查")
                            ),
                            mainPanel(
                              plotOutput("plot3")
                            )
                          )
                          
                 ),
                 tabPanel(
                   "Plot2",
                   titlePanel("勞動部職類別 初任人員薪資"),
                   
                   # Sidebar with a slider input for number of bins
                   sidebarLayout(
                     sidebarPanel(
                       selectInput(
                         "salary1",
                         "行業別",
                         choices = colnames(First[4:9]),
                         selected = "所有行業"
                       ),
                       hr(),
                       helpText("Data from 勞動部.")
                     ),
                     # Show a plot of the generated distribution
                     mainPanel(plotOutput("meanPlot"))
                   )
                 ), 
                 
                 
                 navbarMenu("More",
                            tabPanel("100~104行業平均數與中位數",
                                     DT::dataTableOutput("table1")
                            ),
                            hr(),
                            helpText("備註:平為平均數,中為中位數;資料來源:財政部統計處"),
                            
                            tabPanel("問卷調查",
                                     DT::dataTableOutput("table")
                            )
                            
                                     )
                 
                 )
                            

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  output$plot <- renderPlot({
    
    barplot(all[,input$mean], 
            main=input$mean,
            names.arg = c("100","101","102","103","104"),
            ylab="count",
            xlab="Year",
            col="pink")
  })
  print("finish render plot 1")
  output$plot2 <- renderPlot({    
    barplot(all[,input$median], 
            main=input$median,
            names.arg = c("100","101","102","103","104"),
            ylab="count",
            xlab="Year",
            col="skyblue")
  })
  
  output$plot3 <- renderPlot({    
    barplot(salary[,input$qa_salary], 
            main=input$qa_salary,
            names.arg =c("22000-29999","30000-44999","45000-54999","55000-64999","65000以上"),
            ylab="人數",
            xlab="薪水級別",
            col="yellow")
  })
  
  output$meanPlot <- renderPlot({
    
    # Render a barplot
    barplot(First[,grep(input$salary1,c(colnames(First))),1:30],
            main=input$salary1,
            ylab="salary",
            xlab="Year",
            col=rainbow(5),
            width = 0.2)
  })
  
  output$table1 <- DT::renderDataTable({
    DT::datatable(all)
  })
  output$table <- DT::renderDataTable({
    DT::datatable()
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

