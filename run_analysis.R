if (!file.exists("UCI HAR Dataset")) {
        URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(URL, destfile="smart.zip")
        unzip("smart.zip")
}

data<- read.table("UCI HAR Dataset/train/X_train.txt")           # Step 1
data_test<- read.table("UCI HAR Dataset/test/X_test.txt")
data<- rbind(data, data_test)

subject<- read.table("UCI HAR Dataset/train/subject_train.txt")
sub_test<- read.table("UCI HAR Dataset/test/subject_test.txt")
subject<- unlist(rbind(subject, sub_test))

activity<- read.table("UCI HAR Dataset/train/y_train.txt")
act_test<- read.table("UCI HAR Dataset/test/y_test.txt")
activity<- rbind(activity, act_test)                       

varnames<- unlist(read.table("UCI HAR Dataset/features.txt",     # Step 2  
                             colClasses="character")[,2])     
colnums<- grep("-(mean|std)[(]", varnames)                     
varnames<- varnames[colnums]
data<- data[, colnums]                                       

library(tidyr)                                                   # Step 3
activity<- spread(activity, V1, V1)
colnames(activity)<- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
"SITTING", "STAYING", "LAYING")
activity<- gather(activity, activity, value, na.rm=TRUE)[,1]   

varnames<- gsub("[()]", "", varnames)                            # Step 4
varnames<- gsub("BodyBody", "Body", varnames) 
varnames<- gsub("[-]", ".", varnames) 
colnames(data)<- varnames
data$Subject<- subject
data$Activity<- activity

library(plyr) 
tidy_avg<- ddply(data, .(Activity, Subject), numcolwise(mean))            # Step 5
tidy_avg<- gather(tidy_avg, type, Value, tBodyAcc.mean.X:fBodyGyroJerkMag.std)
tidy_avg<- separate(tidy_avg, type, into=c("Type", "Estimator", "Coordinate"), sep="[.]",
                     extra="merge")
tidy_avg<- spread(tidy_avg, Estimator, Value)
write.table(tidy_avg, file="final.txt", row.names=F)