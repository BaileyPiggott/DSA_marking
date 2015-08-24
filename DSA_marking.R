
library(ggplot2)
library(tidyr)
library(dplyr)
library(magrittr)
library(NLP) # required for tm package
library(tm) 
library(RWeka)

source("function_word_frequency.R")
source("function_phrase_freq.R")

# read text and count words ----------------
dsa_1101 <- read.table("DSA_samples/DSA_1101.txt", sep = "@") # pick separation character as something that will not appear in the text
wf_1101 <- rbind(word_freq(dsa_1101, "1101"), ngram_freq(dsa_1101, "1101"))

dsa_1146 <- read.table("DSA_samples/DSA_1146.txt", sep = "@") 
wf_1146 <- rbind(word_freq(dsa_1146, "1146"), ngram_freq(dsa_1146, "1146"))

dsa_1552 <- read.table("DSA_samples/DSA_1552.txt", sep = "@") 
wf_1552 <- rbind(word_freq(dsa_1552, "1552"), ngram_freq(dsa_1552, "1552"))

dsa_1666 <- read.table("DSA_samples/DSA_1666.txt", sep = "@") 
wf_1666 <- rbind(word_freq(dsa_1666, "1666"), ngram_freq(dsa_1666, "1666"))

dsa_1338 <- read.table("DSA_samples/DSA_1338.txt", sep = "@") 
wf_1338 <- rbind(word_freq(dsa_1338, "1338"), ngram_freq(dsa_1338, "1338"))

dsa_1773 <- read.table("DSA_samples/DSA_1773.txt", sep = "@") 
wf_1773 <- rbind(word_freq(dsa_1773, "1773"), ngram_freq(dsa_1773, "1773"))

dsa_1381 <- read.table("DSA_samples/DSA_1381.txt", sep = "@") 
wf_1381 <- rbind(word_freq(dsa_1381, "1381"), ngram_freq(dsa_1381, "1381"))

dsa_1834 <- read.table("DSA_samples/DSA_1834.txt", sep = "@") 
wf_1834 <- rbind(word_freq(dsa_1834, "1834"), ngram_freq(dsa_1834, "1834"))

dsa_1258 <- read.table("DSA_samples/DSA_1258.txt", sep = "@") 
wf_1258 <- rbind(word_freq(dsa_1258, "1258"), ngram_freq(dsa_1258, "1258"))

dsa_1892 <- read.table("DSA_samples/DSA_1892.txt", sep = "@") 
wf_1892 <- rbind(word_freq(dsa_1892, "1892"), ngram_freq(dsa_1892, "1892"))


# combine into one data frame -----------------------------------

all_samples <- wf_1101 %>% 
  full_join(wf_1146, by = "word") %>% 
  full_join(wf_1552, by = "word") %>%
  full_join(wf_1666, by = "word") %>%
  full_join(wf_1258, by = "word") %>%
  full_join(wf_1338, by = "word") %>%
  full_join(wf_1773, by = "word") %>%
  full_join(wf_1381, by = "word") %>%
  full_join(wf_1834, by = "word") %>%
  full_join(wf_1892, by = "word")


rownames(all_samples)<- all_samples[,1 ] #convert 'word' column to row names
all_samples <- all_samples[,-1] #remove original 'word' column

all_samples <- data.frame(t(all_samples))

#filter out words that only appear in one sample --------------------------------

all_samples <- Filter( # remove columns where only one report contains that word
  function(x)(
    length(which(!is.na(x)))>1 # more than one non-NA item in column
  ), 
  all_samples)

all_samples <- all_samples %>% mutate(ID = row.names(.)) #convert ID's into an actual column for merging

# bind with scores ------------------------

DSA_scores <- read.csv("DSA Scores.csv") %>% select(ID, PD, CD, Pre_Design, DD, Validation, Implementation, Process)
# convert ID column to numeric for joining
DSA_scores$ID <- as.numeric(DSA_scores$ID)
all_samples$ID <- as.numeric(all_samples$ID)

DSA_data <- full_join(DSA_scores, all_samples, by = "ID") # join so scores and text analysis are in the same order by ID

DSA_scores <- DSA_data %>% select(PD:Process) # columns of scores
DSA_text <- DSA_data %>% select(-c(ID:Process)) # columns of text analysis data

# export for analysis in matlab ------------------

write.csv(DSA_scores, file ="DSA_scores.csv") # csv of scores
write.csv(DSA_text, file ="DSA_text.csv") # csv of text analysis
