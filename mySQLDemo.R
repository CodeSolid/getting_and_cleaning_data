openUCSCMySQL <- function() {
    library("RMySQL")
    ucscDb <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu")
    ucscDb
}

openHg19 <- function() {
    library("RMySQL")
    db <- dbConnect(MySQL(), user="genome", host="genome-mysql.cse.ucsc.edu", db="hg19")
    db
}

disconnect <- function(db) {
    dbDisconnect(db)
}