
##以期末報告使用之問卷調查作分析

#導入問卷調查

library(readxl)
library(ggplot2)
library(lattice)
library(survival)
library(Formula)


showtext.auto(enable = TRUE)
font.add("細明體", " 細明體.otf")

da<-read_excel("/Users/linjung-chin/Desktop/CS-X資料夾/001/week4/問卷整理DATA.xlsx")



##觀察問卷結構與基本資料
str(da)
head(da)
summary(da)

#修正圖表底色
問卷內容 <- theme_set(theme_bw())

##分析工作時數與薪水的關係
library(ggplot2)

ggplot(data = da , aes(x = 每日工時, y = 薪資狀態)) +
  geom_boxplot() + coord_flip() +
  labs( y = '薪資狀態', x = '每日工時', 
        title = '工時與薪資關係')

#根據圖表可見月薪65000以上的工作明顯工時較高

#計算其信賴區間
with(da, 
     tapply(薪資狀態, 每日工時,
            function(x) 
              c(mean(x) + c(-2, 2) * sd(x)/sqrt(length(x)))))





##分析工作類別與工時的關係
library(Hmisc)

tapply(da$每日工時, da$工作類別, mean)

ggplot(data = da,  
       aes(x = 工作類別, y = 每日工時 )) +
  stat_summary(fun.data = 'mean_cl_boot', size = 0.5) +
  scale_y_continuous(breaks = seq(1,24, by = 1)) +
  geom_hline(yintercept = mean(da$每日工時) , 
             linetype = 'dotted') +
  labs(x = '工作類別 ', y = '每日工時l') +
  coord_flip()

#由圖表可知行業之間並無大量工時差異

anova(m1 <- lm(每日工時 ~ 工作類別, data = da))
ggplot(data = da, 
       aes(group = 工作類別, 
           y = 每日工時, x = 性別)) +
  geom_point() +
  stat_smooth(method = 'lm', se = F) +
  stat_smooth(aes(group = 工作類別, 
                  y = 每日工時, x = 性別), 
              method = 'lm', se = F) + 
  facet_grid( . ~  工作類別) +
  labs(x = '工作類別', y = '每日工時')

#僅有少數偏離主分布的例外。

#以ANOVA 檢驗假設是否正確
#將性別加入考慮因素

anova(m2 <- update(m1, . ~ . + 
                     性別, data = da))

#可能不是性別造成的，是畢業學系。
anova(m3 <- update(m2, . ~ . - 畢業學系,  data = da))


#判讀兩者的差異
res_lm <- lapply(list(m1, m2, m3), summary)
(res_lm[[2]]$r.sq - res_lm[[3]]$r.sq)/res_lm[[2]]$r.sq
(res_lm[[2]]$r.sq - res_lm[[1]]$r.sq)/res_lm[[1]]$r.sq
anova(m1, m2)


library('coefplot')
m2 <- lm(每日工時 ~ 工作類別+性別- 1, 
         data = da)
coefplot(m2, xlab = '估計值', ylab = '迴歸變項', title = '反應變項 = 每日工時')

#由圖可知加入工作類別／性別後仍無太大差異。

#預測

t1 <- data.frame(da[, c(2, 3, 8)], fitted = fitted(m2), resid = resid(m2),
  
                                   infl = influence(m2)$hat )


ggplot(data = t1, aes(x =da$每日工時, group = 工作類別 )) +
  stat_density(geom = 'path', position = 'identity') +
  stat_density(geom = 'path', position = 'identity', aes(x = fitted)) +
  geom_vline(xintercept = c(with(da, tapply(da$每日工時,da$工作類別, mean))), linetype = 'dotted')+
  facet_grid(工作類別 ~ .) +
  scale_x_continuous(breaks = seq(1, 24, by = 1))+
  labs(x = '工作時數', y = '機率密度')

ggplot(data = t1, aes(x = scale(resid)), group = 工作類別 ) +
  stat_density(geom = 'path', position = 'identity', aes(linetype = 工作類別)) +
  scale_linetype_manual(values = 14:1) +
  guides(linetype = guide_legend(reverse = TRUE)) +
  labs(x = '標準化殘差', y = '機率密度') +
  theme(legend.position = c(.11, .8))

library(lattice)
qqmath(~ scale(resid) | 工作類別, data = t1, type = c('p', 'g', 'r'),
       xlab = '常態位數', ylab = '標準化殘差', layout = c(2, 3),
       pch = '.', cex = 2)


library(MASS)
ggplot(data = t1, aes(x = fitted, y = scale(resid), group = 工作類別 )) +
  geom_point(pch = 20, size = 1) +
  stat_smooth(method = 'rlm', se = F) +
  facet_grid(工作類別 ~ .) +
  labs(x = '件數預測值', y = '標準化殘差')

ggplot(data = t1, aes(x = infl, y = scale(resid), group = 工作類別)) +
  geom_text(aes(label = rownames(t1)), cex = 2) +
  geom_hline(yintercept = 0, linetype = 'dotted') +
  facet_grid(工作類別 ~ .) +
  labs(x = '影響值', y = '標準化殘差')



