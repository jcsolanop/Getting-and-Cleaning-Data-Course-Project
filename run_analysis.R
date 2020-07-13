#Coursera Getting and cleaning data Course
#Juan Camilo Solano
#

#Data reading

#First we fetch data from Train, creating one dataframe combining the data from
#the files
train = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
train[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
train[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

#Then we fetch data from Test, creating one dataframe combining the data from
#the files
test = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
test[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

#We create a dataframe with the activity names 
activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

# Read features and make the feature names better suited for R with some substitutions
features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

#Data Tidying

# Merge train and test data
rawdata = rbind(train, test)

# Extract data on mean and std. dev. because this is whats required, we use a
#vector to do it
columns <- grep(".*Mean.*|.*Std.*", features[,2])


# We discard the columns that are not going to be used
features <- features[columns,]

# Add the subject and activity columns to the columns vector
columns <- c(columns, 562, 563)

# And discard the unwanted columns from rawdata
rawdata <- rawdata[,columns]

# Add the column names (features) to rawdata
colnames(rawdata) <- c(features$V2, "Activity", "Subject")
colnames(rawdata) <- tolower(columns(rawdata))

#Add the activity to a column in rawdata
currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
        rawdata$activity <- gsub(currentActivity, currentActivityLabel, rawdata$activity)
        currentActivity <- currentActivity + 1
}

rawdata$activity <- as.factor(rawdata$activity)
rawdata$subject <- as.factor(rawdata$subject)

tidydata = aggregate(rawdata, by=list(activity = rawdata$activity, subject=rawdata$subject), mean)

# Remove the subject and activity column, since a mean of those has no use
tidydata[,89] = NULL
tidydata[,90] = NULL
write.table(tidydata, "tidydata.txt", sep="\t")
