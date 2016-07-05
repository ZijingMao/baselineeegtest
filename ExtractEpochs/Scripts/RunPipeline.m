
%% configuration
clc;
clear;

ConfigPath;

%% ExtractEpochWithUserTags
ExtractMultipleEpochWithUserTags;


%% SaveEpochMatByExperiment
SaveMultipleEpochMatByExperiment;


%% transform labels and save labels
GetUniqueLabel;


%% select interest labels and experiments: select binary labels
SelectMultipleLabelsByMatFile;


%% concat subjects for each experiment
% revise your information here
newDatasetName = 'DRIVING64CHAN';
datasetName = 'DatasetDrivingPerturbation';
expStr = [expName(1), expName(2), expName(3), expName(4)];
samplingRate = 64;
channelSize = samplingRate;
timeRange = 'Negative';
singleFlag = true;

ConcatSubjectTogether;


