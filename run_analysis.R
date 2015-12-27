#open training data
dataTrainingX <- read.table("train/X_train.txt",header=FALSE)
dataTrainingY <- read.table("train/Y_train.txt",header=FALSE)
dataTrainingS <- read.table("train/subject_train.txt",header=FALSE)

#open testing data
dataTestingX <- read.table("test/X_test.txt",header=FALSE)
dataTestingY <- read.table("test/Y_test.txt",header=FALSE)
dataTestingS <- read.table("test/subject_test.txt",header=FALSE)

#combine testing/training data
dataX<-rbind(dataTrainingX,dataTestingX)
dataY<-rbind(dataTrainingY,dataTestingY)
dataS<-rbind(dataTrainingS,dataTestingS)

#open features
features=read.table("features.txt",header=FALSE)

#choose only mean/std features; reduce data to chosen featres
featuresIndices <- grep(".*mean.*|.*std.*", features[,2])
dataX <- dataX[,featuresIndices]

#combine X,Y,S
data <- cbind(dataX,dataY,dataS)


#label chosen features
chosenFeatures <- features[featuresIndices,2]
colnames(data) <- c(as.character(chosenFeatures),"activity","subject")

#open labels
activityLabels = read.table("activity_labels.txt",header=FALSE)

# replace activity number with descriptive name
data$activity <- factor(data$activity, levels = activityLabels[,1], labels = activityLabels[,2])

# create "tidy" data table with avg for each feature per activity and subject
tidy = aggregate(data, by = list(activity=data$activity, subject=data$subject),mean)

#output tidy data
write.table(tidy, "tidy.txt", sep="")

