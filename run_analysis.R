run_analysis <- function() {

	my_wd <- getwd()

	library(data.table)
	library(plyr)
	library(dplyr)

	setwd("UCI HAR Dataset")
	
## 1.Merges the training and the test sets to create one data set.

	my_read <- function() {
		my_features <- fread("features.txt")
		setwd("train")
			subject_train <<- fread("subject_train.txt")
				names(subject_train) <- "subject" #naming avoids confusion with multiple col having the name 'V1' when we will cbind
			x_train <<- fread("X_train.txt")
				names(x_train) <- my_features$V2
			y_train <<- fread("y_train.txt")
				names(y_train) <- "labels"

		setwd("../test")
			subject_test <<- fread("subject_test.txt")
				names(subject_test) <- "subject"
			x_test <<- fread("X_test.txt")
				names(x_test) <- my_features$V2
			y_test <<- fread("y_test.txt")
				names(y_test) <- "labels"
	}

	my_merge <- function() {
		my_read() # call 'my_read' function before merging
		my_train <- cbind(subject_train, x_train, y_train)
			# to keep the record of the origin of the data, let's add a column 'phase'
			my_train$phase <- "train"
		my_test <- cbind(subject_test, x_test, y_test)
			my_test$phase <- "test"
		# once we have the data sets for train and test, let's merge them with rbind
		my_data_set <<- rbind(my_train, my_test)
	}
my_merge()



## 2.Extracts only the measurements on the mean and standard deviation for each measurement.
	my_extract <- function() {
		m <- select(my_data_set, contains("mean()"))
		s <- select(my_data_set, contains("std()"))
		s_l <- select(my_data_set, c(subject, labels))
	
		my_data_set2 <<- cbind(s_l, m, s)
	}
my_extract()
 
## 3.Uses descriptive activity names to name the activities in the data set
	setwd("..") #go back to the parent working directory
		activity_labels <- fread("activity_labels.txt")

	#mapping the values in the data set with the values from activity_labels
		my_data_set2$labels <<- mapvalues(my_data_set2$labels, activity_labels$V1, activity_labels$V2)


## 4.Appropriately labels the data set with descriptive variable names. 
	my_naming <- function() {
		names(my_data_set2) <- sub("BodyBody", "Body", names(my_data_set2))
		names(my_data_set2) <- sub("labels", "activity", names(my_data_set2))
		names(my_data_set2) <- gsub("-", "", names(my_data_set2))
		names(my_data_set2) <- sub("std", "Std", names(my_data_set2))
		names(my_data_set2) <- sub("mean", "Mean", names(my_data_set2))
		names(my_data_set2) <- sub("()", "", names(my_data_set2), fixed=TRUE)
		names(my_data_set2) <<- gsub(" ", "", names(my_data_set2))
	}
my_naming()


## 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	my_summary <- function() {	
		my_vars <- c("subject", "activity")
		my_measure <- names(select(my_data_set2, -(subject:activity)))
		my_tidy_data <- melt(my_data_set2, id.vars=my_vars, measure.vars=my_measure)

		my_tidy_data <- group_by(my_tidy_data, subject, activity, variable)
		my_tidy_data <- summarize_each(my_tidy_data, funs(mean))
		my_tidy_data <<- arrange(my_tidy_data, subject)
		
	}
my_summary()


#to finish, let's set back the working directory we had at the begining
setwd(my_wd)

write.table(my_tidy_data, file="tidy_data.txt", row.name=FALSE)

}
