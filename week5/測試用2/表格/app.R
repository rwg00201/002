library(shiny)
library(ggplot2)  # for the diamonds dataset
library(readxl)
library("DT")


問卷結果 <- read_excel("/Users/linjung-chin/Desktop/CS-X資料夾/001/week5/Shiny/002/A/B/001.xlsx")


ui <- fluidPage(
  title = "台灣目前職業薪資問卷",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "問卷結果"',
        checkboxGroupInput("show_vars", "因素",
                           names(問卷結果), 
                           selected = names(問卷結果),
                           inline = FALSE,
                           width = NULL)
      )
  
    ),
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("問卷結果", DT::dataTableOutput("mytable1"))
      )
    )
  )
)

server <- function(input, output) {
  
  diamonds2 = 問卷結果[sample(nrow(問卷結果), replace = T ,39), ]
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(diamonds2[, input$show_vars, drop = FALSE])
  })
  
  

  
  

  
}

shinyApp(ui, server)