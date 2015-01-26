if (!file.exists("UCI HAR Dataset")) {
        URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(URL, destfile="smart.zip")
        unzip("smart.zip")
}

data<- read.table("UCI HAR Dataset/train/X_train.txt")           # Step 1
data<- rbind(data, read.table("UCI HAR Dataset/test/X_test.txt"))

subject<- read.table("UCI HAR Dataset/train/subject_train.txt")
subject<- unlist(rbind(subject, read.table("UCI HAR Dataset/test/subject_test.txt")))

activity<- read.table("UCI HAR Dataset/train/y_train.txt")
activity<- rbind(activity, read.table("UCI HAR Dataset/test/y_test.txt"))                       

names(data)<- unlist(read.table("UCI HAR Dataset/features.txt",     # Step 2  
                                colClasses="character")[,2])    
colnums<- grep("-(mean|std)[(]", names(data))                     
data<- data[, colnums]                                       

library(tidyr)                                                   # Step 3
activity<- spread(activity, V1, V1)
colnames(activity)<- c("walking", "walkingup", "walkingdown","sitting", "staying", "laying")
activity<- gather(activity, activity, value, na.rm=TRUE)[,1]   

names(data)<- gsub("[()]", "", names(data))                            # Step 4
names(data)<- gsub("BodyBody", "Body", names(data)) 
names(data)<- gsub("[-]", ".", names(data))
data$subject<- subject
data$activity<- activity

library(plyr) 
tidy<- ddply(data, .(activity, subject), numcolwise(mean))            # Step 5
tidy<- gather(tidy, type, value, tBodyAcc.mean.X:fBodyGyroJerkMag.std)
tidy<- separate(tidy, type, into=c("type", "estimator", "coordinate"), sep="[.]",
                extra="merge")
tidy$type<- tolower(gsub("([^k])([A-Z])", "\\1,\\2", tidy$type))
tidy<- separate(tidy, type, into=c("domain", "source", "signal", "jerkmag"), 
                sep=",", extra="merge")
tidy<- spread(tidy, estimator, value)

write.table(tidy, file="final.txt", row.names=F)