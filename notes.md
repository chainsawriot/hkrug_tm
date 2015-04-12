# Text Mining

Getting meaningful information from unstructured text

## Procedure

1. collecting data
2. representation of data
3. (feature extraction)
4. learning
5. evaluation
6. go back to 1-5

## Representation of unstructured text in a structured data structure

Simpliest model: Bag-of-words (BoW)

### Example

letitgo.txt

```
let it go, let it go
can't hold it back anymore
let it go, let it go
turn away and slam the door
i don't care
what they're going to say
let the storm rage on.
the cold never bothered me anyway
```

## Concept #1: token / tokenization

Smallest unit of analysis. In this case: word

### Example

```
the quick brown fox jumps over the lazy dog
```

Tokenized version: {the,quick,brown,fox,jumps,over,the,lazy,dog}

Unique tokens: {the,quick,brown,fox,jumps,over,lazy,dog}

Frequency vector: {the: 2, quick: 1, brown: 1, fox: 1, jumps: 1, over: 1, lazy: 1, dog: 1}

### Warmup microtask #1

find all unique tokens in letitgo.txt. Unix wizardry can do it this way:

```{bash}
tr '[:upper:]' '[:lower:]' < letitgo.txt | tr -d "'" |
tr -c '[:alnum:]' '[\n*]' | sort | uniq -c | sort -nr
```

But this is not Hong Kong Linux User Group.

#### Basic text manipulation

```{r}
readLines("letitgo.txt")
letitgo <- readLines("letitgo.txt")
tolower(letitgo) # tolower
letitgo2 <- gsub("[[:punct:]]", "", tolower(letitgo)) #remove punctuation
# tokenization
strsplit(letitgo2, " ") # split text by space
unlist(strsplit(letitgo2, " "))
# unique tokens
unique(unlist(strsplit(letitgo2, " ")))
sort(unique(unlist(strsplit(letitgo2, " "))))
# BONUS: word frequency
table(unlist(strsplit(letitgo2, " ")))
sort(table(unlist(strsplit(letitgo2, " "))))
# BONUS+: the use of magrittr, read from left to right
require(magrittr)
letitgo2 %>% strsplit(split= " ") %>% unlist %>% table %>% sort
# even more extreme version of magrittr pipeline
# suprisingly similar to the above Unix version
"letitgo.txt" %>% readLines %>% tolower %>% gsub("[[:punct:]]", "", .) %>% strsplit(split= " ") %>% unlist %>% table %>% sort
```

## Concept #2: Corpus & TDM/DTM

_Corpus_ [n] a large or complete collection of writings

### Warmup microtask #2

eyeballing a dataset

extracts.csv: what are the variables in this dataset?

(1.5 mins)

```{r}
extracts <- read.csv("extracts.csv", stringsAsFactors = FALSE)
head(extracts)
str(extracts)
#you may use dplyr to override the default stupid behavior of data.frame
require(dplyr)
read.csv("extracts.csv", stringsAsFactors = FALSE) %>% tbl_df %>% select(enextracts)
```

## Introducing the tm packages

Provide two important data structures for text mining

- Corpus (cover just briefly today)
- TDM/DTM

### Creation of Corpus

```{r}
require(tm)
Corpus(VectorSource(extracts$enextracts))
```

### Corpus data structure

- add meta data (not cover today)
- an intermediate to TDM/DTM

### TDM/DTM - Term Document Matrix / Document Term Matrix

Example

```
document #1: the world is full of fascinating problems waiting to be solved
document #2: no problem should ever have to be solved twice
document #3: boredom and drudery are evil
document #4: freedom is good
document #5: attitude is no subsitute for competence
```

#### unique tokens

```{r}
require(magrittr)
hackerAttutide <- c("the world is full of fascinating problems waiting to be solved",
"no problem should ever have to be solved twice",
"boredom and drudery are evil",
"freedom is good",
"attitude is no subsitute for competence")
hackerAttutide %>% strsplit(" ") %>% unlist %>% unique %>% data.frame
```

```
    dictionary
1          the
2        world
3           is
4         full
5           of
6  fascinating
7     problems
8      waiting
9           to
10          be
11      solved
12          no
13     problem
14      should
15        ever
16        have
17       twice
18     boredom
19         and
20     drudery
21         are
22        evil
23     freedom
24        good
25    attitude
26   subsitute
27         for
28  competence
```

