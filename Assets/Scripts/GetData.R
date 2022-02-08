# Task 0: Understanding the problem

## loading libraries
library(R.utils)
## Getting the data

### Downloading the data
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

## Reading the data
dirPaths <- list.files(path = paste(wd, 
                                    "Assets/Dataset/final",
                                    sep = "/"), 
                      include.dirs = TRUE, 
                      full.names = TRUE)

de_files <- list.files(dirPaths[1], full.names = TRUE)
us_files <- list.files(dirPaths[2], full.names = TRUE)
fi_files <- list.files(dirPaths[3], full.names = TRUE)
ru_files <- list.files(dirPaths[4], full.names = TRUE)

## Function to read one line at a time
processFile = function(filepath) {
        con = file(filepath, "r")
        while ( TRUE ) {
                line = readLines(con, n = 1)
                if ( length(line) == 0 ) {
                        break
                }
                print(line)
        }
        
        close(con)
}

blogs <- processFile(us_files[1])
