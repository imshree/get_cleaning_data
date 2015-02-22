## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

if (!require("reshapw2")) {
    install.packages("reshape2")
}

if (!require("data.table")) {
    install.packages("data.table")
}

require("reshape2")
require("data.table")

#get activity labels
act_labels <- read.table("UCI HAR Dataset 3/activity_labels.txt")[,2]

#get column names
features <- read.table("UCI HAR Dataset 3/features.txt")[,2]

#extract only the measurements
extract_features <- grepl("mean|std", features)

#load and process X_test and y_test
X_test <- read.table("UCI HAR Dataset 3/test/X_Test.txt")
Y_test <- read.table("UCI HAR Dataset 3/test/y_Test.txt")

names(X_test) = features

# Extract only the measurements on the mean and standard deviation
X_test = X_test[,extract_features]

#Load activity labels
y_test[,2] = act_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

#Bind data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Load and process X_train & y_train data
X_train <- read.table("UCI HAR Dataset 3/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset 3/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset 3/train/subject_train.txt")

names(X_train) = features

# Extract only the measurements on the mean and standard deviation
X_train = X_train[,extract_features]

#load activity data
y_train[,2] = act_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

#Bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

#merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tidy_data, file = "tidy_data.txt")


