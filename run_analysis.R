
#Downloading of the file
url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "zipfile.zip")

#Unzipping the folder
unzip("zipfile.zip")

#Getting all "train" tables in R
x_train <- read.table("UCI HAR Dataset\\train\\X_train.txt")
y_train <- read.table("UCI HAR Dataset\\train\\Y_train.txt")
subject_train <- read.table("UCI HAR Dataset\\train\\subject_train.txt")

#Getting all "test" tables in R
x_test <- read.table("UCI HAR Dataset\\test\\X_test.txt")
y_test <- read.table("UCI HAR Dataset\\test\\Y_test.txt") 
subject_test <- read.table("UCI HAR Dataset\\test\\subject_test.txt")

#Getting features and activity labels in R
features <- read.table("UCI HAR Dataset\\features.txt")
activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt")

#Binding of the "train" and "test" tables
x_bind <- rbind(x_train,x_test)
y_bind <- rbind(y_train,y_test)
subject_bind <- rbind(subject_train,subject_test)

#Giving the right names to all the columns
colnames(x_bind) <- features[,2]
colnames(y_bind) <- "activityId"
colnames(subject_bind) <- "subject"
colnames(activity_labels) <-c("activityId","activityName")

#Selecting the columns that are about "mean" ands "std"
meanAndStdDS <- x_bind[,grep("mean|std",features[,2])]

#Binding the activities and subjects with the rest of the data set
xysub_bind <- cbind(meanAndStdDS,y_bind,subject_bind)

#Giving meaningfull names to the activities
final_set <- merge(xysub_bind,activity_labels,by.x = "activityId",by.y = "activityId")

#Calculation of the means asked in the assignement. There is one row per activityName/subject
#combination and they are ordered by subject first and activityName second.
secondSet <- aggregate(.~activityName + subject, final_set,mean)

#Creating the dataset required for submission
write.table(secondSet,"secondSet.txt")
