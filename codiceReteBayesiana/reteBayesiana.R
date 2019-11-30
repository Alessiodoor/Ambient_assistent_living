library(bnlearn)

#lettura dataset discreto
MyData <- read.csv(file = "Data_discrete_10.csv", header = TRUE, sep = ";")

#ordinamento casuale
randomind = sample(nrow(MyData))
dataset <- MyData[randomind, ] 

#rendere factor i numeri da 1 a 10
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

#lettura dataset continuo e ordinato come il dataset discreto per fare confronti su stessi fold
MyData <- read.csv(file = "dataset.csv", header = TRUE, sep = ";")
dataset2 <- MyData[randomind, ] 

#creazione di 10 fold per cross validation
folds <- cut(1 : nrow(dataset), breaks = 10, labels = F)

# creazione del nostro modello
our_model = model2network("[class][x1|class][y1|class][z1|class][x3|class][y3|class][z3|class][x2|class:x1:x3][y2|class:y1:y3][z2|class:z1:z3][x4|class][y4|class][z4|class]")

our_model_cont = model2network("[class][x1|class][y1|class][z1|class][x3|class][y3|class][z3|class][x2|class:x1:x3][y2|class:y1:y3][z2|class:z1:z3][x4|class][y4|class][z4|class]")

graphviz.plot(our_model, main = "")
print(our_model)

graphviz.plot(our_model_cont, main = "La nostra rete bayesiana continua")
print(our_model_cont)

induced_model = tabu(dataset, score = "k2")
print(induced_model)
graphviz.plot(induced_model, main = "La rete bayesiana indotta dai dati discretizzati")


#induzione del modello ibrido dai dati continui
dataset3 = dataset2[, 5:17]
dataset3[] <- lapply(dataset3[, 1:12], as.numeric)
dataset3$class = dataset$class

induced_model_cont = tabu(dataset3, score = "bic-cg")
print(induced_model_cont)
graphviz.plot(induced_model_cont, main = "La rete bayesiana indotta dai dati")

#vettori per le performance
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

our_accuracy_cont = c()
our_precision_cont = c()
our_recall_cont = c()
our_fmeasure_cont = c()
  
induced_accuracy = c()
induced_precision = c()
induced_recall = c()
induced_fmeasure = c()

induced_accuracy_cont = c()
induced_precision_cont = c()
induced_recall_cont = c()
induced_fmeasure_cont = c()
  

# performing 10-fold cv
for(k in 1 : 10){
    print(k)
    #testIndexes <- which(folds==k,arr.ind=TRUE)
    
    #discreto
    trainset = dataset[folds != k, ]
    testset = dataset[folds == k, ]
    testset_cropped = testset
    testset_cropped$class = NULL
    
    #continui
    trainset2 = dataset3[folds != k, ]
    testset2 = dataset3[folds == k, ]
    testset_cropped2 = testset2
    testset_cropped2$class = NULL
    
    #discreto
    our_fit = bn.fit(our_model, trainset, method = "bayes")
    print("fit1")
    
    #method bayes perchè il metodo mle produce dei NA
    induced_fit = bn.fit(induced_model, trainset, method = "bayes")
    print("fit2")
    
    #continui
    induced_fit_cont = bn.fit(induced_model_cont, trainset2, method = "mle")
    print("fit3")
    
    our_fit_cont = bn.fit(our_model_cont, trainset2, method = "mle")
    print("fit4")
    
    #Preedizione
    our_prediction = predict(our_fit, "class", testset_cropped, method = "bayes-lw")
    print("prediction")
    
    our_prediction_cont = predict(our_fit_cont, "class", testset_cropped2, method = "bayes-lw")
    print("prediction2")
    
    induced_prediction = predict(induced_fit, "class", testset_cropped, method = "bayes-lw")
    print("prediction3")
  
    induced_prediction_cont = predict(induced_fit_cont, "class", testset_cropped2, method = "bayes-lw")
    print("prediction4")
    
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
    
    #performance evaluation our continuo
    confusion.matrix = table(testset2$class, our_prediction_cont)
    print(confusion.matrix)
    accuracy = sum(diag(confusion.matrix)) / sum(confusion.matrix)
    our_accuracy_cont = append(accuracy, our_accuracy_cont)



    precision = 0
    recall = 0
    for (i in 1 : 5){
      precision = precision + (confusion.matrix[i,i] / sum(confusion.matrix[, i]))
      recall = recall + (confusion.matrix[i,i] / sum(confusion.matrix[i, ]))

    }
    precision = precision / 5
    recall = recall / 5
    our_precision_cont = append(precision, our_precision_cont)
    our_recall_cont = append(recall, our_recall_cont)
    f1measure = 2 * (precision * recall / (precision + recall))
    our_fmeasure_cont = append(f1measure, our_fmeasure_cont)

    #performance evaluation induced continuo

    confusion.matrix = table(testset2$class, induced_prediction_cont)
    print(confusion.matrix)
    #print(induced_prediction_cont)
    accuracy = sum(diag(confusion.matrix)) / sum(confusion.matrix)
    induced_accuracy_cont = append(accuracy, induced_accuracy_cont)


    precision = 0
    recall = 0
    for (i in 1 : 5){
      precision = precision + (confusion.matrix[i,i] / sum(confusion.matrix[, i]))
      recall = recall + (confusion.matrix[i,i] / sum(confusion.matrix[i, ]))

    }

    precision = precision / 5
    recall = recall / 5
    induced_precision_cont = append(precision, induced_precision_cont)
    induced_recall_cont = append(recall, induced_recall_cont)
    f1measure = 2 * (precision * recall / (precision + recall))
    induced_fmeasure_cont = append(f1measure, induced_fmeasure_cont)

  }

