# Return the directory created by get_data (see get_data.R), or 
# if that directory doesn't exist, stop and give error.
get_directory <- function() {
    dir <- "UCI_HAR_Dataset"
    if(! file.exists(dir)) {
        msg <- paste("File UCI_HAR_Dataset does not exist.",
            "Make sure that getwd() returns the root of directory of the",
            "project and that you ahve run get_data.R's get_data() to populate",
            "the directory.\n", sep="\n")        
        stop(msg)
    }
    dir
}

# Given two source files, one in the test directory and one in the train 
# directory, merge (rbind) them and save them to the target filename in the
# merged directory
merge_one_file <- function (testFile, trainFile, target) {
    print(paste("Merging file:", target))
    df1 <- read.table(testFile)
    df2 <- read.table(trainFile)    
    merged <- rbind(df1, df2)
    write.table(merged, target, row.names=F)
}

# Create a directory string for the "/merged" subdirectory at the same 
# level as test and train
get_merge_dir <- function() {
    paste(get_directory(), "/merged", sep="")
}
# Create a directory string for the "/merged/Inertial Signals" subdirectory at 
# the same level as "Inertial Signls" in test and train
get_merge_dir_inertial <- function() {
    paste(get_directory(), "/merged/Inertial Signals", sep = "")
}

# Return a vector with the base part of filenames in root directory of test, 
# train. The base part is the part without "_test.txt" or "_train.txt", 
# depending on the location
get_files_root <- function() {
    c("subject", "X", "y")
}

# Return a vector with the base part of filenames in "Inertial Signals" 
# sub-directory of test, train. The base part is the part without 
# "_test.txt" or "_train.txt", depending on the location
get_files_inertial_signals <- function() {
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
merge_files <- function() {
    
    directory <- get_directory()
    
    # Create target directories
    if(! file.exists(get_merge_dir())) {
        dir.create(get_merge_dir())
    }    
    
    if(! file.exists(get_merge_dir_inertial())) {
        dir.create(get_merge_dir_inertial())
    }    

    for(f in get_files_root()) {
        f1 <- paste(directory, "/test/", f, "_test.txt", sep="")
        f2 <- paste(directory, "/train/", f, "_train.txt", sep="")
        merged <- paste(get_merge_dir(), "/", f, "_merged.txt", sep="")
        merge_one_file(f1, f2, merged)
    }

    for(f in get_files_inertial_signals()) {
        f1 <- paste(directory, "/test/Inertial Signals/", f, "_test.txt", sep="")
        f2 <- paste(directory, "/train/Inertial Signals/", f, "_train.txt", sep="")
        merged <- paste(get_merge_dir_inertial(), "/", f, "_merged.txt", sep="")
        merge_one_file(f1, f2, merged)
    }
    
}

# Returns a dataframe with the rows representing the activities.  Merge the 
# files so that we have the activity names, not the numbers
# Parameter directory:  UCI_HAR_Dataset, under which "test" and "train" 
# directories are assumed to exist.  See the file and function "get_data"
# for how the UCI_HAR_Dataset directory is created from the original
# source downloads.
get_activities <- function() {
    directory <- get_directory()
    label_names <- read.table(paste(directory, "/activity_labels.txt", sep =""), 
        col.names=c("Numbers", "Activities"))
    labels <- read.table(paste(get_merge_dir(), "/y_merged.txt", sep=""), 
        col.names=c("Numbers"))
    merge(labels, label_names)$Activities        
}

# Returns a dataframe with the rows representing the subjects
get_subjects <- function() {    
    subjects <- read.table(paste(get_merge_dir(), "/subject_merged.txt", sep=""), 
        col.names=c("Subjects"), head=T)
    data.frame(subjects)
}

# Given a filename base in a directory (rootDir), 1) read the read the file 
# into a dataframe, 2) then using that dataframe, create and return 
# a new dataframe with two columns, the mean of each row for the df in step
# one and the stand deviation of each row for the df in step 1.  Label
# the columns with a name that includes the filename base so we'll know 
# where these values came from when we cbind this variable set and others 
# together
get_one_variable_set <- function(filenameBase, 
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
make_analyzed_data_frame <- function() {    
    df <- cbind(get_subjects(), get_activities())     
    names(df) <- c("Subject", "Activity")
    for (file in get_files_inertial_signals()) {
        df2 <- get_one_variable_set(file)
        df <- cbind(df, df2)
    }
    df
}

# Summarize the dataFrame created by make_analyzed_data_frame into a dataFrame
# consisting of a "second, independent tidy data set with the average of each 
# variable for each activity and each subject."
summarize_analyzed_data_frame <- function(dfInput) {
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
        "from dfInput group by Subject, activity order by activity, Subject"                           
        )
        
    sqldf(query)
}

# Factor out so intermediate data read and write 
# functions are working on the same file
get_intermediate_data_frame_filename <- function() {
    "intermediateDataTable.txt"
}

# Save the merged data before doing final analysis
write_intermediate_data_frame <- function(df) {
    file <- get_intermediate_data_frame_filename()
    write.table(df, file, row.names=FALSE)
}

# Reads the intermediate data.  Not actually
# used by run_analysis, but handy given we've 
# provided write_intermediate_file_data_frame
read_intermediate_data_frame <- function() {
    file <- get_intermediate_data_frame_filename()
    read.table(file, header=T)
}

# Returns a vector of descriptive names for the features
# data (i.e., X_merged.txt)
get_feature_names <- function() {
    file <- paste(get_directory(), "/features.txt", sep="")
    df <- read.table(file, col.names=c('index', 'name'))    
    lnames <- as.vector(df$name)
    lnames
}

# Returns the X_merged "feature data" with more descriptive
# columns than in the original, and in a way that might be merged
# with "analyzed.txt" via the shared columns "Subject"
# and activity 
get_features <- function() {
    # Get the features only
    directory <- get_directory()
    names <- get_feature_names()
    featuresFile <- paste(get_merge_dir(), "/X_merged.txt", sep="")
    features <- read.table(featuresFile, header=T, skip=0, col.names = names)    
    features
    
    # Prepend the subjects and activities so we could use this to merge 
    # with the result of run_analysis if desired.
    dfAll <- cbind(get_subjects(), get_activities())
    names(dfAll) <- c("Subject", "Activity")
    dfAll <-cbind(dfAll, features)
    dfAll    
}

# Saves the features file - see get_features for format.
create_and_save_features_table <-function() {
    features <- get_features()
    filename <- "features_with_subjects_and_activities.txt"
    write.table(features, file=filename, row.names=F)
    
}

# Merge the "train" and "test" data files as per the instructions 
# (See README.md for details), writes an intermediate analysis 
# with the rows means, then analyzes and writes the finaly file.
run_analysis <- function() {
    library(genefilter)
    library(sqldf)
    print("Merging files, please wait this will take several seconds...")
    merge_files()
    print("File merge complete")
    print("Performing Analysis, this could take a few seconds too...")
    df <- make_analyzed_data_frame()
    write_intermediate_data_frame(df)
    dfSummarized <- summarize_analyzed_data_frame(df)
    write.table(dfSummarized, file = "analyzed.txt")
    print("Analysis complete, see 'analyzed.txt' for results")
}

