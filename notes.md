# Text Mining

Getting meaningful information from unstructured text

# procedure

1. collecting data
2. representation of data
3. (feature extraction)
4. learning
5. evaluation
6. go back to 1-5

# representation of unstructured text in structured data structure

Simpliest model: Bag-of-words (BoW)

# Example

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

# Idea #1: token / tokenization

Smallest unit of analysis. In this case: word

# Example

```
the quick brown fox jumps over the lazy dog
```

Tokenized version: {the,quick,brown,fox,jumps,over,the,lazy,dog}

Unique tokens: {the,quick,brown,fox,jumps,over,lazy,dog}

Frequency vector: {the: 2, quick: 1, brown: 1, fox: 1, jumps: 1, over: 1, lazy: 1, dog: 1}

# Microtask #1: find all unique tokens in letitgo.txt

Unix wizardary can do it this way:

```{bash}
tr '[:upper:]' '[:lower:]' < letitgo.txt | tr -d "'" |tr -c '[:alnum:]' '[\n*]' | sort | uniq -c | sort -nr
```

But this is not Hong Kong Linux User Group.

