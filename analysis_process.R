library(dplyr)

# Training Data 
X_train <- read.table("/Users/aashaysharma/Desktop/RStudio/Week 4 Course Project/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("/Users/aashaysharma/Desktop/RStudio/Week 4 Course Project/UCI HAR Dataset/train/y_train.txt")
Sub_train <- read.table("/Users/aashaysharma/Desktop/RStudio/Week 4 Course Project/UCI HAR Dataset/train/subject_train.txt")

# Testing Data
X_test <- read.table("/Users/aashaysharma/Desktop/RStudio/Week 4 Course Project/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("/Users/aashaysharma/Desktop/RStudio/Week 4 Course Project/UCI HAR Dataset/test/y_test.txt")
Sub_test <- read.table("/Users/aashaysharma/Desktop/RStudio/Week 4 Course Project/UCI HAR Dataset/test/subject_test.txt")

# Column names from the features.txt file
col_names <- read.table("/Users/aashaysharma/Desktop/RStudio/Week 4 Course Project/UCI HAR Dataset/features.txt")

# Activity Labels from the activity_labels.txt file 
activity_labels <- read.table("/Users/aashaysharma/Desktop/RStudio/Week 4 Course Project/UCI HAR Dataset/activity_labels.txt")

# Binding the datasets by the rows to complete the data set
#first completing the X data set by rbinding test and train sets
X_total <- rbind(X_train, X_test)
#secondly completing the Y data set by rbinding test and train sets
Y_total <- rbind(Y_train, Y_test)
#finally combining the complete sets by rbinding the total X and Y data sets
total_set <- rbind(Sub_train, Sub_test)

#Extracting the measurements on the mean and standard deviation for each measurement.
selected_col <- col_names[grep("mean\\(\\)|std\\(\\)",col_names[,2]),]
X_total <- X_total[,selected_col[,1]]

#Uses descriptive activity names to name the activities in the data set
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

#Appropriately labels the data set with descriptive variable names.
colnames(X_total) <- col_names[selected_col[,1],2]

# From the data set in above step creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(total_set) <- "subject"
total <- cbind(X_total, activitylabel, total_set)
total_mean <- total  %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "/Users/aashaysharma/Desktop/RStudio/Week 4 Course Project/UCI HAR Dataset/tidyData.txt", row.names = FALSE, col.names = TRUE)