
ngram_freq <- function(input_text, disp_name, ... ){
  
#  require(RWeka, tm, magrittr, dplyr)  
  
text_corpus <- Corpus(VectorSource(input_text))

# clean up corpus -----------
  text_corpus <- text_corpus %>% 
    tm_map(stripWhitespace) %>% # take out white space
    tm_map(tolower) %>% # change everything to lower case
    #tm_map(stemDocument) %>% # reduce words to their stem
    tm_map(removeWords, stopwords("english")) %>% #remove common english words
    tm_map(removeWords, c("na", "will", "can", "must", "also", "used", "using")) %>%
    tm_map(removeNumbers) %>% 
    tm_map(removePunctuation) %>% 
    tm_map(PlainTextDocument) # convert back to a text document for plotting
  

# look at phrases --------------
  
  NgramTokenize <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 4))
  test <- DocumentTermMatrix(text_corpus, control = list(tokenize = NgramTokenize ))
  
  freq <- sort(colSums(as.matrix(test)), decreasing=TRUE)   # order by decreasing phrase frequency
  
  ngrams <- data.frame(word=names(freq), freq=freq) #%>% filter(freq >= 2) # phrase frequency data frame
  rownames(ngrams) <- NULL

  colnames(ngrams)[2]<- disp_name # rename freq column to input name for later merge
  
  return(ngrams)

}

