################################################################# SETUP ################################################################# 
#imports
library(class)
library(caret)
library(party)
library(randomForest)
library(rfUtilities)

##### fuctions:
#normalization
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

#entropy ?
entropy <- function(S) { # Function to calculate entropy as in the slides
  fullSum <- 0
  for( i in (0:9) ) { 
    if( nrow(S) > 0 ) # Make sure that there is something in the list
    { pi <- nrow(S[ S[,1] == i , ]) / nrow(S) }else{pi <- 0} 
    if(pi > 0 ){
      fullSum <- fullSum - pi * log2(pi)
    }
  }
  return(fullSum)
}


##### setting up data
load("idList-FinalExam.Rdata")

set.seed(423)

# test data 1 (train)
idt1 <- do.call(rbind, idList[1:2])
idt1 <- as.data.frame(idt1)
idt1[,1] <- factor(idt1[,1])
idt1_shuf <- idt1[sample(nrow(idt1)),] 
idt1_norm <- as.data.frame(lapply(idt1_shuf[-1], normalize))
idt1_pca <- prcomp(idt1_norm, center = TRUE, scale. = TRUE)
idt1_eigs <- idt1_pca$sdev^2
idt1_Proportion = idt1_eigs/sum(idt1_eigs)
idt1_reduced <- idt1_pca$x[,cumsum(idt1_Proportion) < 0.99]
idt1_reduced <- as.data.frame(idt1_reduced)


# test data 2 (test)
idt2 <- do.call(rbind, idList[3:4])
idt2 <- as.data.frame(idt2)
idt2[,1] <- factor(idt2[,1])
idt2_shuf <- idt2[sample(nrow(idt2)),] 
idt2_norm <- as.data.frame(lapply(idt2_shuf[-1], normalize))
idt2_pca <- predict(idt1_pca,idt2_norm)
idt2_reduced <- idt2_pca[,1:ncol(idt1_reduced)]
idt2_reduced <- as.data.frame(idt2_reduced)

# test data 3 (train)
idt3 <- do.call(rbind, idList[1:5])
idt3 <- as.data.frame(idt3)
idt3[,1] <- factor(idt3[,1])
idt3_shuf <- idt3[sample(nrow(idt3)),] 
idt3_norm <- as.data.frame(lapply(idt3_shuf[-1], normalize))
idt3_pca <- prcomp(idt3_norm, center = TRUE, scale. = TRUE)
idt3_eigs <- idt3_pca$sdev^2
idt3_Proportion = idt3_eigs/sum(idt3_eigs)
idt3_reduced <- idt3_pca$x[,cumsum(idt3_Proportion) < 0.99]
idt3_reduced <- as.data.frame(idt3_reduced)

# test data 4 (train)
id_full <- do.call(rbind, idList)
id_full <- as.data.frame(id_full)
id_full[,1] <- factor(id_full[,1])
id_full_shuf <- id_full[sample(nrow(id_full)),] 
id_full_norm <- as.data.frame(lapply(id_full_shuf[-1], normalize))
id_full_pca <- prcomp(id_full_norm, center = TRUE, scale. = TRUE)
id_full_eigs <- id_full_pca$sdev^2
id_full_Proportion = id_full_eigs/sum(id_full_eigs)
id_full_reduced <- id_full_pca$x[,cumsum(id_full_Proportion) < 0.99]
id_full_reduced <- as.data.frame(id_full_reduced)

################################################################# KNN ################################################################# 
# single test
train_labels <- idt1_shuf[,1]
test_labels <- idt2_shuf[,1]

test_pred <- knn(train = idt1_reduced, test = idt2_reduced, cl = train_labels, k=10)

cf <- confusionMatrix(test_labels, test_pred)
print( sum(diag(cf$table))/sum(cf$table) )



#k experiments (train = 90% id_full  test = 10% id_full)
#k <- round(sqrt(nrow(id_full_shuf)), digits = 0)
train_bestk <- id_full_reduced[1:(nrow(id_full_reduced)/10 *9),]
test_bestk <- id_full_reduced[((nrow(id_full_reduced)/10 *9) + 1) : nrow(id_full_reduced),]

train_labels <- id_full_shuf[1:(nrow(id_full_reduced)/10 *9), 1]
test_labels <- id_full_shuf[((nrow(id_full_reduced)/10 *9) + 1) : nrow(id_full_reduced),1]

