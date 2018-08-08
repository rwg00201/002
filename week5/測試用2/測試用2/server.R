library(ggplot2)
library(readxl)


問卷結果<- read_excel("/Users/linjung-chin/Desktop/CS-X資料夾/001/week5/Shiny/002/A/B/001.xlsx")




function(input, output, session) {
  
  # Filter data based on selections
  output$table <- DT::renderDataTable(DT::datatable({
    data <- 問卷結果
    if (input$性別 != "All") {
      data <- data[問卷結果$性別 == input$性別,]
    }
    if (input$畢業學系 != "All") {
      data <- data[問卷結果$畢業學系 == input$畢業學系,]
    }
    if (input$工作類別 != "All") {
      data <- data[問卷結果$工作類別 == input$工作類別,]
    }
    if (input$ 薪資狀態 != "All") {
      data <- data[問卷結果$薪資狀態  == input$薪資狀態 ,]


    }
    data
  }))
  
}