# hkrug_tm

Hong Kong R User Group Pre-hackathon workshop on Text Mining.

This pre-hackathon is designed for those who want to get their hands dirty to build something. This is not a chit-chat session (in cantonese 吹水). YOU NEED TO CODE DURING THE WORKSHOP.

# prerequsite

You need to know some R and basic stats (regression and clustering analysis). You need to know what is going on with the following two R-snippnets.

```{r}
#R-code snippet 1
require(MASS); summary(glm(as.factor(vs)~mpg+cyl, data=mtcars, family=binomial)) ; predict(glm(as.factor(vs)~mpg+cyl, data=mtcars, family=binomial), mtcars)
#R-code snippet 2
kmeans(iris[,1:4], 3)
kmeans(iris[,1:4], 3)$cluster
table(kmeans(iris[,1:4], 3)$cluster, iris[,5])
```

# preparation

You should be running R > 3.0 and your preferred editor. (RStudio/emacs/vim/sublime) Please install the required R packages

```{r}
install.packages(c("tm", "stringr", "plyr", "topicmodels", "snowballC", "magrittr", "klaR"))
```

