ccp <- readLines("communist.txt")
require(magrittr)
require(dplyr)
ccp[ccp != ''] %>% subset(.,!grepl("^第.+[章|条]|总纲", .)) -> ccp2

ccp2[1]
require(jiebaR)
jiebaworker <- worker()
jiebaworker <= ccp2[1]
segment(ccp2[2], jiebaworker)
paste(segment(ccp2[2], jiebaworker), collapse = " ")

segtext <- sapply(ccp2, function(x) paste(segment(x, jiebaworker), collapse = " "))
require(tm)
ccpdtm <- DocumentTermMatrix(Corpus(VectorSource(segtext)), control = list(wordLengths=c(1, Inf)))

apply(ccpdtm, 2, sum) %>% sort %>% tail(40)

on9 <- readLines("onnine.txt")
on9
on9 %>% gsub("[　＊（）]", " ", .) -> on92

#alternative method: character ngram

require(ngramrr)

on9dtm <- DocumentTermMatrix(Corpus(VectorSource(on92)), control = list(wordLengths=c(1, Inf), tokenize = function(x) ngramrr(x, char = TRUE, ngmax = 3)))

apply(on9dtm, 2, sum) %>% sort %>% tail(40) # a lot of redundancy

## experimental: https://github.com/chainsawriot/tdmcleanrr
