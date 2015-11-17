#load the dplyr library needed to work with the data
#if the package is not installed, please uncomment the
#install directive or install manually

#install.packages("dplyr")
library(dplyr)

#Step 1: 
#first we're parsing in all the info files

activity_labels <- read.table("activity_labels.txt", header = FALSE, sep = " ")
feature_labels <- read.table("features.txt", header = FALSE, sep = " ")

#parse in the subject and activity ids for measurements
#in both train and test datasets

subject_ids_train <- read.table("train/subject_train.txt", header = FALSE)
subject_ids_test <- read.table("test/subject_test.txt", header = FALSE)

activity_ids_train <- read.table("train/y_train.txt",header = FALSE)
activity_ids_test <- read.table("test/y_test.txt",header = FALSE)

#finally parse the files containing test/train measurements

data <- read.csv("train/X_train.txt", header=FALSE, sep="", dec=",", stringsAsFactors = FALSE)
data_test <- read.csv("test/X_test.txt", header=FALSE,sep="", dec=",", stringsAsFactors = FALSE)

#combine both datasets and removing outdated objects
subject_ids <- rbind(subject_ids_train,subject_ids_test, deparse.level = 0)
activity_ids <- rbind(activity_ids_train,activity_ids_test,deparse.level = 0)
rm(subject_ids_test)
rm(subject_ids_train)
rm(activity_ids_test)
rm(activity_ids_train)

data <- rbind(data,data_test)
rm(data_test)

#turn the measurements into numeric values (needed to compute average)
data <- as.data.frame(lapply(data, as.numeric))


#step 2: extract only mean & std measurements
#find the appropriate indices via the words mean & std contained in the feature_labels
means <- grep("mean()",feature_labels$V2, fixed = TRUE)
stds <- grep("std()",feature_labels$V2, fixed = TRUE)
indices <- sort(append(means,stds))
data <- data[,indices]
labels <- as.vector(feature_labels$V2)
labels <- labels[indices]

rm(means)
rm(stds)
rm(indices)

#step 3: replace activity ids with names
activity_ids$V1 <- sapply(activity_ids$V1,function(x){activity_labels[x,2]})

#add subjects and activities to data
data <- cbind(subject_ids,activity_ids,data)

#step 4: label data set with descriptive variable names
#add labels for subject and activity variables
labels <- append(c("subject_id","activity"),labels)
#make the labels easier to read
labels <- gsub("BodyBody","Body",labels, fixed = TRUE)
labels <- gsub("()","",labels, fixed = TRUE)
labels <- gsub("tBody","body",labels, fixed = TRUE)
labels <- gsub("tGravity","gravity",labels, fixed = TRUE)
labels <- gsub("fBody","fFourierT_",labels, fixed = TRUE)
labels <- gsub("bodyGyro","gyro",labels, fixed = TRUE)
labels <- gsub("Mag","Magnt",labels, fixed = TRUE)
#assign labels to data
colnames(data) <- labels

#step 5: create new tidy dataset with average of each variable 
#per subject/activity pair

tidyoutput <- group_by(data,subject_id,activity)
tidyoutput <- summarise_each(tidyoutput,funs(mean))

