library(quanteda); library(tm)
library(tictoc); library(readtext)
library(quanteda.textmodels)
tic("Total")
tic("Loading data")
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
toc()

## Creating a corpus
tic("Creating corpus")
corpus <- VCorpus(DirSource(dirPaths[2]),
                  readerControl = list(reader = readPlain,
                                       language = "en",
                                       load = TRUE))
saveRDS(corpus, "Assets/RDS/corpus.rds")
toc()
### Dealing with profanity words
profanityVector <- as.character(read.table("Assets/Files/badwordsRegEx.txt",
                                           sep = ""))

reorder.stoplist <- c(grep("[']", 
                           stopwords('english'), 
                           value = TRUE), stopwords('english')[!(1:length(stopwords('english')) %in%
                                                     grep("[']", stopwords('english')))])
## Preprocessing
tic("Preprocessing")
cleanCorpus <- function(x){
        message("Lowercasing")
        c <- tm_map(x, content_transformer(tolower))
        message("Lowercasing completed")
        message("Removing punctuation")
        c <- tm_map(c, removePunctuation)
        message("Removing punctuation completed")
        message("Removing stopwords")
        c <- tm_map(c, removeWords, reorder.stoplist)
        c <- tm_map(c, content_transformer(
                function(x){gsub("im|dont|cant|wont|wouldnt|shouldnt", "", x)}
        ))
        message("Removing stopwords completed")
        message("Removing numbers")
        c <- tm_map(c, removeNumbers)
        message("Removing numbers completed")
        message("Removing special characters 1/3")
        c <- tm_map(c, content_transformer(
                function(x){gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", x)}
                ))
        message("Removing special characters 2/3")
        c <- tm_map(c, content_transformer(
                function(x){gsub("@[^\\s]+", "", x)}
                ))
        message("Removing special characters 3/3")
        c <- tm_map(c, content_transformer(
                function(x){gsub("[[:punct:]]", "", x)}
                ))
        message("Removing special characters completed")
        message("Removing whitespace")
        c <- tm_map(c, stripWhitespace)
        message("Removing whitespace completed")
        message("removing profanities")
        c <- tm_map(c, removeWords, profanityVector)
        message("removing profanities completed")
        x <- c
}

## Applying the preprocess function to the corpus
corpus <- cleanCorpus(corpus)
toc()

saveRDS(corpus, "Assets/RDS/preprocessedCorpus-tm.rds")
if(file.exists("Assets/RDS/preprocessedCorpus-tm.rds") == TRUE){
message("preprocessedCorpus-tm.rds saved correctly")
} else {
message("Error")
}
toc()