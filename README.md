# TidyData

The script begins by saving the current working directory and loads the packages that will be used (data.table, plyr and dplyr)

The first step (creating the data set) is performed throught 2 functions:
    my_read(): uses the fread function of data.table to read into the 6 files containing the data. Due to lexicla scoping we have to use the '<<-' to be able to use the variable in the following parts of the script
    
  my_merge(): uses the variables definied in my_read() to cbind the subject, X and y data. We end with with 2 data sets, one for the training, the other for the testing
  We then rbind those two data sets to create the complete data_set

NB: the my_merge() function has to be called after its definition (if I understand it well, it is because R is not compiled but interpreted. The my_read() function is called in the my_merge() function.

The second step (extract mean and standard deviation) is performed by the function my_extract():
  Using the plyr function 'select', we creat 3 data frames, contaings respectively:
      1. all the columns containing 'mean()'
      2. all the columns containing 'std()'
      3. the columns with the subject and the lables (activity)
    These 3 data frames are bind together using cbind

The third step uses the mapping table provided in activity_labels.txt: using 'mapvalues', we replace the integer value in the activity column by the corresponding description.

The fourth step cleans up the lables of columns: remove repeated words ('BodyBody'), remove parenthesis, remove minus sign and remove all blanks (I don't think there were blanks, but just in case of...)

The fifth step is performed by the function my_summary(): it first melts the data set to have the data in a long format.
It thens group_by the data set by subject, activity and variable (the variable are the the names of the previous columns).
We then use the summarize function to get the mean for each variable, for each activity, for each subject.
Just to have a nice data set, we then arrange the data set by the subject column.

Finaly, we go back to the initial working directory and create a .txt file with write.table().
