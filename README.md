# baselineEEGtest: *Provide baseline test for EEG with different features*

We design this code for baseline EEG test (RSVP especially)

We included preprocessing, feature extraction, epoching, baseline test and visualziation of CNN features. New baseline classifiers and features will be considering in the future...

===========================================================
## BaselineTest: *Test baseline performance with different features*

We used 3 features and 4 baseline algorithms to test EEG.

### Features

Raw data

Statistic features

XDAWN features

### Classifiers

SVM

LDA

BLDA

Bagging Tree


===========================================================
## ExtracEpoch: *Extract epochs strategies with and without overlapping*

We will use hedtag to extract epochs of epochs with event of interest

### Introduction




===========================================================
## SampleSizeSelection: *To selection a reasonable sample size for calibration*

We generate learning curves of a given dataset and base on the learning curve we find a reasonable sample size for calibration.

### Introduction




===========================================================
## VisualizationFilters: *To visualization filters extracted from trained CNN*

Some visualization methods to visualize weights, filters, features coming from trained CNN models. Currently only forward CNN visualization has been implemented, backward DeCNN will be implemented in the future...

### Introduction


