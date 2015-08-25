
library(ggplot2)
library(tidyr)
library(dplyr)
library(magrittr)
library(NLP) # required for tm package
library(tm) 
library(RWeka)

# import data into corpus
text_corpus <- Corpus(DirSource("DSA_samples/")) # folder of transcribed DSA docs

# remove stop words and punctuation, etc. ------------
text_corpus <- text_corpus %>% 
  tm_map(content_transformer(tolower)) %>% # change everything to lower case (must use content_transformer, or doc names are removed)
  tm_map(removeWords, stopwords("english")) %>% #remove common english words
  tm_map(removeWords, c("na", "will", "can", "must", "also", "used", "using")) %>% # more common words
  tm_map(removeNumbers) %>% 
  tm_map(stemDocument) %>% # reduce words to their stem
  tm_map(removePunctuation) %>% 
  tm_map(stripWhitespace) # take out white space from removed words

# convert corpus to document term matrix to data frame ------------

NgramTokenize <- function(x) NGramTokenizer(x, Weka_control(min = 1, max = 4)) # function to make dtm of single words and phrases
dtm <- DocumentTermMatrix(text_corpus, control = list(tokenize = NgramTokenize ))

all_samples <- as.data.frame(as.matrix(dtm)) # convert to data frame

# filter words/phrases that only appear once ------------

all_samples <- Filter( # remove columns where only one report contains that word
  function(x)(
    length(which(x !=0))>1 # more than one non-zero item in column
  ), 
  all_samples)

# modify data frame to have an ID column ----------------

# to work, file name must be in form: DSA_[id#].txt
all_samples <- all_samples %>% 
  mutate(file = row.names(.))%>% #convert doc name to actual column to manipulate
  separate(file, into = c("junk", "ID", "file_type"), sep = c(4, -5)) %>% # separate ID and file type from file name
  select(-junk, -file_type) # remove columns of filetype

# bind with scores ------------------------

DSA_scores <- read.csv("DSA Scores.csv") %>% 
  select(ID, PD, CD, Pre_Design, DD, Validation, Implementation, Process) #don't include "tool" columns

DSA_scores$ID <- as.numeric(DSA_scores$ID) # convert ID column to numeric for joining
all_samples$ID <- as.numeric(all_samples$ID) # convert ID column to numeric for joining

DSA_data <- full_join(DSA_scores, all_samples, by = "ID") # join so scores and text analysis are in the same order by ID

DSA_scores <- DSA_data %>% select(PD:Process) # columns of scores
DSA_text <- DSA_data %>% select(-c(ID:Process)) # columns of text analysis data

# export for analysis in matlab ------------------

write.csv(DSA_scores, file ="DSA_scores.csv") # csv of scores
write.csv(DSA_text, file ="DSA_text.csv") # csv of text analysis
