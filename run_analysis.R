mergeOneFile <- function (srcFile1, srcFile2, target) {
    # Lines for debugging...
    # print(paste("Merging files", srcFile1, "and", srcFile2, "to", target))
    # print(paste(srcFile1, file.exists(srcFile1)))
    # print(paste(srcFile2, file.exists(srcFile2)))
    
    df1 <- read.table(srcFile1)
    df2 <- read.table(srcFile2)
    # Test first development, get it?  No seriously, test data first, train
    # data on the bottom
    merged <- rbind(df1, df2)
    write.table(merged, target)
    
}

getMergeDir <- function(dirRoot) {
    paste(dirRoot, "/merged", sep="")
}

getMergeDirInertial <- function(dirRoot) {
    paste(dirRoot, "/merged/Inertial Signals", sep = "")
}

mergeFiles <- function(directory) {
    # Hard coded lists of file roots we need to operate on.
    # Todo this could be made generic, but this implementation was easier
    # in the short term
    filesRoot <- c("subject", "X", "y")
    filesInertialSignals <- c(
        "body_acc_x",  "body_acc_y",  "body_acc_z", 
        "body_gyro_x", "body_gyro_y", "body_gyro_z",
        "total_acc_x", "total_acc_y", "total_acc_z")

    # Create target directory
    mergeDir <- paste(directory, "/merged", sep="")
    if(! file.exists(mergeDir)) {
        dir.create(mergeDir)
    }
    
    mergeDirInertial <- paste(mergeDir, "/Inertial Signals", sep="")
    if(! file.exists(mergeDirInertial)) {
        dir.create(mergeDirInertial)
    }
    
    
    for(f in filesRoot) {
        f1 <- paste(directory, "/test/", f, "_test.txt", sep="")
        f2 <- paste(directory, "/train/", f, "_train.txt", sep="")
        merged <- paste(mergeDir, "/", f, "_merged.txt", sep="")
        mergeOneFile(f1, f2, merged)
    }

    for(f in filesInertialSignals) {
        f1 <- paste(directory, "/test/Inertial Signals/", f, "_test.txt", sep="")
        f2 <- paste(directory, "/train/Inertial Signals/", f, "_train.txt", sep="")
        merged <- paste(mergeDirInertial, "/", f, "_merged.txt", sep="")
        mergeOneFile(f1, f2, merged)
    }
    
}

run_analysis <- function() {
    
}