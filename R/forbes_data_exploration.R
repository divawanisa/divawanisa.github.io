#Packages
library(dplyr) #buat manipulasi data frame/tabel
library(DataExplorer) #buat bikin grafik missing value
library(ggplot2) #visualisasi

#Upload data set
forbes <-read.csv(file.choose())

#Lihat data
head(forbes)
str(forbes)
nrow(forbes)
colSums(is.na(forbes))
plot_missing(forbes)

#Menghilangkan row yang memiliki data yg hilang
forbes2<-na.omit(forbes) 
colSums(is.na(forbes2))
nrow(forbes2)
head(forbes2)

#1 MEDIAN FOR PROFITS IN US COMPANIES
#Filtering data
forbes_us <- filter(forbes2, country == 'United States')

#Mencari median
median_us <- median(forbes_us$profits)
median_us

#1 MEDIAN FOR PROFITS IN UK, FRANCE, AND GERMAN COMPANIES 
#Filtering data
forbes_eu<- filter(forbes2, country == 'United Kingdom'| country == 'France' |country == 'Germany')

#Mencari Median
median_eu <- median(forbes_eu$profits)
median_eu

#2 PROFIT NEGATIF JERMAN
neg_profit <- filter(forbes2, country == "Germany" & profits < 0)
neg_profit$name

#3 MOST FREQUENT CATEGORIES IN BERMUDA ISLAND
bermuda <-  filter(forbes2, country=="Bermuda")
bermuda2 <- bermuda %>% group_by(category) %>% summarise(count = n()) %>%
  arrange(desc(count))
bermuda2

#4 FORBES TOP 20
forbes20 <- forbes2 %>% arrange(desc(profits)) %>% slice_head(n=20)
head(forbes20)

#visualisasi
library(ggrepel)
vis_forbes20 <- ggplot(data=forbes20,aes(x=sales, y=assets, color = country))+geom_jitter()+
  geom_label_repel(aes(label=abbreviate(country,2)), size=3)+
  theme(plot.title = element_text(hjust = 0.5))
print(vis_forbes20+ labs(title = "Assets vs Sales", x = 'Assets', y ='Sales'))


#5 AVERAGE SALES AND NUMBER OF COMPANIES WITH SALES NUMBER ABOVE 5 MIL DOLLARS
avg_sales <- forbes2%>% group_by(country)%>%summarise(mean(sales))
avglagi <-forbes2%>% filter(profits>5)%>%group_by(country)%>%summarise(count=n()) %>% arrange(desc(count))
avglagi
