# 
# Assignment here:
# https://class.coursera.org/getdata-014/human_grading/view/courses/973501/assessments/3/submissions
#

# Get the data file, unzip it, and fix up the filenames.
get_data <- function() {
    print("Getting data, this may take a few minutes...")
    download.file(url = 
        "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
        destfile="dataset.zip", method="curl")    
    print("Unzipping data...")
    unzip("dataset.zip")
    print("Renaming data")
    file.rename("UCI HAR Dataset", "UCI_HAR_Dataset")
    print("Done -- see UCI_HAR_Dataset directory for data.")
}