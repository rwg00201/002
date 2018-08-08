iris
ggplot(data = iris, aes(x = Petal.Width)) +
  geom_bar(fill = "red", colour = "black")

ggplot(data = iris)+geom_point(aes(x=Species, y=Petal.Width, color=Petal.Length))

ggplot(data = iris, aes(Sepal.Length, fill=Species))+geom_bar(Sepal.Width="fill")

ggplot(iris, aes(x = Species, y=Petal.Width))+geom_boxplot(fill = "red", colour = "black")