### Represent free text as matrix

Representation 'the world is full of fascinating problems waiting to be solved' as index and do the frequency count


Word | the | world | is | full | of | fascinating | problems | waiting | to | be | solved
--- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---
Index | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11
Freq | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1

Represent as a 1x28 matrix

```
[1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
```

### microtask #3: Representation of free text into matrix

1. Let do this together: "no problem should ever have to be solved twice"
2. Group work: "boredom and drudery are evil", "freedom is good", "attitude is no subsitute for competence"

### TDM / DTM

DTM == t(TDM)

i.e. row are terms and col is document

### microtask #4

what is the problem of the TDM

### Creation of TDM/DTM

```{r}
TermDocumentMatrix(Corpus(VectorSource(hackerAttutide)))
# in case you have so fond of magrittr already
Corpus(VectorSource(hackerAttutide)) %>% TermDocumentMatrix
# in case you need a DTM
DocumentTermMatrix(Corpus(VectorSource(hackerAttutide)))
Corpus(VectorSource(hackerAttutide)) %>% DocumentTermMatrix
```

Common pitfalls

1. How to look at it? inspect
2. wordLengths
3. work just like a matrix, but not a matrix (but a sparse matrix)

### microtask #5

representation of extracts$enextracts as DocumentTermMatrix and call it enDTM

## Surgery #1: latent dirichlet allocation (LDA)

- Topic model ~ k-mean clustering
- Articles with similar topic should be clustered together
- Unsupervised learning

### topic models

We will never get it right the first time

```{r}
require(topicmodes)
enLDA <- LDA(enDTM, 2)
terms(enLDA, 20)
topics(enLDA)
extracts$entitles[topics(enLDA) == 2]
extracts$entitles[topics(enLDA) == 1]
```

#### microtask #6

Describe the problem of the topic model

#### Diagnose the problem

```{r}
terms(enLDA, 20)
colnames(enDTM)
```

### Potential improvement #1  stopwords

stopwords [n] words which are filtered out before or after processing of natural language data.

e.g. short function words: the, is, at, which....

```{r}
stopwords('en')
```

Removal of stopwords from the DTM

```{r}
DocumentTermMatrix(Corpus(VectorSource(extracts$enextracts)), control=list(stopwords = stopwords('en')))
```

### Potential improvement #2 punctuation

```{r}
DocumentTermMatrix(Corpus(VectorSource(extracts$enextracts)), control=list(removePunctuation = TRUE))
colnames(DocumentTermMatrix(Corpus(VectorSource(extracts$enextracts)), control=list(removePunctuation = TRUE)))
```

we may want to preserve the intra-word dashes: theorem-proving, third-party

```{r}
DocumentTermMatrix(Corpus(VectorSource(extracts$enextracts)), control=list(removePunctuation = function(x) removePunctuation(x, preserve_intra_word_dashes = TRUE)))
```

### Potential improvement #3 stemming

Stemming [n] a process for reducing inflected (or sometimes derived) words to their word stem, base or root form—generally a written word form.

language, languages -> languag

```{r}
stemDocument("language", "en")
stemDocument("languages", "en")
```

```{r}
DocumentTermMatrix(Corpus(VectorSource(extracts$enextracts)), control=list(stemming = TRUE))
DocumentTermMatrix(Corpus(VectorSource(extracts$enextracts)), control=list(stemming = function(x) stemDocument(x, "en")))
```

### Potential improvement #4 remove Sparse Term

```{r}
apply(enDTM, 2, function(x) sum(x==0)) # number of document with term freq > 0
```

sparse terms [n] terms occurring only in very few documents
You may want to remove sparse terms to speed up computation and prevent trapping in local optimization

```{r}
removeSparseTerms(enDTM, 0.9) #0.9 is the threshold. Only keep terms occur in 90% of documents
```

- Removal of sparse terms is usually helpful, but of course it is case-by-case.
- Need to choose the threshold wisely
- My initial choice usually: (n-3)/n

```{r}
threshold <- (nrow(enDTM)-3) / nrow(enDTM)
removeSparseTerms(enDTM, threshold)
```

