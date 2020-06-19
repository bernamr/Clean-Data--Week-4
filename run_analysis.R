#setting working directory.
setwd("~/Desktop/DS/3-GCD/W4/UCI HAR Dataset/DATA")

#Load librarys.
library(reshape2)
library(data.table)

#Loading train data#
x_train <- read.table(paste(sep="", "./X_train.txt"))
y_train <- read.table(paste(sep="", "./y_train.txt"))
s_train <- read.table(paste(sep="", "./subject_train.txt"))

#loading test data#
y_test <- read.table(paste(sep="", "./y_test.txt"))
x_test <- read.table(paste(sep="", "./x_test.txt"))
s_test <- read.table(paste(sep="", "./subject_test.txt"))

#loading features and label data#
features <- read.table(paste(sep="", "./features.txt"))
label<- read.table(paste(sep="", "./activity_labels.txt"))

#Merge data.
x_data <- rbind(x_test, x_train)
y_data <- rbind(y_test, y_train)
s_data <- rbind(s_test, s_train)

# Filter only "meand or std" 
features_col <- grep("(mean|std)", as.character(features[,2]))
f_colnames<- features[features_col, 2]%>%
  gsub("-mean", "Mean")%>%
  gsub("-std", "Std")%>%
  gsub("[()-]", "")

# X, allDadata and use descriptive names
x_data <- x_data[features_col]
allData<- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", f_colnames)
allData$Activity <- factor(allData$Activity, levels = label[,1], labels = label[,2])
allData$Subject <- as.factor(allData$Subject)

#Tidydata
meltedData <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)
write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)
View(tidyData)


