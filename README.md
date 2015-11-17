## Getting and Cleaning Data Course Project

The run_analysis.R script is designed to run within the UCI HAR Dataset folder. It expects the input files within the same (working) directory (features, activity_labels) and in subfolders called test and train. 
The script uses the dplyr package which must be installed prior to running the script. 
The script runs automatically upon calling source("run_analysis.R").

<ol><li>The script reads in all the required files:
        <ul><li>activity_labels.txt</li>
        <li>features.txt</li>
        <li>train/subject_train.txt</li>
        <li>test/subject_test.txt</li>
        <li>train/y_train.txt</li>
        <li>test/y_test.txt</li>
        <li>train/X_train.txt</li>
        <li>test/X_test.txt</li></ul></li>
<li>The test and train data is merged individually for the different elements (activities, subjects and the measurements)</li>
<li>Only the required columns (mean and std values) are filtered out using the labels found in the features list<br/>
   All measurements and the corresponding labels which are not needed are omitted from the working data set</li>
<li>The activity id values are replaced with appropriate string labels using the activity_labels input file</li>
<li>The subject ids and activity columns are added to the working dataset</li>
<li>The complete working dataset is labeled with descriptive variable names taken from the feature list.<br />
 The strings are edited to be more easily readable for humans and labels for subject and activity are added.</li>
<li>The working dataset is grouped by subject ids and activities and the average for each measurement is<br/>
   calculated per group. These computations rely on functionality provided via the dplyr package. The result is stored in a data frame called tidyoutput</li></ol>

The resulting dataset fulfills the requirements of tidy data:
<ul><li>Each variable is in its own column: Variables are the subject, the activity and the different mean/std values.</li>
<li>Each observation of the variables is in a different row: Every row holds the mean values for each measurement for each unique combination of each subject doing each activity</li>
<li>Each type of observational unit forms a table</li></ul>
