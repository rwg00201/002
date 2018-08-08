library(readxl)


問卷結果<- read_excel("/Users/linjung-chin/Desktop/CS-X資料夾/001/week5/Shiny/002/A/B/001.xlsx")


fluidPage(
  titlePanel("台灣薪資問卷調查結果"),
  
  
  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(3,
           selectInput("性別",
                       "性別",
                       c("All",
                         unique(as.character(問卷結果$性別))))
    ),
    column(3,
           selectInput("畢業學系",
                       "畢業學系",
                       c("All",
                         unique(as.character(問卷結果$畢業學系))))
    ),
    column(3,
           selectInput("工作類別",
                       "工作類別",
                       c("All",
                         unique(as.character(問卷結果$工作類別))))
    ),
    column(3,
           selectInput("薪資狀態",
                       "薪資狀態",
                       c("All",
                         unique(as.character(問卷結果$薪資狀態))))
    
    
  

    
  ),
  # Create a new row for the table.
  fluidRow(
    DT::dataTableOutput("table")
    
  )
  
  
))
