# download the data zip
download.file(url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',destfile = './dataset.zip')

# unzip the data
unzip(zipfile = './dataset.zip')

# read in the features file
features <- read.table(file = './UCI HAR Dataset/features.txt')

# read in the activity labels file
labels <- read.table(file = './UCI HAR Dataset/activity_labels.txt')

# read in the training data set
df_x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')

# change the column name of the training data frame with the feature names
colnames(df_x_train) <- features[,2]

# create ids based on the number of rows in the training data frame
ids <- 1:nrow(df_x_train)

# add the id column to the training data frame
df_x_train <- cbind(id=ids,df_x_train)

# read in the training activity file
df_y_train <- read.table('./UCI HAR Dataset/train/Y_train.txt')

# change the column name in the training activity data frame to Activity
colnames(df_y_train) <- c('Activity')

# create ids based on the number of rows in the training activity data frame
ids <- 1:nrow(df_y_train)

# add the id column to the training activity data frame
df_y_train <- cbind(id=ids,df_y_train)

# read in the training subject file
df_subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')

# change the columm name in the training subject data frame to Subject
colnames(df_subject_train) <- c('Subject')

# create ids based on the number of rows in the training subject data frame
ids <- 1:nrow(df_y_train)

# add the id column to the training subject data frame
df_subject_train <- cbind(id=ids,df_subject_train)

# merge the training subject data frame with the training activity data frame by the id column
df_merge_train <- merge(df_subject_train,df_y_train,by = "id")

# merge this data frame with the training data frame by the id column
df_merge_train <- merge(df_merge_train, df_x_train, by ="id")

# read in the test data set
df_x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')

# change the column name of the test data frame with the feature names
colnames(df_x_test) <- features[,2]

# create ids based on the number of rows in the test data frame
ids <- 1:nrow(df_x_test)

# add the id column to the test data frame
df_x_test <- cbind(id=ids,df_x_test)

# read in the training activity file
df_y_test <- read.table('./UCI HAR Dataset/test/Y_test.txt')

# change the column name in the test activity data frame to Activity
colnames(df_y_test) <- c('Activity')

# create ids based on the number of rows in the test activity data frame
ids <- 1:nrow(df_y_test)

# add the id column to the test activity data frame
df_y_test <- cbind(id=ids,df_y_test)

# read in the training subject file
df_subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')

# change the columm name in the test subject data frame to Subject
colnames(df_subject_test) <- c('Subject')

# create ids based on the number of rows in the test subject data frame
ids <- 1:nrow(df_y_test)

# add the id column to the training subject data frame
df_subject_test <- cbind(id=ids,df_subject_test)

# merge the test subject data frame with the test activity data frame by the id column
df_merge_test <- merge(df_subject_test,df_y_test,by = "id")

# merge this data frame with the test data frame by the id column
df_merge_test <- merge(df_merge_test, df_x_test, by = "id")

# merge the training and the test data frames
df_merge <- rbind(df_merge_train,df_merge_test)

# extract all columns except the id column because it is no longer required
df_merge_mean_std <- df_merge[2:9]

# change the columns to be more descriptive
colnames(df_merge_mean_std) <- c('Subject','Activity','BodyAccelerationAverageXAxis','BodyAccelerationAverageYAxis','BodyAccelerationAverageZAxis','BodyAccelerationStdDevXAxis','BodyAccelerationStdDevYAxis','BodyAccelerationStdDevZAxis')

# change the numeric activity codes with the names of the activities
df_merge_mean_std$Activity[df_merge_mean_std$Activity==1] <- "WALKING"
df_merge_mean_std$Activity[df_merge_mean_std$Activity==2] <- "WALKING UPSTAIRS"
df_merge_mean_std$Activity[df_merge_mean_std$Activity==3] <- "WALKING DOWNSTAIRS"
df_merge_mean_std$Activity[df_merge_mean_std$Activity==4] <- "SITTING"
df_merge_mean_std$Activity[df_merge_mean_std$Activity==5] <- "STANDING"
df_merge_mean_std$Activity[df_merge_mean_std$Activity==6] <- "LAYING"

# order by subject and activity
df_merge_mean_std <- df_merge_mean_std[with(df_merge_mean_std, order(df_merge_mean_std$Subject,df_merge_mean_std$Activity)), ]

# create tidy data with the average of each variable for each activity and each subject 
df_merge_tidy <- aggregate(df_merge_mean_std[3:8], by=list(Subject=df_merge_mean_std$Subject,Activity=df_merge_mean_std$Activity), FUN=mean)

# order the tidy data by subject and activity
df_merge_tidy <- df_merge_tidy[with(df_merge_tidy, order(df_merge_tidy$Subject,df_merge_tidy$Activity)), ]

# print the tidy data
df_merge_tidy