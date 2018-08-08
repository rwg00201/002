library(tm)
library(wordcloud)
library(memoise)
library(readxl)
library(wordcloud)
library(wordcloud2)


test <- read_excel("/Users/linjung-chin/Desktop/CS-X資料夾/001/week5/Shiny/002/A/B/001.xlsx")

test

df= data.frame(test$薪資狀態, test$工作類別)

wordcloud2(df,
           
           size = 1, minSize = 0, gridSize =  0, 
           
           fontFamily = NULL, fontWeight = 'normal',
           
           color = 'random-dark', backgroundColor = "white", 
           
           minRotation = -pi/4, maxRotation = pi/4, rotateRatio = 0.4,  
           
           shape = 'circle', ellipticity = 0.65, widgetsize = NULL) 






# The list of valid books

基本薪資 <<- list("22000-29999",
            "30000-44999")


  # Careful not to let just any name slip in here; a
  # malicious user could manipulate this value.
  if (test[,4]
      %in% c(22000-29999, 30000-44999))
    
return(test[,3])
}


  
  
  
                  
  