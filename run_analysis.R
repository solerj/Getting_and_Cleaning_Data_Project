#Uncomment to download the Samsung data zipped file:
#fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileURL,destfile = "./downloadFile.zip")

#Uncomment to unzip the downloaded file:
#unzip("./downloadFile.zip")

#Reading the train and test data sets in R, and joining them into one data.frame
train <- read.table("./UCI HAR Dataset/train/X_train.txt")
test <- read.table("./UCI HAR Dataset/test/X_test.txt")
merged <- rbind(train,test)

#Reading the features data set, which contains descriptive names for the columns in the train and test data sets
features <- read.table("./UCI HAR Dataset/features.txt")

#Visualising the selected features list to confirm it is correct
grep("mean\\(|std",features[,2],value = TRUE)

#Extracting the selected list of features 
merged2 <- merged[,grep("mean\\(|std",features[,2])]

#Add in Activity Label and Subject
Activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
train_label <- read.table("./UCI HAR Dataset/train/Y_train.txt")
test_label <- read.table("./UCI HAR Dataset/test/Y_test.txt")
merged_l <- rbind(train_label,test_label)

train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
merged_s <- rbind(train_subject,test_subject)

all_data <- cbind(merged2, merged_s,merged_l)

#Renaming the columns
colnames(all_data) <- c(grep("mean\\(|std",features[,2],value = TRUE),"Subject","V1")
all_data_2 <- merge(all_data, Activity, by="V1")
names(all_data_2)[ncol(all_data_2)] <- "Activity"
all_data_2 <- all_data_2[,2:ncol(all_data_2)]

str(all_data_2)

#Creating a dataset with the average of each variable for each activity and each subject
all_data_2$Subject <- factor(all_data_2$Subject)
data_agg <- aggregate(x=all_data_2[,1:(ncol(all_data_2)-2)],by=list(all_data_2$Subject, all_data_2$Activity), FUN=mean)

#Saving the final data tidy set as a text file in the working directory
write.table(x=data_agg, file = "./Data_final.txt", row.names = FALSE)