#values <- seq.int(min(1), max(200), length.out= 100)
values <- c(3, 77, 167, 203, 277, 327, 415)
result <-c(1:length(values))
kvalues <- c(1:length(values))
for(i in 1:length(values)){
  print(i)
  print(length(values))
  
  test_pred <- knn(train = train_bestk, test = test_bestk, cl = train_labels, k=values[i])
  
  cf <- confusionMatrix(test_labels, test_pred)
  result[i]<-( sum(diag(cf$table))/sum(cf$table) )
  kvalues[i] <- values[i]
}
plot(kvalues, result)



#Cross validation (dataset = id_full)
folds <- createFolds(id_full_shuf[,1], k=10)
listOfFolders <- c(1:10)
k <- round(sqrt(nrow(id_full_shuf)), digits = 0)

total_time <- c(1:10)
for(i in 1:10){
  train <- id_full_reduced[-folds[[i]],]
  test <- id_full_reduced[folds[[i]],]
  
  train_labels <- id_full_shuf[-folds[[i]],1]
  test_labels <- id_full_shuf[folds[[i]],1]
  
  start_time <- proc.time()
  test_pred <- knn(train =train, test = test, cl = train_labels, k=k)
  iteration_time <- proc.time() - start_time
  
  total_time[i] <- iteration_time[3]
  
  cf <- confusionMatrix(test_labels, test_pred)
  listOfFolders[i] <- sum(diag(cf$table))/sum(cf$table)
}
print(total_time)
mean(total_time)
sd(total_time)

print(listOfFolders)
mean(listOfFolders)
var(listOfFolders)


################################################################# Random Forest ################################################################# 

#setup data  (data = idt3)
train_with_result <- cbind(number=idt3_shuf[,1], idt3_reduced)
train_with_result[,1] <-factor(train_with_result[,1])

#create forest
model.randomForest <- randomForest(number ~ ., data = train_with_result, ntree = 20)

##### albow test with testdata (test = id_full)
train_with_result <- cbind(number=id_full_shuf[,1], id_full_reduced)
train_with_result[,1] <-factor(train_with_result[,1])

albow_train <- train_with_result[1:(nrow(train_with_result)/10 *9),]
albow_test <-  train_with_result[((nrow(train_with_result)/10 *9) + 1) : nrow(train_with_result),]

model.randomForest <- randomForest(number ~ ., data = albow_train, ntree = 100)

p <- predict(model.randomForest, albow_test)

cf <- confusionMatrix(albow_test[,1], p)
print( sum(diag(cf$table))/sum(cf$table) )
plot(model.randomForest)

#####Cross validation (dataset = id_full)

#setup data
train_with_result <- cbind(number=id_full_shuf[,1], id_full_reduced)
train_with_result[,1] <-factor(train_with_result[,1])

#create folds
folds <- createFolds(id_id_full[,1], k=10)
listOfFolders <- c(1:10)
total_time <- c(1:10)

for(i in 1:10){
  train <- train_with_result[-folds[[i]],]
  test <- train_with_result[folds[[i]],]

  start_time <- proc.time()
  #create forest
  model.randomForest <- randomForest(number ~ ., data = train, ntree = 20)
  
  #test forest
  p <- predict(model.randomForest, test)
  
  iteration_time <- proc.time() - start_time
  total_time[i] <- iteration_time[3]
  
  cf <- confusionMatrix(test[,1], p)
  listOfFolders[i] <- sum(diag(cf$table))/sum(cf$table)
}
print(total_time)
mean(total_time)
sd(total_time)

print(listOfFolders)
mean(listOfFolders)
sd(listOfFolders)


###### alt 10-fold cross validation
model.cv <- rf.crossValidation(x = model.randomForest, xdata = train_with_result, p = 0.1, n = 10, trace = TRUE) 

# Plot cross validation verses model producers accuracy
par(mfrow=c(1,2)) 
plot(model.cv, type = "cv", main = "CV producers accuracy")
plot(model.cv, type = "model", main = "Model producers accuracy")

# Plot cross validation verses model oob
par(mfrow=c(1,2)) 
plot(model.cv, type = "cv", stat = "oob", main = "CV oob error")
plot(model.cv, type = "model", stat = "oob", main = "Model oob error")
