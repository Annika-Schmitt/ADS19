# Problem Set 4
# Question 2

# Name: Your Name
# Matrikelnummer: Your matriculation number

require(tidyverse)
library(foreign)

files = list.files(recursive = TRUE, pattern = "*.txt")

getDocument = function(x){
  paste(unlist(scan(x, what="character",quiet = T)),collapse = " ")
}

text = map_chr(files, getDocument)
textData = data.frame(document=1:2225, text=text)
