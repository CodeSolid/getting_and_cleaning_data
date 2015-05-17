mergeOneFile <- function (srcFile1, srcFile2, target) {
    # Lines for debugging...
    # print(paste("Merging files", srcFile1, "and", srcFile2, "to", target))
    # print(paste(srcFile1, file.exists(srcFile1)))
    # print(paste(srcFile2, file.exists(srcFile2)))
    print(paste("Merging file:", target))
    df1 <- read.table(srcFile1)
    df2 <- read.table(srcFile2)
    # Test first development, get it?  No seriously, test data first, train
    # data on the bottom
    merged <- rbind(df1, df2)
    write.table(merged, target, row.names=F)
}

getMergeDir <- function(dirRoot) {
    paste(dirRoot, "/merged", sep="")
}

getMergeDirInertial <- function(dirRoot) {
    paste(dirRoot, "/merged/Inertial Signals", sep = "")
}

# Base part of filenames in root directory of test, train
getFilesRoot <- function() {
    c("subject", "X", "y")
}

# Base part of filenames in "Inertial Signals" sub-directory of test, train
getFilesInertialSignals <- function() {
    c(
        "body_acc_x",  "body_acc_y",  "body_acc_z", 
        "body_gyro_x", "body_gyro_y", "body_gyro_z",
        "total_acc_x", "total_acc_y", "total_acc_z")
}
mergeFiles <- function(directory) {
    # Hard coded lists of file roots we need to operate on.
    # Todo this could be made generic, but this implementation was easier
    # in the short term
    
    

    # Create target directory
    
    if(! file.exists(getMergeDir(directory))) {
        dir.create(getMergeDir(directory))
    }
    
    
    if(! file.exists(getMergeDirInertial(directory))) {
        dir.create(getMergeDirInertial(directory))
    }
    
    
    for(f in getFilesRoot()) {
        f1 <- paste(directory, "/test/", f, "_test.txt", sep="")
        f2 <- paste(directory, "/train/", f, "_train.txt", sep="")
        merged <- paste(getMergeDir(directory), "/", f, "_merged.txt", sep="")
        mergeOneFile(f1, f2, merged)
    }

    for(f in getFilesInertialSignals()) {
        f1 <- paste(directory, "/test/Inertial Signals/", f, "_test.txt", sep="")
        f2 <- paste(directory, "/train/Inertial Signals/", f, "_train.txt", sep="")
        merged <- paste(getMergeDirInertial(directory), "/", f, "_merged.txt", sep="")
        mergeOneFile(f1, f2, merged)
    }
    
}

analyze_data_frame <-function(df) {
    columns <- names(df)
    df <- null
    for (col in columns) {
        stdev <- sd(df[,col])
        
    }
}

getActivities <- function(start_dir) {    
    label_names <- read.table(paste(start_dir, "/activity_labels.txt", sep =""), col.names=c("Numbers", "Activities"))
    labels <- read.table(paste(getMergeDir(start_dir), "/y_merged.txt", sep=""), col.names=c("Numbers"))
    merge(labels, label_names)$Activities        
}

getSubjects <- function(start_dir) {
    subjects <- read.table(paste(getMergeDir(start_dir), "/subject_merged.txt", sep=""), col.names=c("Subjects"), head=T)
    data.frame(subjects)
}

getOneVariableSet <- function(filenameBase) {
    filename <- paste("UCI_HAR_Dataset/merged/Inertial Signals/", filenameBase, "_merged.txt", sep="")
    meanName <- paste("mean_", filenameBase, sep="")
    sdName <- paste("stddev_", filenameBase, sep="")
    df <- read.table(filename, header=T)
    sds <- rowSds(df)
    means <- rowMeans(df)
    df2 <- data.frame(meanName = means, sdName = sds)
    # Have to use what the variable contains, not the name of the variable
    names(df2) <- c(meanName, sdName)
    df2    
}

makeAnalyzedDataFrame <- function(dirRoot) {
    
    df <- cbind(getSubjects(dirRoot), getActivities(dirRoot)) 
    names(df) <- c("Subject", "Activity")
    for (file in getFilesInertialSignals()) {
        df2 <- getOneVariableSet(file)
        df <- cbind(df, df2)
    }
    df
}

summarizeAnalyzedDataFrame <- function(dfInput) {
    query <- paste(
        "select Subject, activity,",
        "avg(mean_body_acc_x) as avg_mean_body_acc_x,",
        "avg(mean_body_acc_y) as avg_mean_body_acc_y, ",
        "avg(mean_body_acc_z) as avg_mean_body_acc_z, ",
        "avg(mean_body_gyro_x) as avg_mean_body_gyro_x,",
        "avg(mean_body_gyro_y) as avg_mean_body_gyro_y, ",
        "avg(mean_body_gyro_z) as avg_mean_body_gyro_z, ",
        "avg(mean_total_acc_x) as avg_mean_total_acc_x,",
        "avg(mean_total_acc_y) as avg_mean_total_acc_y, ",
        "avg(mean_total_acc_z) as avg_mean_total_acc_z ",        
        "from df group by Subject, activity order by activity, Subject"                           
        )
        
    sqldf(query)
}

run_analysis <- function() {
    library(genefilter)
    start_dir <- "UCI_HAR_Dataset"
    #   print("Merging files, please wait this will take several seconds")
    #   mergeFiles(start_dir)
    #   print("File merge complete")
    print("Performing Analysis, this could take a while too, so hang in there...")
    df <- makeAnalyzedDataFrame(df)
}

