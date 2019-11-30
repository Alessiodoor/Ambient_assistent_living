#Valutazioni modelli post oversampling delle due classi di minoranza oppure solo di sitting down, in base al file 
library(bnlearn)

#MyData <- read.csv(file = "Data_discrete_10_over_sitting_down.csv", header = TRUE, sep = ";")
MyData <- read.csv(file = "Data_discrete_10_overEntrambe.csv", header = TRUE, sep = ";")

randomind = sample(nrow(MyData))
dataset <- MyData[randomind, ] 

dataset$x1 = factor(dataset$x1)
dataset$x2 = factor(dataset$x2)
dataset$x3 = factor(dataset$x3)
dataset$x4 = factor(dataset$x4)
dataset$y1 = factor(dataset$y1)
dataset$y2 = factor(dataset$y2)
dataset$y3 = factor(dataset$y3)
dataset$y4 = factor(dataset$y4)
dataset$z1 = factor(dataset$z1)
dataset$z2 = factor(dataset$z2)
dataset$z3 = factor(dataset$z3)
dataset$z4 = factor(dataset$z4)

induced_model = tabu(dataset, score = "k2")

folds <- cut(1 : nrow(dataset), breaks = 10, labels = F)

precisionSitting = c()
precisionStanding = c()
precisionWaliking = c()
precisionSittingdown = c()
precisionStandingup = c()

recallSitting = c()
recallStanding = c()
recallWaliking = c()
recallSittingdown = c()
recallStandingup = c()

induced_accuracy = c()
induced_precision = c()
induced_recall = c()
induced_fmeasure = c()

for(k in 1 : 10){
  print(k)
  
  #discreto
  trainset = dataset[folds != k, ]
  testset = dataset[folds == k, ]
  testset_cropped = testset
  testset_cropped$class = NULL
  
  
  #performance evaluation induced discreto
  

  induced_fit = bn.fit(induced_model, trainset, method = "bayes")
  
  induced_prediction = predict(induced_fit, "class", testset_cropped, method = "bayes-lw")
  confusion.matrix = table(testset$class, induced_prediction)
  print(confusion.matrix)
  accuracy = sum(diag(confusion.matrix)) / sum(confusion.matrix)
  induced_accuracy = append(accuracy, induced_accuracy)
  
  precision = 0
  recall = 0
  for (i in 1 : 5){
    precision = precision + (confusion.matrix[i,i] / sum(confusion.matrix[, i]))
    recall = recall + (confusion.matrix[i,i] / sum(confusion.matrix[i, ]))
  }
  
  #sitting sittingdown standing standingup walking
  precisionSitting = append(confusion.matrix[1,1] / sum(confusion.matrix[, 1]), precisionSitting )
  precisionSittingdown = append(confusion.matrix[2,2] / sum(confusion.matrix[, 2]), precisionSittingdown)
  precisionStanding = append(confusion.matrix[3,3] / sum(confusion.matrix[, 3]), precisionStanding)
  precisionStandingup = append(confusion.matrix[4,4] / sum(confusion.matrix[, 4]), precisionStandingup)
  precisionWaliking = append(confusion.matrix[5,5] / sum(confusion.matrix[, 5]), precisionWaliking)
  
  
  recallSitting = append(confusion.matrix[1,1] / sum(confusion.matrix[1, ]), recallSitting)
  recallSittingdown = append(confusion.matrix[2,2] / sum(confusion.matrix[2, ]), recallSittingdown)
  recallStanding = append(confusion.matrix[3,3] / sum(confusion.matrix[3, ]), recallStanding)
  recallStandingup = append(confusion.matrix[4,4] / sum(confusion.matrix[4, ]), recallStandingup)
  recallWaliking = append(confusion.matrix[5,5] / sum(confusion.matrix[5, ]), recallWaliking)
  
  
  precision = precision / 5
  recall = recall / 5
  induced_precision = append(precision, induced_precision)
  induced_recall = append(recall, induced_recall)
  f1measure = 2 * (precision * recall / (precision + recall))
  induced_fmeasure = append(f1measure, induced_fmeasure)
  
}


print(induced_accuracy)
print(induced_precision)
print(induced_recall)
print(induced_fmeasure)

print(precisionSitting)
print(precisionStanding)
print(precisionWaliking)
print(precisionSittingdown) 
print(precisionStandingup) 

print(recallSitting) 
print(recallStanding) 
print(recallWaliking)
print(recallSittingdown) 
print(recallStandingup) 

pdf("induced_performance_post.pdf", width = 8, height = 8)
# boxplot delle misure di performance
par(mfrow=c(2, 2))
boxplot(induced_accuracy, main = "Accuracy")
boxplot(induced_precision, main = "Precision")
boxplot(induced_recall, main = "Recall")
boxplot(induced_fmeasure, main = "F1Measure")
dev.off()
