## Peer-graded Assignment: Getting and Cleaning Data Course Project
##
## Human Activity Recognition Using Smartphones Data Set 

## Read the features names from features.txt and save them in features variable
features <- read.table("UCI HAR Dataset/features.txt",header=FALSE, col.names = c("ID","feature"))
features <- select(features,feature)
features <- unlist(features)

## Create activities list from activity_labels.txt
activities <- read.table("UCI HAR Dataset/activity_labels.txt",header=FALSE, col.names = c("ID","activity"))

## test
## Create de dim vector for read the fwf file. each data is 16 characters and there are 561 data for each row 
dim<- rep(16, 561)

## Read the values using read.fwf
## ncol=561
## nrow=2947
testx <- read.fwf("UCI HAR Dataset/test/X_test.txt",dim, header = FALSE,col.names = features)

## Read the subject for each observation from subject_test.txt
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt",header=FALSE, col.names = "subject")

## Add the subjects to the testx data.frame
testx <- mutate(testx, subject = unlist(test_subjects))

## Read the activity from y_test.txt for each observation
testy <- read.table("UCI HAR Dataset/test/y_test.txt",header=FALSE, col.names = "ID")

## join testy with activities list
testy <- left_join(testy,activities, by = "ID")

## Include activity name for each observation to testx dataframe
tidydataset <- mutate(testx, activity = unlist(select(testy,activity)))


##train

## Read the values using read.fwf
## ncol=561
## nrow=7352
trainx <- read.fwf("UCI HAR Dataset/train/X_train.txt",dim, header = FALSE,col.names = features)

## Read the subject for each observation from subject_train.txt
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt",header=FALSE, col.names = "subject")

## Add the subjects to the trainx data.frame
trainx <- mutate(trainx, subject = unlist(train_subjects))

## Read the activity from y_test.txt for each observation
trainy <- read.table("UCI HAR Dataset/train/y_train.txt",header=FALSE, col.names = "ID")

## join trainy with activities list
trainy <- left_join(trainy,activities, by = "ID")

## Include activity name for each observation to testx dataframe
trainx <- mutate(trainx, activity = unlist(select(trainy,activity)))

## Add both test and train
tidydataset <- rbind(tidydataset,trainx)

## Show inly mean and std columns
tidydataset <- select(tidydataset,matches('mean|std|activity|subject'))
#View(tidydataset)

## Create new dataset named tidydsmean group be activity and subject and summarising by mean
tidydsmean <- tidydataset %>% group_by(activity,subject) %>% summarise_all(funs(MeanValue=mean))

write.table(tidydsmean,file = "output.csv",row.name=FALSE)
