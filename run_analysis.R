library(dplyr)

xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
sTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/Y_test.txt")
sTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

xTotal <- rbind(xTrain, xTest)
yTotal <- rbind(yTrain, yTest)
sTotal <- rbind(sTrain, sTest)

colnames(xTotal) <- features$V2
colnames(yTotal) <- "Activity"
colnames(sTotal) <- "Subject"

xTotal <- xTotal[,grep("mean\\(\\)|std\\(\\)", colnames(xTotal))]

yTotal$activitylabel <- factor(yTotal$Activity, labels = as.character(activity_labels[,2]))
activitylabel <- yTotal[,-1]

total <- cbind(xTotal, activitylabel, sTotal)
total <- total %>% group_by(activitylabel, Subject) %>% summarize_each(funs(mean))
write.table(total, file = "UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)