#run_analysis.R
#By: RGDK
#Date: 23/06/2014

#Address directive 1. Merge the training and the test sets to create one data set.

#extract the test data into the test_data data frame and the train data into the train_data data frame
test_data <- read.csv("./test/X_test.txt", sep="", colClasses="numeric", header = FALSE)
train_data <- read.csv("./train/X_train.txt", sep="", colClasses="numeric", header = FALSE)

#extract the test and train activity data into the test_data_activities and train_data_activities data frames 
test_data_activities <- read.csv("./test/y_test.txt", sep="", header = FALSE)
train_data_activities <- read.csv("./train/y_train.txt", sep="", header = FALSE)

#rename the sole column within both test_data_activities and train_data_activities data frames to activity_id
colnames(test_data_activities) <- c("activity_id")
colnames(train_data_activities) <- c("activity_id")

#extract the test and train subject data into the test_data_subject and train_data_subject data frames
test_data_subject <- read.csv("./test/subject_test.txt", sep="", header = FALSE)
train_data_subject <- read.csv("./train/subject_train.txt", sep="", header = FALSE)

#rename the sole column within both test_data_subject and train_data_subject data frames to subject_id
colnames(test_data_subject) <- c("subject_id")
colnames(train_data_subject) <- c("subject_id")

# extract and store the activity column labels into the activity_labels data frame
activity_labels <- read.csv("./activity_labels.txt", sep="", header = FALSE)

# extract and store the features column labels into the features data frame
features <- read.csv("./features.txt", sep="", header = FALSE)

#rename the columns in the activity_labels data frame
colnames(activity_labels) <- c("activity_id","activity")

#rename the columns in the features data frame
colnames(features) <- c("feature_id","feature")

#Address directive 3. Use descriptive activity names to name the activities in the data set

#add a column that contains the test activity description based on the activity_id then remove the id column
test_data_activities_lbl <- merge(test_data_activities, activity_labels, by="activity_id")
test_data_activities_lbl$activity_id <- NULL

#add a column that contains the train activity description based on the activity_id then remove the id column
train_data_activities_lbl <- merge(train_data_activities, activity_labels, by="activity_id")
train_data_activities_lbl$activity_id <- NULL

#merge the test_data_subject data frame with the test data frame
test_data <- cbind(test_data_subject,test_data)

#merge the train_data_subject data frame with the train data frame
train_data <- cbind(train_data_subject,train_data)

#merge the activities data frame with the test data frame
test_data <- cbind(test_data_activities_lbl,test_data)

#merge the activities data frame with the train data frame
train_data <- cbind(train_data_activities_lbl,train_data)

#concatenate the test and train data frames
all_data <- rbind(test_data,train_data)

#Address directive 4. Appropriately label the data set with descriptive variable names.

#The following renames the columns based on the feature 
for (i in 3:ncol(all_data)) {
  colnames(all_data)[i] <- as.character(features$feature[i-2])
}

#Address directive 2. Extract only the measurements on the mean and standard deviation for each measurement.

# derive and store the mean and standard deviation measure names only
mean_col_names <- data.frame()
stdev_col_names <- data.frame()

for (i in 3:ncol(all_data)) {
  #store the mean columns in a dedicated data frame 
  if (length(grep("mean()", colnames(all_data)[i], ignore.case = FALSE, fixed = TRUE)) > 0) { 
      mean_col_names <- rbind(mean_col_names, data.frame(colnames(all_data)[i]))
  }
  #store the standard deviation columns in a dedicated data frame 
  if (length(grep("std()", colnames(all_data)[i], ignore.case = FALSE, fixed = TRUE)) > 0) { 
      stdev_col_names <- rbind(stdev_col_names, data.frame(colnames(all_data)[i]))
  }
}

#extract and store these mean and standard deviation measures into
#  separate data frames

#set up the data frames with the correct number of rows
mean_data <- data.frame("row_num"=1:nrow(all_data))
sd_data <- data.frame("row_num"=1:nrow(all_data))

#bind the mean data columns together
for (i in 1:nrow(mean_col_names)) {
  mean_data <- cbind(mean_data,c(all_data[as.character(mean_col_names[i,])]))
}

#bind the sd data columns together
for (i in 1:nrow(stdev_col_names)) {
  sd_data <- cbind(sd_data,c(all_data[as.character(stdev_col_names[i,])]))
}

#delete the row_num column which was just an initial placeholder to 
#  establish the correct number of rows in the data frame 
mean_data$row_num <- NULL
sd_data$row_num <- NULL


#5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.
library(data.table)
all_data_tbl <- data.table(all_data)

#ensure we don't calculate the means of the first 2 columns as they are descriptors
colsToInclude <- tail(names(all_data_tbl), -2)

#store the 2 data sets (means and standard deviations in 2 separate variables)
means_data <- all_data_tbl[, lapply(.SD, mean), .SDcols=colsToInclude, by=list(activity, subject_id)]

#we can output this data set to file as ordered data
write.csv(x=means_data[order(means_data$activity,means_data$subject_id)], file="means_data_by_subj_and_activity.txt")
