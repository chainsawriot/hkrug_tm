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

### Warmup microtask #1: find all unique tokens in letitgo.txt

Unix wizardry can do it this way:

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

### Warmup microtask #2: eyeballing a dataset

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

Representation as index

| *word* | the | world | is | full | of | fascinating | problems | waiting | to | be | solved |
| ------ | --- | ----- | -- | ---- | --- | ---------- | -------- | ------- | -- | -- | ------ |
| *index* |  1 |  2 |   3 |  4 |  5  |     6  | 7 | 8 | 9 | 10 | 11 |
| *Freq* | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |

Represent as a 1x28 matrix

```
[1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
```
