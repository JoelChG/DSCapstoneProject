library(quanteda); library(tm)
library(tictoc); library(readtext)
library(quanteda.textmodels)
tic("Total")
tic("First steps")
url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
wd <- getwd()
if(file.exists("./Assets/Dataset/CapstoneDataset.zip") != TRUE){
        download.file(url, destfile = paste(wd,
                                            "Assets/Dataset/CapstoneDataset.zip",
                                            sep = "/"))
        unzip("./Assets/Dataset/CapstoneDataset.zip",
              exdir = "./Assets/Dataset")
        message("File succesfully downloaded and unzipped")
} else {
        message("File has already been downloaded and unzipped")
}
if(file.exists("./Assets/Dataset/CapstoneDataset.zip") == TRUE){
        rm(url)
}
dirPaths <- list.files(path = paste(wd,
                                    "Assets/Dataset/final",
                                    sep = "/"),
                       include.dirs = TRUE,
                       full.names = TRUE)

## Creating a corpus
corpus <- VCorpus(DirSource(dirPaths[2]),
readerControl = list(reader = readPlain,
language = "en",
load = TRUE))
saveRDS(corpus, "Assets/RDS/corpus.rds")
### Dealing with profanity words
profanityVector <- as.character(read.table("Assets/Files/badwordsRegEx.txt",
sep = ""))
reorder.stoplist <- c(grep("[']", stopwords('english'), value = TRUE),
stopwords('english')[!(1:length(stopwords('english')) %in%
grep("[']", stopwords('english')))])
## Preprocessing
cleanCorpus <- function(x){
message("Lowercasing")
x <- tm_map(x, content_transformer(tolower))
message("Lowercasing completed")
message("Removing punctuation")
x <- tm_map(x, removePunctuation)
message("Removing punctuation completed")
message("Removing stopwords")
x <- tm_map(x, removeWords, reorder.stoplist)
message("Removing stopwords completed")
message("Removing numbers")
x <- tm_map(x, removeNumbers)
message("Removing numbers completed")
message("Removing special characters 1/3")
x <- tm_map(x, content_transformer(
function(x){gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", x)}
))
message("Removing special characters 2/3")
x <- tm_map(x, content_transformer(
function(x){gsub("@[^\\s]+", "", x)}
))
message("Removing special characters 3/3")
x <- tm_map(x, content_transformer(
function(x){gsub("[[:punct:]]", "", x)}
))
message("Removing special characters completed")
message("Removing whitespace")
x <- tm_map(x, stripWhitespace)
message("Removing whitespace completed")
message("removing profanities")
x <- tm_map(x, removeWords, profanityVector)
message("removing profanities completed")
}
## Applying the preprocess function to the corpus
corpus <- cleanCorpus(corpus)
saveRDS(corpus, "Assets/RDS/preprocessedCorpus-tm.rds")
if(file.exists("Assets/RDS/preprocessedCorpus-tm.rds") == TRUE){
message("preprocessedCorpus-tm.rds saved correctly")
} else {
message("Error")
}