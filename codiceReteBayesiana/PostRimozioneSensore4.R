#Valutazioni modelli post rimozione del sensore 4, relativo al braccio
library(bnlearn)

MyData <- read.csv(file = "Data_discrete_10_post4.csv", header = TRUE, sep = ";")
randomind = sample(nrow(MyData))
dataset <- MyData[randomind, ] 

dataset$x1 = factor(dataset$x1)
dataset$x2 = factor(dataset$x2)
dataset$x3 = factor(dataset$x3)
dataset$y1 = factor(dataset$y1)
dataset$y2 = factor(dataset$y2)
dataset$y3 = factor(dataset$y3)
dataset$z1 = factor(dataset$z1)
dataset$z2 = factor(dataset$z2)
dataset$z3 = factor(dataset$z3)

folds <- cut(1 : nrow(dataset), breaks = 10, labels = F)

# creazione del nostro modello
our_model = model2network("[y2][z2][class|z2:y2][x1|class][x2|class][x3|class][y3|y2:class][y1|y2:y3:class][z1|z2:class][z3|z1:z2:class]")
graphviz.plot(our_model, main = "")
print(our_model)

induced_model = tabu(dataset, score = "k2")
print(induced_model)
graphviz.plot(induced_model, main = "")


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

our_accuracy = c()
our_precision = c()
our_recall = c()
our_fmeasure = c()


induced_accuracy = c()
induced_precision = c()
induced_recall = c()
induced_fmeasure = c()


# performing 10-fold cv
for(k in 1 : 10){
  print(k)
  
  #discreto
  trainset = dataset[folds != k, ]
  testset = dataset[folds == k, ]
  testset_cropped = testset
  testset_cropped$class = NULL
  
  
  #discreto
  our_fit = bn.fit(our_model, trainset, method = "bayes")
  
  #method bayes perchè il metodo mle produce dei NA
  induced_fit = bn.fit(induced_model, trainset, method = "bayes")
  
  
  #Preedizione
  our_prediction = predict(our_fit, "class", testset_cropped, method = "bayes-lw")
  
  
  induced_prediction = predict(induced_fit, "class", testset_cropped, method = "bayes-lw")
  
  
  #performance evaluation our
  confusion.matrix = table(testset$class, our_prediction)
  print(confusion.matrix)
  accuracy = sum(diag(confusion.matrix)) / sum(confusion.matrix)
  our_accuracy = append(accuracy, our_accuracy)
  
  precision = 0
  recall = 0
  for (i in 1 : 5){
    precision = precision + (confusion.matrix[i,i] / sum(confusion.matrix[, i]))
    recall = recall + (confusion.matrix[i,i] / sum(confusion.matrix[i, ]))
    
  }
  precision = precision / 5
  recall = recall / 5
  our_precision = append(precision, our_precision)
  our_recall = append(recall, our_recall)
  f1measure = 2 * (precision * recall / (precision + recall))
  our_fmeasure = append(f1measure, our_fmeasure)
  
  
  #performance evaluation induced discreto
  
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

print(our_accuracy)
print(our_precision)
print(our_recall)
print(our_fmeasure)  


print(induced_accuracy)
print(induced_precision)
print(induced_recall)
print(induced_fmeasure)


# Performance plot
pdf("our_performance_4.pdf", width = 8, height = 8)
# boxplot delle misure di performance
par(mfrow=c(2, 2))
boxplot(our_accuracy, main = "Accuracy")
boxplot(our_precision, main = "Precision")
boxplot(our_recall, main = "Recall")
boxplot(our_fmeasure, main = "F1Measure")
dev.off()

pdf("induced_performance_4.pdf", width = 8, height = 8)
# boxplot delle misure di performance
par(mfrow=c(2, 2))
boxplot(induced_accuracy, main = "Accuracy")
boxplot(induced_precision, main = "Precision")
boxplot(induced_recall, main = "Recall")
boxplot(induced_fmeasure, main = "F1Measure")
dev.off()


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





