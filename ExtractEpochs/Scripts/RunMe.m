%% configuration
clc;
clear
cd 'I:/level2_256Hz_code/eeglab13_4_4b';
eeglab;
close all;

% addpath(genpath('/home/zijing.mao/ESS-master'));
cd('C:\Users\zijing\Dropbox\EEG Projects\Zijing\baselineeegtest');
addpath(genpath(pwd));

%% set experiments (change your folder here)
DefineMultipleExperimentName;


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


