# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Download the dataset if it does not already exist in the working directory
2. Load the activity and feature info
3. Get the features name and select those features only contain mean and std in the measurements
4. Loads both the training and test datasets, keeping only those mean and std features.
5. Merges two datasets: train and test,
6. Converts "activity" and "subject" columns into factors, and use the descriptive names
7. Creates a tidy dataset that consists of the average (mean) value of each
   variable for each subject and activity pair.

The end result is shown in the file "tidyMean.txt"
