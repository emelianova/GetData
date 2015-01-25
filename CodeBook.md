Project goal was to create a script that does the following (from [here](https://class.coursera.org/getdata-010/human_grading/view/courses/973497/assessments/3/submissions)):  
1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
3. Uses descriptive activity names to name the activities in the data set.  
4. Appropriately labels the data set with descriptive variable names.   
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

Before running this script you need to install `tidyr` and `plyr` packages, if you haven't done it yet.  
##### Downloading the data
`UCI HAR Dataset` folder is supposed to be in your working directory. If it isn't there, script will download and unzip this folder.
##### Step 1 - Merge
Script extracts training and test subsets of subjects, activities and actual measurements and binds them by row. Now we have 3 data frames with 10299 obs. in each. Data frame with measurements contains 561 variables.  
##### Step 2 - Extract  
In order to get variable names script reads `features.txt`. The regular expression `-(mean|std)[(]` is used to get the indices of columns with mean and standard deviation. Resulting vector is used to filter variable names and measurement columns. Now there are 66 of them.  
##### Step 3 - Activity names  
Script spreads 6 activity indicators into 6 columns, assigns corresponding activity names to these columns and gathers them back. We need only the first column of the resulting data frame.  
##### Step 4 - Variable names
Parentheses, dashes and mistakes like "BodyBody" are removed. `subject` and `activity` variables are attached to the bulk of data.   
##### Step 5 - Second data set
Average by groups is taken with `ddply` function, result is stored in a new object. As far as I understand, column names here are actually variables, so it makes sense to gather them into one column and separate.   
I know my separation process is not optimized at all, but I'm new to R. Firstly I use dots to separate coordinates and estimators (`.mean` and `.std`). Secondly I insert commas before capital letters (except for JerkMag combination) with regexpr `([^k])([A-Z])` and translate it all to lower case. Then separate again.  
Mean and standard deviation are spreaded back - I suppose these could be the actual column names.  
Final data set has 1155 obs. of 9 variables.
##### Variables
`activity`: activity performed while taking measurements (`walking`, `walkingup` - walking upstairs, `walkingdown` - walking downstairs, `sitting`, `staying`, `laying`)  
`subject`: subject number  
`domain`: `t` - time, `f` - frequency (obtained by Fourier transformation of respective signals)     
`source`: acceleration signal was splitted into `body` (human body) and `gravity` parts   
`signal`: `acc` - from the accelerometer, `gyro` - from the gyroscope  
`jerkmag`: `jerk` - jerk, `mag` - magnitude, `jerkmag` - both, NA - none of them.   
Jerk signals were obtained by derivation of body linear acceleration and angular velocity signals in time. Magnitude of these  signals were calculated using the Euclidean norm.  
`coordinate` - coordinate in 3D space - `X`, `Y`, `Z` or `NA` (where it's not applicable).  
`mean` - mean.  
`std` - standard deviation.  
Note: all measurements were standardized.  