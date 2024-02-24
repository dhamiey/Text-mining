library(tm)
library(SnowballC)
library(ggplot2)
library(wordcloud)
library(RColorBrewer)

#create a data object containing a collection of documents (corpus) using VCorpus & DataframeSource
corpus_df <- VCorpus(DataframeSource(read.csv("Downloads/Triad.csv", header = TRUE)))

#remove punctuation from the corpus using tm_map 
corpus_df <- tm_map(corpus_df, removePunctuation)

#remove numbers
corpus_df <- tm_map(corpus_df, removeNumbers)

#remove extraneous white space
corpus_df <- tm_map(corpus_df, stripWhitespace)

#remove common english words
corpus_df <- tm_map(corpus_df, removeWords, stopwords, ("english"))

#execute stemming to reduce words down to thier wood roots using tm_map 
corpus_df <- tm_map(corpus_df, stemDocument)

#generate the frequency document- term matrix based on the corpus 
dtmFreq <- DocumentTermMatrix(corpus_df)

#store frequency document-term matrix as a matrix data object
freqMatrix <- as.matrix(dtmFreq)

#Generate the binary (presence-absence) document-matrix based on the corpus
dtmBin <- DocumentTermMatrix(corpus_df, control = list(weighting = weightBin))

#Store binary document-term matrix as matrix data object
binaryMatrix <- as.matrix(dtmBin)

#compute frequencies of the terms in the corpus
wordFreq <- colSums(freqMatrix)

#store the terms and their frequencies in decreasing order of freq
v<- sort(wordFreq, decreasing = TRUE)

#create dataframe containing words and their frequencies
df_wc <- data.frame(word =names(v), freq = v)

#initialize random number generator with seed "1234"
set.seed(1234)

#draw word cloud
wordcloud(words = df_wc$word, freq = df_wc$freq, min.freq = 1, max.words = 200,
          random.order = FALSE, rot.per = 0.35, colors = brewer.pal(8, "Dark2") )

#create a reduced binary document-term to a csv-file
write.csv(binMat5, file = "TriadBinDTM.csv")

