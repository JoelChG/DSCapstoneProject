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
