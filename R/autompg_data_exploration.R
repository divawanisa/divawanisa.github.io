library(dplyr)
library(ggplot2)
library(DataExplorer)

#Upload data frame
auto
auto <- read.table(file.choose())
colnames(auto) <- c('mpg','cyl', 'dis', 'hp','tor', 'wt', 'acc', 'my', 'or', 'name')
colnames(auto)

#NOMOR 1 - DATA CLEANING
#Melihat bentuk data
head(auto)
colSums(is.na(auto))
str(auto)
unique(auto2$hp) #melihat isi data kolom hp
auto2 <- auto %>% replace(.== '?', NA)
unique(auto3$wt) #melihat isi data kolom wt
auto3 <- auto2 %>% replace(.== '?.', NA)
str(auto3)

auto4<- transform(auto3, hp = as.numeric(hp))
str(auto4)
auto5<- transform(auto4, wt = as.numeric(wt))
str(auto5)
auto6<- transform(auto5, or = as.factor(or))
colSums(is.na(auto6))
plot_missing(auto6)

autompg<-na.omit(auto6)
colSums(is.na(autompg))
sum(duplicated(autompg))
autompg$wt

#NOMOR 2 - DENSITY PLOT FOR RESPONSE VARIABLES
vis_mpg <- ggplot(data=autompg, aes(x=mpg))+
  geom_density()
vis_mpg2<- vis_mpg + labs(title = 'MPG Density Plot')
vis_mpg2

#NOMOR 3 - QQPLOT FOR EVERY COUNTRY
no <-autompg
colnames(no) <- c('mpg','cyl', 'dis', 'hp', 'wt', 'acc', 'my', 'Country', 'name')
levels(no$Country) <- c('USA', 'Europe', 'Japan')

plot_mpg <- ggplot(no, aes(sample = mpg, colour = Country)) +
  stat_qq()
plot_mpg1 <- plot_mpg + labs(title = 'QQ Plot for MPG', fill = 'Country')
plot_mpg2
