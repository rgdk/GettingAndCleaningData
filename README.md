#An explanation of the run_analysis.R script

##Part 1
###Here the training and test sets are extracted into separate data frames:
- The test and trainining activity data sets are then read into the test_data_activities and train_data_activities data frames 
- The column within each of the test_data_activities and train_data_activities data frames are renamed to 'activity_id'
- The test and training subject data are then extracted into the test_data_subject and train_data_subject data frames
- The column within each test_data_subject and train_data_subject data frames are renamed to 'subject_id'
- The activity column labels are extracted and stored within the activity_labels data frame
- The features column labels are extracted and stored within the features data frame
- The columns in the activity_labels data frame are renamed to something more meaningful (activity_id and activity)
- The columns in the features data frame are renamed to something more meaningful (feature_id and feature)

##Part 2
###Here, descriptive activity names are used to name the activities in the data set
- A column that contains the test activity description based on the activity_id is added to the test activity data 
- Then the id column is removed
- A column that contains the training activity description based on the activity_id is added to the training activity data 
- Then the id column is removed
-The test_data_subject data frame is merged with the test_data frame
-The train_data_subject data frame is merged with the train_data frame
-The activities data frame is then merged with the test_data frame
-The activities data frame is also merged with the train_data frame
-The test and train data frames are then concatenated

##Part 3
###The data set is appropriately labelled with descriptive variable names.
-The columns in the merged data set are renamed based on the feature data frame

##Part 4
###Extract only the measurements on the mean and standard deviation for each measurement.
-Data frames to hold the means columns and standard deviation columns are separately set up
-The mean measure names only are derived from the existing features list and set as the rows for the mean_col_names data. This is based on mean-based measure containing 'mean()' in the name.
-The standard deviation measure names only are derived from the existing features list and set as the rows for the stdev_col_names data. This is based on standard deviation-based measure containing 'sd()' in the name.
-The mean and standard deviation measures are stored within separate data frames
-Blank data frames are set up for each of the mean and standard deviation measures with the correct number of rows
-The mean data are bound columns together
-The sd data columns are bound together
-The row_num column which was just an initial placeholder to establish the correct number of rows in the data frame is then removed from the column lists in each variable

##Part 5 
###A second, independent tidy data set with the average of each variable for each activity and each subject is then created.
-The data.table package is included in the library
-The resultant data set from part 3 is converted into a data.table so that we can perform some grouping calculations on the data
-A variable is set up to include only the names of the columns for which the means are required
-The means are calculated across all numeric columns and grouped by activity and subject
-The data is then output to file as ordered data
