install.packages("factoextra")
library("ggplot2")
library("dplyr")
library("ggfortify")
library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering algorithms & visualization


getwd()
setwd("C:/Users/Delll/Documents/R/project")
list.files()
project=read.csv("US_violent_crime.csv")

project=na.omit(project)
str(project)
head(project)
pairs(project[2:3])
z <- project[,-c(1,1)]
means <- apply(z,2,mean)
sds <- apply(z,2,sd)
nor <- scale(z,center=means,scale=sds)
distance = dist(nor)
project.hclust = hclust(distance)


plot(project.hclust)
plot(project.hclust,labels=project$City,main='Default from hclust')
plot(project.hclust,hang=-1, labels=project$City,main='Default from hclust')

project.hclust<-hclust(distance,method="average") 
plot(project.hclust,hang=-1) 

member = cutree(project.hclust,3)
table(member)
member
aggregate(nor,list(member),mean)
aggregate(project[,-c(1,1)],list(member),mean)

library(cluster)
plot(silhouette(cutree(project.hclust,10), distance))

wss <- (nrow(nor)-1)*sum(apply(nor,2,var))
for (i in 2:20) wss[i] <- sum(kmeans(nor, centers=i)$withinss)
plot(1:20, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")
set.seed(123)
kc<-kmeans(nor,2)
kc

ot<-nor
datadistshortset<-dist(ot,method = "euclidean")
hc1 <- hclust(datadistshortset, method = "complete" )
pamvshortset <- pam(datadistshortset,4, diss = FALSE)
clusplot(pamvshortset, shade = FALSE,labels=2,col.clus="blue",col.p="red",span=FALSE,main="Cluster Mapping",cex=1.2)
library(factoextra) 
k2 <- kmeans(nor, centers = 2, nstart = 25)
str(k2)
fviz_cluster(k2, data = nor)
fviz_nbclust(nor, kmeans, method = "wss")
fviz_nbclust(nor, kmeans, method = "silhouette")
gap_stat <- clusGap(nor, FUN = kmeans, nstart = 25,
                    K.max = 10, B = 50)
fviz_gap_stat(gap_stat)
# Visualize


distance <- get_dist(nor)

k2 <- kmeans(nor, centers = 2, nstart = 25)
str(k2)
k2
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

k3 <- kmeans(nor, centers = 3, nstart = 25)
k4 <- kmeans(nor, centers = 4, nstart = 25)
k5 <- kmeans(nor, centers = 5, nstart = 25)

# plots to compare
p1 <- fviz_cluster(k2, geom = "point", data = nor) + ggtitle("k = 2")
p2 <- fviz_cluster(k3, geom = "point",  data = nor) + ggtitle("k = 3")
p3 <- fviz_cluster(k4, geom = "point",  data = nor) + ggtitle("k = 4")
p4 <- fviz_cluster(k5, geom = "point",  data = nor) + ggtitle("k = 5")

grid.arrange(p1, p2, p3, p4, nrow = 2)
set.seed(123)

# function to compute total within-cluster sum of square 
wss <- function(k) {
  kmeans(nor, k, nstart = 10 )$tot.withinss
}

# Compute and plot wss for k = 1 to k = 15
k.values <- 1:15

# extract wss for 2-15 clusters
wss_values <- map_dbl(k.values, wss)

plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares")

set.seed(123)

fviz_nbclust(project, kmeans, method = "wss")

# function to compute average silhouette for k clusters
avg_sil <- function(k) {
  km.res <- kmeans(nor, centers = k, nstart = 25)
  ss <- silhouette(km.res$cluster, dist(nor))
  mean(ss[, 3])
}

# Compute and plot wss for k = 2 to k = 15
k.values <- 2:15

# extract avg silhouette for 2-15 clusters
avg_sil_values <- map_dbl(k.values, avg_sil)

plot(k.values, avg_sil_values,
     type = "b", pch = 19, frame = FALSE, 
     xlab = "Number of clusters K",
     ylab = "Average Silhouettes")

fviz_nbclust(nor, kmeans, method = "silhouette")

# compute gap statistic
set.seed(123)
gap_stat <- clusGap(nor, FUN = kmeans, nstart = 25,
                    K.max = 10, B = 50)
# Print the result
print(gap_stat, method = "firstmax")

fviz_gap_stat(gap_stat)

# Compute k-means clustering with k = 4
set.seed(123)
final <- kmeans(nor, 4, nstart = 25)
print(final)
fviz_cluster(final, data = nor)

summary(project)

