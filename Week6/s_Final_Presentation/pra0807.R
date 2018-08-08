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
library(rsconnect)



a<- read_excel("001.xlsx")

job <- read.csv("100_104career_mean1.csv",header = TRUE)
salary <- read.csv("salary.csv",header = TRUE)


# Define UI for application that draws a histogram
ui <- navbarPage("問卷調查與薪水分析",
                 tabPanel("Plot1",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("mean", "平均數-行業別:", 
                                          choices= colnames(job[2:8]) ,
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
                                          choices= colnames(job[9:15]) ,
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
                              selectInput("qa_salary", "問卷調查薪水-行業別:", 
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
                   titlePanel("勞動部職類別 初任人員薪資(起薪)"),
                   
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
                            
                            tabPanel("問卷調查",
                                     fluidRow(
                                       column(3,
                                              selectInput("性別",
                                                          "性別",
                                                          c("All",
                                                            unique(as.character(a$性別))))
                                       ),
                                       column(3,
                                              selectInput("畢業學系",
                                                          "畢業學系",
                                                          c("All",
                                                            unique(as.character(a$畢業學系))))
                                       ),
                                       column(3,
                                              selectInput("工作類別",
                                                          "工作類別",
                                                          c("All",
                                                            unique(as.character(a$工作類別))))
                                       ),
                                       column(3,
                                              selectInput("薪資狀態",
                                                          "薪資狀態",
                                                          c("All",
                                                            unique(as.character(a$薪資狀態))))
                                              
                                              
                                              
                                              
                                              
                                       ),
                                       # Create a new row for the table.
                                       fluidRow(
                                         DT::dataTableOutput("table")
                                         
                                       )
                                       
                                       
                                     )
                                
                            )
                            
                                     )
                 
                 )
                            

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  output$plot <- renderPlot({
    
    barplot(job[,input$mean], 
            main=input$mean,
            names.arg = c("100","101","102","103","104"),
            ylab="count",
            xlab="Year",
            col="pink")
  })
  print("finish render plot 1")
  output$plot2 <- renderPlot({    
    barplot(job[,input$median], 
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
  output$table <- DT::renderDataTable(DT::datatable({
    data <- a
    if (input$性別 != "All") {
      data <- data[a$性別 == input$性別,]
    }
    if (input$畢業學系 != "All") {
      data <- data[a$畢業學系 == input$畢業學系,]
    }
    if (input$工作類別 != "All") {
      data <- data[a$工作類別 == input$工作類別,]
    }
    if (input$ 薪資狀態 != "All") {
      data <- data[a$薪資狀態  == input$薪資狀態 ,]
      
      
    }
    data
  }))
  
}

# Run the application 
shinyApp(ui = ui, server = server)

