fluidPage(
  # Application title
  titlePanel("學系薪資工時產業分析"),
  
  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      selectInput("selection", "基本薪資",
                  choices = 基本薪資),
      actionButton("update", "輸入"),
      hr(),
      sliderInput("freq",
                  "每日平均工時",
                  min = 1,  max = 24, value = 1)
    ),
    
    # Show Word Cloud
    mainPanel(
      plotOutput("plot")
    )
  )
)