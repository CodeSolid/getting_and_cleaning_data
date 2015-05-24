# Analyzed Data for Coursera's Getting and Cleaning Data

## Background

Course shout out:  [Getting and Cleaning Data](https://www.coursera.org/course/getdata)

This repository analyzes "wearable computer" data, specifically, data created to anaylze
activities using smart phone data.  The data was originally obtained from [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The source data for the project was obtained from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  The "get_data.R" file in this repository
was created and used to download and unzip the data into a directory named "UCI_HAR_Dataset"

## Scope of the Task

Our task was as follows (from the project assignment):

<blockquote>
You should create one R script called run_analysis.R that does the following. 
<ol>
<li>Merges the training and the test sets to create one data set.</li>
<li>Extracts only the measurements on the mean and standard deviation for each measurement.</li>
<li>Uses descriptive activity names to name the activities in the data set</li>
<li>Appropriately labels the data set with descriptive variable names.</li>
<li>From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.</li>
</blockquote>

Note that our analysis focused primarily on the files in the "Inertial Signals" directory
of the test and training data sets.  The "features" data (see features_info.txt, 
X_test.txt and X_train.txt, were excluded.  One reason was to focus our analysis on the original
source data, rather than re-analyzing data that was already processed.  Also, although 
it made sense to take the "mean and standard deviation for each measurement" (Step 2) as
a row average, for features, each row represented a variety of different calculations, 
so taking a row average made no sense in this context.  

Note, however, that in case there is a need to further analyze features data in the future, 
a merge-able features file is provided as "features_with_subjects_and_activities.txt".
See the functions get_features and create_and_save_features_table in run_analysis.R 
for more details.  

## The analysis

The run_analysis.R file is in this repository.  Note that the biocLite "genefilter" 
library was used, so in order to run run_analysis.R successfully, you'll likely need to 
install this first, as follows:

<pre>
source("http://bioconductor.org/biocLite.R")
biocLite("genefilter")
</pre>

run_analysis.R is fairly heavily commented, but here's a quick run-down.  First, some utility 
functions list the "base" name for each filename to be analyzed in the training and test directories.  
This is essentially the filename minus the "_train.txt" or "_test.txt" component.  
With these utility functions, one can loop through each file to be analyzed, rbinding 
the test and train file into a "_merged.txt" file in the merged directory.

With these files, it's possible to run the analysis in step two of the assignment 
with the function "makeAnalyzedDataFrame".  This step creates an intermediate
data frame containing the subject, the activity, and the mean and stddev calculation 
for each file in the "Inertial Signals directory".  We save this intermediate data frame 
with to the file "intermediateDataTable.txt".  

From this dataframe additional analysis is done, and the results are grouped by 
Subject and Activity, so that there is a mean for each value for each subject and 
activity.  Since not every subect has data for every activity, 
and since we are summarizing again, this results in a much smaller number of rows 
compared to the original data set, but we cross checked the result by running a more 
simple count grouped the same way.  We store this result as analyzed.txt.  

## The results
The codebook for the final result file (analzyzed.txt) is in the file, 
[Analyzed_txt.md](Analyzed_txt.md).  Other files that are available 
for review are the file containing the intermediate steps (intermediateDataTable.txt)
and the mergeable features file (features_with_subjects_and_activities.txt).