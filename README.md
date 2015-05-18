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

Note that we focused our analysis primarily on the files in the "Inertial Signals" directory
of the test and training data sets.  We excluded the "features" data (see features_info.txt, 
X_test.txt and X_train.txt.  One reason was to focus our analysis on the original
source data, rather than re-analyzing data that was already processed.  A second reason was 
to time-box our effort to something like the nine-hour weekly maximum suggested for the course.
Including the features data would have significantly added to the time scope without a 
concommittant benefit in what was learned, so it is left as a possible future enhancement.

## The analysis

The run_analysis.R file is in this repository.  Note that we used the biocLite "genefilter" 
library, so in order to run run_analysis.R successfully, you'll likely need to install this first, as follows:

<pre>
source("http://bioconductor.org/biocLite.R")
biocLite("genefilter")
</pre>

run_analysis.R is fairly heavily commented, but here's a quick run-down.  First, we create utility functions to list the "base" name for each filename we want to analyze in the training and test directories.  This is essentially the filename minus the "_train.txt" or "_test.txt" component.  With these utility functions, we're able to loop through each file
we want to analyze, rbinding the test and train file into a "_merged.txt" file in the merged
directory.

With these files, we're able to run the analysis in step two of the assignment with the function "makeAnalyzedDataFrame".  This step creates an intermediate
data frame containing the subject, the activity, and the mean and stddev calculation for each file in the "Inertial Signals directory".  We save this intermediate data frame 
with to the file "intermediateDataTable.txt".  From this dataframe we do additional analysis, grouping the results by Subject and activity, so that we have a mean for each value 
for each subject and activity.  Since not every subect has data for every activity, and since we are summarizing again, this results in a much smaller number of rows compared to the original data set, but we cross checked the result by running a more simple count grouped the same way.  We store this result as analyzed.txt.  
## The results
The codebook for the final result file (analzyzed.txt) is in the file, [Analyzed_txt.md](Analyzed_txt.md)
