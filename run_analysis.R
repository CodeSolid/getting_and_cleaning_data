# Given two source files, one in the test directory and one in the train 
# directory, merge (rbind) them and save them to the target filename in the
# merged directory
mergeOneFile <- function (testFile, trainFile, target) {
    print(paste("Merging file:", target))
    df1 <- read.table(testFile)
    df2 <- read.table(trainFile)    
    merged <- rbind(df1, df2)
    write.table(merged, target, row.names=F)
}

# Create a directory string for the "/merged" subdirectory at the same 
# level as test and train
getMergeDir <- function(directory) {
    paste(directory, "/merged", sep="")
}
# Create a directory string for the "/merged/Inertial Signals" subdirectory at 
# the same level as "Inertial Signls" in test and train
getMergeDirInertial <- function(directory) {
    paste(directory, "/merged/Inertial Signals", sep = "")
}

# Return a vector with the base part of filenames in root directory of test, 
# train. The base part is the part without "_test.txt" or "_train.txt", 
# depending on the location
getFilesRoot <- function() {
    c("subject", "X", "y")
}

# Return a vector with the base part of filenames in "Inertial Signals" 
# sub-directory of test, train. The base part is the part without 
# "_test.txt" or "_train.txt", depending on the location
getFilesInertialSignals <- function() {
    c(
        "body_acc_x",  "body_acc_y",  "body_acc_z", 
        "body_gyro_x", "body_gyro_y", "body_gyro_z",
        "total_acc_x", "total_acc_y", "total_acc_z")
}

# Using the helper functions above, create a "merged" directory structure
# and merge each file with the rows from "test" on top and "train" on the 
# bottom.  Save each new file in the merged directory.  
# Parameter directory:  UCI_HAR_Dataset, under which "test" and "train" 
# directories are assumed to exist.  See the file and function "get_data"
# for how the UCI_HAR_Dataset directory is created from the original
# source downloads.
mergeFiles <- function(directory) {
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

# Returns a dataframe with the rows representing the activities.  Merge the files 
# so that we have the activity names, not the numbers
# Parameter directory:  UCI_HAR_Dataset, under which "test" and "train" 
# directories are assumed to exist.  See the file and function "get_data"
# for how the UCI_HAR_Dataset directory is created from the original
# source downloads.

getActivities <- function(directory) {    
    label_names <- read.table(paste(directory, "/activity_labels.txt", sep =""), col.names=c("Numbers", "Activities"))
    labels <- read.table(paste(getMergeDir(directory), "/y_merged.txt", sep=""), col.names=c("Numbers"))
    merge(labels, label_names)$Activities        
}

# Returns a dataframe with the rows representing the subjects
getSubjects <- function(directory) {
    subjects <- read.table(paste(getMergeDir(directory), "/subject_merged.txt", sep=""), col.names=c("Subjects"), head=T)
    data.frame(subjects)
}

# Given a filename base in a directory (rootDir), 1) read the read the file 
# into a dataframe, 2) then using that dataframe, create and return 
# a new dataframe with two columns, the mean of each row for the df in step
# one and the stand deviation of each row for the df in step 1.  Label
# the columns with a name that includes the filename base so we'll know 
# where these values came from when we cbind this variable set and others 
# together
getOneVariableSet <- function(filenameBase, 
            rootDir = "UCI_HAR_Dataset/merged/Inertial Signals/") {
    filename <- paste(rootDir, filenameBase, "_merged.txt", sep="")
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

# Using the helper functions defined so far, create a single dataframe with
# the subjects, activities, and the mean and standard deviation for
# each of the measurements.  directory = "UCI_HAR_Dataset".
#
# Note that we intentionally exclude the "features" data (X_merged.txt)
# based on the fact that it is already analyzed (i.e., not "source" activity
# data, and also in the interest of keeping the scope of this assignment
# within the nine hour weekly upper limit of time we should be spending on this,
# so I can finish the course without quitting my day job.
makeAnalyzedDataFrame <- function(directory) {    
    df <- cbind(getSubjects(directory), getActivities(directory))     
    names(df) <- c("Subject", "Activity")
    for (file in getFilesInertialSignals()) {
        df2 <- getOneVariableSet(file)
        df <- cbind(df, df2)
    }
    df
}

# Summarize the dataFrame created by makeAnalyzedDataFrame into a dataFrame
# consisting of a "second, independent tidy data set with the average of each 
# variable for each activity and each subject."
summarizeAnalyzedDataFrame <- function(dfInput) {
    query <- paste(
        "select Subject, activity,",
        "avg(mean_body_acc_x) as  mean_of_mean_body_acc_x,",
        "avg(mean_body_acc_y) as  mean_of_mean_body_acc_y, ",
        "avg(mean_body_acc_z) as  mean_of_mean_body_acc_z, ",
        "avg(mean_body_gyro_x) as mean_of_mean_body_gyro_x,",
        "avg(mean_body_gyro_y) as mean_of_mean_body_gyro_y, ",
        "avg(mean_body_gyro_z) as mean_of_mean_body_gyro_z, ",
        "avg(mean_total_acc_x) as mean_of_mean_total_acc_x,",
        "avg(mean_total_acc_y) as mean_of_mean_total_acc_y, ",
        "avg(mean_total_acc_z) as mean_of_mean_total_acc_z, ",        
        "avg(stddev_body_acc_x)  as mean_of_stdev_body_acc_x,",
        "avg(stddev_body_acc_y)  as mean_of_stdev_body_acc_y, ",
        "avg(stddev_body_acc_z)  as mean_of_stdev_body_acc_z, ",
        "avg(stddev_body_gyro_x) as mean_of_stdev_body_gyro_x,",
        "avg(stddev_body_gyro_y) as mean_of_stdev_body_gyro_y, ",
        "avg(stddev_body_gyro_z) as mean_of_stdev_body_gyro_z, ",
        "avg(stddev_total_acc_x) as mean_of_stdev_total_acc_x,",
        "avg(stddev_total_acc_y) as mean_of_stdev_total_acc_y, ",
        "avg(stddev_total_acc_z) as mean_of_stdev_total_acc_z ",    
        "from df group by Subject, activity order by activity, Subject"                           
        )
        
    sqldf(query)
}

getIntermediateDataFrameFilename <- function() {
    "intermediateDataTable.txt"
}

writeIntermediateDataFrame <- function(df) {
    file <- getIntermediateDataFrameFilename()
    write.table(df, file, row.names=FALSE)
}

readIntermediateDataFrame <- function() {
    file <- getIntermediateDataFrameFilename()
    read.table(df)
}

run_analysis <- function() {
    library(genefilter)
    directory <- "UCI_HAR_Dataset"
    print("Merging files, please wait this will take several seconds")
    mergeFiles(directory)
    print("File merge complete")
    print("Performing Analysis, this could take a while too, so hang in there...")
    df <- makeAnalyzedDataFrame(directory)
    writeIntermediateDataFrame(df)
    dfSummarized <- summarizeAnalyzedDataFrame(df)
    write.table(dfSummarized, file ="analyzed.txt")
    print("Analysis complete, see 'analyzed.txt' for results")
}

