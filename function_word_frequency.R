
# word frequency function
# returns data frame with words and their frequency

word_freq <- function(input_text, disp_name, ... ){
  
  text_corpus <- Corpus(VectorSource(input_text))
  
  # clean up corpus
  text_corpus <- text_corpus %>% 
    tm_map(stripWhitespace) %>% # take out white space
    tm_map(tolower) %>% # change everything to lower case
    tm_map(removeWords, stopwords("english")) %>% #remove common english words
    tm_map(removeWords, c("na", "will", "can", "must", "also", "used", "using")) %>%
    tm_map(removeNumbers) %>% 
    tm_map(stemDocument) %>% # reduce words to their stem
    tm_map(removePunctuation) %>% 
    tm_map(PlainTextDocument) # convert back to a text document for plotting
  
  # analyze text
  dtm <- DocumentTermMatrix(text_corpus)  
  freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)   # order by decreasing word frequency
  
  wf <- data.frame(word=names(freq), freq=freq) %>% filter(freq > 1) # word frequency data frame
  
  colnames(wf)[2]<-disp_name
  
  return(wf)
}

