
%% configuration
clc;
clear;

ConfigPath;

%% Extract Epoch With UserTags, set the experiment want to extract
exp_id = 3;
% expName(1).name = 'Experiment X6 Speed Control';
% expName(2).name = 'Experiment X2 Traffic Complexity';
% expName(3).name = 'Experiment XB Baseline Driving';
% expName(4).name = 'Experiment XC Calibration Driving';
% expName(5).name = 'X3 Baseline Guard Duty';
% expName(6).name = 'X4 Advanced Guard Duty';
% expName(7).name = 'X2 RSVP Expertise';
% expName(8).name = 'X1 Baseline RSVP';
% expName(9).name = 'Experiment X7 Auditory Cueing';
% expName(10).name = 'Experiment X8 Mind Wandering';
extract_epoch_user_tags( configs, exp_id );

%% load and save in mat

