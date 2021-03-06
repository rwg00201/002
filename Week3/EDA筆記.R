##Data來源：https://www.kaggle.com/mrisdal/exploring-survival-on-the-titanic/notebook

##載入pakages

library('ggplot2') 
library('ggthemes') 
library('scales')
library('dplyr') 
library('mice') 
library('randomForest') 


##載入資料

train <- read.csv('/Users/linjung-chin/Desktop/CS-X資料夾/001/week3/Data/all/train.csv', stringsAsFactors = F)
test  <- read.csv('/Users/linjung-chin/Desktop/CS-X資料夾/001/week3/Data/all/train.csv', stringsAsFactors = F)

##結合兩筆資料並檢查

full <- bind_rows(train, test)
str(full)


##分類稱謂

full$Title <- gsub('(.*, )|(\\..*)', '', full$Name)
table(full$Sex, full$Title)



##辨識稀有姓

rare_title <- c('Dona', 'Lady', 'the Countess','Capt', 'Col', 'Don', 
                'Dr', 'Major', 'Rev', 'Sir', 'Jonkheer')
full$Title[full$Title == 'Mlle']        <- 'Miss' 
full$Title[full$Title == 'Ms']          <- 'Miss'
full$Title[full$Title == 'Mme']         <- 'Mrs' 
full$Title[full$Title %in% rare_title]  <- 'Rare Title'
table(full$Sex, full$Title)

##從乘客姓名中取名
full$Surname <- sapply(full$Name,  
                       function(x) strsplit(x, split = '[,.]')[[1]][1])

##分類乘客家人數量＆賦予姓氏
full$Fsize <- full$SibSp + full$Parch + 1
full$Family <- paste(full$Surname, full$Fsize, sep='_')


##運用圖表觀察家人數與生存關係
ggplot(full[1:891,], aes(x = Fsize, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:11)) +
  labs(x = 'Family Size') +
  theme_few()


##以生還狀況繪製馬賽克圖
full$FsizeD[full$Fsize == 1] <- 'singleton'
full$FsizeD[full$Fsize < 5 & full$Fsize > 1] <- 'small'
full$FsizeD[full$Fsize > 4] <- 'large'

mosaicplot(table(full$FsizeD, full$Survived), main='Family Size by Survival', shade=TRUE)


#結論：人數<4的家庭生存率最高


##計算位置與生存的可能關係
full$Cabin[1:28]
strsplit(full$Cabin[2], NULL)[[1]]
full$Deck<-factor(sapply(full$Cabin, function(x) strsplit(x, NULL)[[1]][1]))



##確認未登船狀況
full[c(62, 830), 'Embarked']
cat(paste('We will infer their values for **embarkment** based on present data that we can imagine may be relevant: **passenger class** and **fare**. We see that they paid<b> $', full[c(62, 830), 'Fare'][[1]][1], '</b>and<b> $', full[c(62, 830), 'Fare'][[1]][2], '</b>respectively and their classes are<b>', full[c(62, 830), 'Pclass'][[1]][1], '</b>and<b>', full[c(62, 830), 'Pclass'][[1]][2], '</b>. So from where did they embark?'))


##以成客艙與費用繪製登船價值分析
embark_fare <- full %>%
  filter(PassengerId != 62 & PassengerId != 830)

ggplot(embark_fare, aes(x = Embarked, y = Fare, fill = factor(Pclass))) +
  geom_boxplot() +
  geom_hline(aes(yintercept=80), 
             colour='red', linetype='dashed', lwd=2) +
  scale_y_continuous(labels=dollar_format()) +
  theme_few()

#結論：NA可以替換Ｃ，他們的票價為80美元即可能從C出發。

full$Embarked[c(62, 830)] <- 'C'
full[1044, ]
ggplot(full[full$Pclass == '3' & full$Embarked == 'S', ], 
       aes(x = Fare)) +
  geom_density(fill = '#99d6ff', alpha=0.4) + 
  geom_vline(aes(xintercept=median(Fare, na.rm=T)),
             colour='red', linetype='dashed', lwd=1) +
  scale_x_continuous(labels=dollar_format()) +
  theme_few()

#結論：用票價取代乘客中位數可能是合理的。
