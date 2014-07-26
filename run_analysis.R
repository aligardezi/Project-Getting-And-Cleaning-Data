download.file(url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',destfile = './dataset.zip')
unzip(zipfile = './dataset.zip')

features <- read.table(file = './UCI HAR Dataset/features.txt')

labels <- read.table(file = './UCI HAR Dataset/activity_labels.txt')

df_x_train <- read.table('./UCI HAR Dataset/train/X_train.txt')
colnames(df_x_train) <- features[,2]
ids <- 1:nrow(df_x_train)
df_x_train <- cbind(id=ids,df_x_train)

df_y_train <- read.table('./UCI HAR Dataset/train/Y_train.txt')
colnames(df_y_train) <- c('Activity')
ids <- 1:nrow(df_y_train)
df_y_train <- cbind(id=ids,df_y_train)

df_subject_train <- read.table('./UCI HAR Dataset/train/subject_train.txt')
colnames(df_subject_train) <- c('Subject')
ids <- 1:nrow(df_y_train)
df_subject_train <- cbind(id=ids,df_subject_train)

df_merge_train <- merge(df_subject_train,df_y_train,by = "id")
df_merge_train <- merge(df_merge_train, df_x_train)

df_x_test <- read.table('./UCI HAR Dataset/test/X_test.txt')
colnames(df_x_test) <- features[,2]
ids <- 1:nrow(df_x_test)
df_x_test <- cbind(id=ids,df_x_test)

df_y_test <- read.table('./UCI HAR Dataset/test/Y_test.txt')
colnames(df_y_test) <- c('Activity')
ids <- 1:nrow(df_y_test)
df_y_test <- cbind(id=ids,df_y_test)

df_subject_test <- read.table('./UCI HAR Dataset/test/subject_test.txt')
colnames(df_subject_test) <- c('Subject')
ids <- 1:nrow(df_y_test)
df_subject_test <- cbind(id=ids,df_subject_test)

df_merge_test <- merge(df_subject_test,df_y_test,by = "id")
df_merge_test <- merge(df_merge_test, df_x_test)

df_merge <- rbind(df_merge_train,df_merge_test)

df_merge_mean_std <- df_merge[2:9]

colnames(df_merge_mean_std) <- c('Subject','Activity','BodyAccelerationAverageXAxis','BodyAccelerationAverageYAxis','BodyAccelerationAverageZAxis','BodyAccelerationStdDevXAxis','BodyAccelerationStdDevYAxis','BodyAccelerationStdDevZAxis')

df_merge_mean_std$Activity[df_merge_mean_std$Activity==1] <- "WALKING"
df_merge_mean_std$Activity[df_merge_mean_std$Activity==2] <- "WALKING UPSTAIRS"
df_merge_mean_std$Activity[df_merge_mean_std$Activity==3] <- "WALKING DOWNSTAIRS"
df_merge_mean_std$Activity[df_merge_mean_std$Activity==4] <- "SITTING"
df_merge_mean_std$Activity[df_merge_mean_std$Activity==5] <- "STANDING"
df_merge_mean_std$Activity[df_merge_mean_std$Activity==6] <- "LAYING"

df_merge_mean_std <- df_merge_mean_std[with(df_merge_mean_std, order(df_merge_mean_std$Subject,df_merge_mean_std$Activity)), ]

df_merge_tidy <- aggregate(df_merge_mean_std[3:8], by=list(Subject=df_merge_mean_std$Subject,Activity=df_merge_mean_std$Activity), FUN=mean)

df_merge_tidy <- df_merge_tidy[with(df_merge_tidy, order(df_merge_tidy$Subject,df_merge_tidy$Activity)), ]

df_merge_tidy