### microtask #8

Create a new DTM with stemming, removal of stop words, removal of punctuation and removal of sparse terms, and called it enDTM2

Redo the topic model and see the improvement

## Surgery #2: Auf Wiedersehen

create a LDA model of the entries$deextracts and call it deLDA. Conduct a cross tabulation between topics(enLDA) & topics(deLDA)

Lesson learn:

```
"A big computer, a complex algorithm and a long time does not equal science." 
```
Robert Gentleman (statistician, one 'R' of the two creators of R)

## Surgery #3: Supervised learning

### microtask #9

- read-in spambase.csv
- inspect the data
- create a DTM out of the second column (mail)

```{r}
spambase <- read.csv("spambase.csv", stringsAsFactors = FALSE)
```

SMS spam! : https://archive.ics.uci.edu/ml/datasets/SMS+Spam+Collection

http://www.dt.fee.unicamp.br/~tiago/smsspamcollection/doceng11.pdf

### Supervised learning

You have the answer!

The label column.

Use the feature in the __mail__ column to predict __label__ .

### Refresher: how to construct a prediction model.

You say you know how to do it, dude!

```{r}
# logistic regression
model <- glm(vs~wt+disp, data=mtcars, family = binomial)
predict(model, type = 'response')
table(mtcars$vs, predict(model, type = 'response') > 0.5)
```

### Advance-ish stuff

```{r}
# Naive bayes
require(klaR)
nb <- NaiveBayes(as.factor(vs)~wt+disp, data=mtcars)
table(predict(nb)$class, mtcars$vs)
require(e1071)
svmmodel <- svm(as.factor(vs)~wt+disp, data=mtcars)
table(predict(svmmodel), mtcars$vs)
```

### Cross validation

cross validation [n] assesing how the results of a statistical analysis will generalise to an independent data set.

- bias / variance tradeoff

#### Right-er way to do: split the data into training and test set

```{r}
nrow(mtcars) #32

# 22 rows as training set

training <- sample(1:32, 22)
require(e1071)
svmmodelt <- svm(as.factor(vs)~wt+disp, data=mtcars[training,])
table(predict(svmmodelt), mtcars$vs[training]) # trainingset accuracy

#testset accuracy

table(predict(svmmodelt , newdata = mtcars[]), mtcars$vs[training]) # trainingset accuracy
table(predict(svmmodelt , newdata = mtcars[-training,]), mtcars$vs[-training])
```

### Try to do the SVM for spambase data

Creating training-test split and see

caveats:

- svm can accept (x = mat, y = y)
- for the DocumentTermMatrix, you need to as.matrix to make it a normal matrix. (stupid!)

```{r}
# suppose you already have a dtm called spamdtm
training <- sample(1:5574, 3902)
# or
# training <- sample(1:nrow(spamdtm), floor(nrow(spamdtm) * 0.7))
trainingX <- spamdtm[training,]
trainingy <- spambase$label[training]
require(e1071)
svmmodel <- svm(x = as.matrix(trainingX), y = as.factor(trainingy))
predict(svmmodel) # incorrect at all
```

You can even get training set correct, it will never get it right on test set.

### microtask #10

No free hunch: How to improve it?

Hints: how to reduce number of features?

### How to evaluate?

COL OBS, ROW PRED | TRUE | FALSE
--- | --- | ---
TRUE | True Positive | False Positive
FALSE | False Negative | True Negative

Recall (Sensitivity): TP / (TP + FN)

Precision (Positive Predictive value, PPV): TP / (TP + FP)

F1 score = harmonic mean of Precision & Recall = (2 * TP) / (2 * TP + (FP + FN))

You can't use Accuracy: (TP + TN) / (TP + TN + FP + FN) for this, why?

### Bias Variance trade off

F1 | Test set High F1 | Test set Low F1
--- | ---- | ---
Training set High F1 | Nice | High Variance
Training set Low F1 | Fluke | High bias

The goal: Similar (high) F1 for both training set and test set

High bias (underfit): more data, more feature maybe?, 'clever fancy algo'

High variance (overfit): more data may not help, less feature (feature selection), regularization

Reference: http://see.stanford.edu/materials/aimlcs229/ML-advice.pdf
