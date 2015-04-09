spambase <- read.csv("spambase.csv", stringsAsFactors = FALSE)
require(tm)
spamdtm <- DocumentTermMatrix(Corpus(VectorSource(spambase$mail)), control = list(stemming = TRUE, removePunctuation = function(x) removePunctuation(x, preserve_intra_word_dashes = TRUE), stopwords = stopwords('en')))

spamdtm <- removeSparseTerms(spamdtm, sparse = (nrow(spamdtm) - 3) / nrow(spamdtm))

training <- sample(1:5574, 3902)
trainingX <- spamdtm[training,]
trainingy <- spambase$label[training]

require(e1071)
svmmodel <- svm(x = as.matrix(trainingX), y = as.factor(trainingy))
predict(svmmodel) # incorrect at all

# reason: too many features

spamdtm <- DocumentTermMatrix(Corpus(VectorSource(spambase$mail)), control = list(stemming = TRUE, removePunctuation = function(x) removePunctuation(x, preserve_intra_word_dashes = TRUE), stopwords = stopwords('en')))

spamdtm <- removeSparseTerms(spamdtm, sparse = (nrow(spamdtm) - 10) / nrow(spamdtm))
trainingX <- spamdtm[training,]
trainingy <- spambase$label[training]

svmmodel <- svm(x = as.matrix(trainingX), y = as.factor(trainingy))
predict(svmmodel)
table(predicty = predict(svmmodel), trainingy)

f1score <- function(predicted, actual) {
    confusion <- table(predicted, actual)
    return((confusion[1]*2) / ((confusion[1] * 2) + confusion[2] + confusion[3]))
}

f1score(predict(svmmodel), trainingy)

#test set accuracy

testX <- spamdtm[-training,]
testy <- spambase$label[-training]
f1score(predict(svmmodel, as.matrix(testX)), testy)
table(predict(svmmodel, as.matrix(testX)), testy)

# precision: TP / (TP+FP)
# recall: TP / (TP + FN)
# f1: harmonic mean of precision and Recall
# 2 * ((prec*recall) / (prec + recall))
