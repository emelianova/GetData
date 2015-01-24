Project goal was to create a script that does the following: (taken from [here](https://class.coursera.org/getdata-010/human_grading/view/courses/973497/assessments/3/submissions))  
1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
3. Uses descriptive activity names to name the activities in the data set.  
4. Appropriately labels the data set with descriptive variable names.   
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

Before run this script you need to install `tidyr` and `plyr` packages, if you haven't done it yet.  
##### Downloading the data
`UCI HAR Dataset` folder is supposed to be in your working directory. If it isn't there, script will download and unzip this folder.
##### Step 1 - Merge
Script extracts training and test subsets of subjects, activities and actual measures and binds them by row. Now we have 3 data frames with 10299 obs. in each. Data frame with measurements contains 561 variables.  
##### Step 2 - Extract  
In order to get variable names script reads `features.txt`. The regular expression `-(mean|std)[(]` is used to get indices of columns with mean and standard deviation. Resulting vector is used to filter variable names and measurement columns. Now there are 66 of them.  
##### Step 3 - Activity names  
Script spreads 6 activity indicators into 6 columns, assigns corresponding activity names to these columns and gathers them back. We need only the first column of the resulting data frame.  
##### Step 4 - Variable names
Parentheses, dashes and mistakes like "BodyBody" are removed. `Subject` and `Activity` variables are attached to the bulk of data. 
##### Step 5 - Second data set
Average by groups is taken with `ddply` function, result is stored in a new object. As far as I understand, column names here are actually variables, so it makes sense to gather them into one column and separate. It's easy to use point as a separator; possible strategy for the rest of variables is to paste commas afore uppercase letters and separate by commas.  
Mean and standard deviation are spreaded back - I suppose these could be the actual column names.
##### Variables
`Activity`: activity performed while taking measurements (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STAYING, LAYING).  
`Subject`: subject ¹.  
`Type` is not really a variable, it is composed of five variables: domain (t - time, f - frequency), source (Body - human body, Gravity - gravity), signal (Acc - from the accelerometer, Gyro - from the gyroscope), jerk (Jerk - yes, NA - no), and magnitude (Mag - yes, NA - no).  Why haven't I split them? Too sleepy to think about regular expressions. This variable makes the dataset a bit messy.   
`Coordinate` - coordinate in 3D space - X, Y, Z or NA (where it's not applicable).  
`mean` - mean.  
`std` - standard deviation.  
Note: all measurements were standardized.  