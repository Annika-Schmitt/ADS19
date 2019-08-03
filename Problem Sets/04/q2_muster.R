# Problem Set 4
# Question 2

# Name: Your Name
# Matrikelnummer: Your matriculation number

library(tidyverse)
library(foreign)

#a)
files = list.files(recursive = TRUE, pattern = "*.txt")

getDocument = function(x){
  paste(unlist(scan(x, what="character",quiet = T)),collapse = " ")
}

text = map_chr(files, getDocument)
textData = data.frame(document=1:2225, text=text)

files %>%
  str_extract_all("/.+/", simplify = TRUE) %>%
  str_replace_all("/", "") -> categories

textData$category = categories
textData$text = as.character(textData$text)

#b)
library(tidytext)

textData %>%
  group_by(category) %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(word, sort = TRUE) %>%
  top_n(5) -> termFrequencies
  
termFrequencies %>%
  ggplot(aes(x=reorder(word, n), y=n)) +
  geom_col(position="dodge") + facet_wrap(.~category, scales = 'free') + coord_flip() + theme_bw()

termFrequencies %>%
  ggplot(aes(x=word, y=n)) +
  geom_col(position="dodge") + facet_wrap(.~category, scales = 'free') + coord_flip() + theme_bw()



textData %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(category, word, sort = TRUE) %>%
  bind_tf_idf(word, category, n) %>%
  group_by(category) %>%
  arrange(desc(tf_idf)) %>%
  top_n(5) -> inverseTermFrequencies

inverseTermFrequencies %>%
  ggplot(aes(x=reorder(word, n), y=n)) +
  geom_col(position="dodge") + facet_wrap(.~category, scales = 'free') + coord_flip() + theme_bw()


# c)
# Term document matrix
textData %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(document, word, sort = TRUE) %>%
  cast_dtm(document, word, n) -> tdm

# LDA
library(topicmodels)
lda = LDA(tdm, k=length(unique(categories)), control = list(seed=1234))
ldaTD = tidy(lda)

ldaTD %>%
  group_by(topic) %>%
  top_n(5, beta) %>%
  arrange(topic, desc(beta)) -> topTerms

topTerms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta)) +
  geom_bar(stat = "identity") +
  scale_x_reordered() +
  facet_wrap(~ topic, scales = "free_x")


ldaGamma = tidy(lda, matrix = 'gamma')

ldaGamma %>%
  arrange(document)

ldaGamma %>%
  group_by(document) %>%
  top_n(1, gamma) %>%
  ungroup() %>%
  arrange(gamma)  %>%
  mutate(document = as.integer(document)) -> documentClassifications

documentClassifications %>%
  mutate(topic = if_else(topic == 1, "tech" , 
                         if_else(topic == 2, "politics",
                                 if_else(topic == 3, "entertainment",
                                         if_else(topic == 4, "sport", "business"))))) -> documentClassifications

textData %>%
  left_join(documentClassifications, by = "document") %>%
  mutate(correctLabel = category == topic) -> textDataClassified

mean(textDataClassified$correctLabel)

textDataClassified %>%
  filter(correctLabel == FALSE) %>% sample_n(1)
