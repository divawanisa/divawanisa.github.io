# FACTORS THAT AFFECT YOUTUBE LIKES NUMBER (

Engineering Management Program can be considered as on of the "youngest" department in Institut Teknologi Bandung, as it was just only been established about 12 years ago.
In order to increase the new department's exposure to public, the department planned to make a Youtube Channel. The department planned to make the channel popular and to 
achieve that goal, it is necessary to identify the factors that influence one of popularity's indicator in Youtube, which is the number of Likes. Hence, estimation models
will be built and selected to identify the most important factors regarding to the number of Likes.

## Data Understanding
Modelling process will be done by using Youtube Indonesia's Trending data from January 2021 until 6th of December 2021. The data will be uploaded first.

```python
data = pd.read_csv('trending.csv', encoding = 'utf8', delimiter = ',')
```
Then, the data will be checked by viewing the first five data, the data types, and the data statistic summary.


From the statistic summary, it can be seen that Thumbnail_width, thumbnail_height, and favorite has 0 value for their standard deviation. This indicates that
these columns only have one value so that these columns won't be used for modelling



