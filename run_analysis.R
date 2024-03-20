library(reshape2)

## set the local downloaded file name
localUCIFile <- "dataset_UCI.zip"

## check the local file, if not exist,  then download it
if (!file.exists(localUCIFile)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, localUCIFile)
}  

## check if the zip -- being unizip, then unzip it
zip_path = "UCI HAR Dataset"
if (!file.exists(zip_path)) { 
  unzip(localUCIFile) 
}


# load activity label data
activityLabelsDat <- read.table( paste(zip_path, sep="/", "activity_labels.txt") )
# check the data
head(activityLabelsDat)

# load feature data
featureDat <- read.table( paste(zip_path, sep="/", "features.txt") )
# check the data
head(featureDat)

# Filter the features so that only features with name "std" "mean" are selected
featuresSelected <- grep("mean|std", featureDat[,2])
features_names <- featureDat[featuresSelected, 2]
features_names <- gsub('[-()]', '', features_names)


# load the train data
trainDat <- read.table( paste(zip_path, "train", "X_train.txt", sep="/") )
# filter out others features (columns )from the train data
train <- trainDat[, featuresSelected]

# load activies and subjects from the train data
trainActivities <- read.table( paste(zip_path, "train", "y_train.txt", sep="/") )
trainSubjects <- read.table( paste(zip_path, "train", "subject_train.txt", sep="/") )

# combine (train, trainActivities, trainSubjects) into one data frame
train <- cbind(trainSubjects, trainActivities, train)


# do the same as train for the test data
# load the test data
testDat <- read.table( paste(zip_path, "test", "X_test.txt", sep="/") )
# filter out others features (columns )from the test data
test <- testDat[, featuresSelected]

# load activies and subjects from the test data
testActivities <- read.table( paste(zip_path, "test", "y_test.txt", sep="/") )
testSubjects <- read.table( paste(zip_path, "test", "subject_test.txt", sep="/") )

# combine (test, testActivities, testSubjects) into one data frame
test <- cbind(testSubjects, testActivities, test)

# merge train and test datasets and add column names
allDat <- rbind(train, test)
colnames(allDat) <- c("subject", "activity", features_names)

# factorize the (subject, activity) variables using the descriptive names
allDat$activity <- factor(allDat$activity, levels = activityLabelsDat[,1], labels = activityLabelsDat[,2])
allDat$subject <- as.factor(allDat$subject)

# create a second tidy data set
tidyDat <- melt(allDat, id=c("subject", "activity"))
# get the mean for each ("subject","activity")
tidyMean <- dcast(tidyDat, subject + activity ~ variable, mean)

# write the out table
write.table(tidyMean, "tidyMean.txt", row.names = FALSE, quote = FALSE)