#stampe performance
print(our_accuracy)
print(our_precision)
print(our_recall)
print(our_fmeasure)  

print(our_accuracy_cont)
print(our_precision_cont)
print(our_recall_cont)
print(our_fmeasure_cont)  

print(induced_accuracy)
print(induced_precision)
print(induced_recall)
print(induced_fmeasure)

print(induced_accuracy_cont)
print(induced_precision_cont)
print(induced_recall_cont)
print(induced_fmeasure_cont)

# Performance plot
pdf("our_performance.pdf", width = 8, height = 8)
# boxplot delle misure di performance proposto discreto
par(mfrow=c(2, 2))
boxplot(our_accuracy, main = "Accuracy")
boxplot(our_precision, main = "Precision")
boxplot(our_recall, main = "Recall")
boxplot(our_fmeasure, main = "F1Measure")
dev.off()

pdf("our_performance_cont.pdf", width = 8, height = 8)
# boxplot delle misure di performance proposto continuo
par(mfrow=c(2, 2))
boxplot(our_accuracy_cont, main = "Accuracy")
boxplot(our_precision_cont, main = "Precision")
boxplot(our_recall_cont, main = "Recall")
boxplot(our_fmeasure_cont, main = "F1Measure")
dev.off()

pdf("induced_performance.pdf", width = 8, height = 8)
# boxplot delle misure di performance caso indotto 
par(mfrow=c(2, 2))
boxplot(induced_accuracy, main = "Accuracy")
boxplot(induced_precision, main = "Precision")
boxplot(induced_recall, main = "Recall")
boxplot(induced_fmeasure, main = "F1Measure")
dev.off()

pdf("induced_performance_cont.pdf", width = 8, height = 8)
# boxplot delle misure di performance caso indotto continuo
par(mfrow=c(2, 2))
boxplot(induced_accuracy_cont, main = "Accuracy")
boxplot(induced_precision_cont, main = "Precision")
boxplot(induced_recall_cont, main = "Recall")
boxplot(induced_fmeasure_cont, main = "F1Measure")
dev.off()


# t-test per vedere se i modelli discreti e continui sono equivalenti
t.test(our_accuracy, our_accuracy_cont, paired = TRUE, conf.level = 0.95)
t.test(our_precision, our_precision_cont, paired = TRUE, conf.level = 0.95)
t.test(our_recall, our_recall_cont, paired = TRUE, conf.level = 0.95)
t.test(our_fmeasure, our_fmeasure_cont, paired = TRUE, conf.level = 0.95)


# t-test per vedere se i modelli discreti e continui sono equivalenti
t.test(induced_accuracy, induced_accuracy_cont, paired = TRUE, conf.level = 0.95)
t.test(induced_precision, induced_precision_cont, paired = TRUE, conf.level = 0.95)
t.test(induced_recall, induced_recall_cont, paired = TRUE, conf.level = 0.95)
t.test(induced_fmeasure, induced_fmeasure_cont, paired = TRUE, conf.level = 0.95)


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





