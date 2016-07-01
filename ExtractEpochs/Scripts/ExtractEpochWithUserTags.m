clear
cd '/home/research/EEGLAB/eeglab13_4_4b';
eeglab;
close all;
% addpath(genpath('/home/zijing.mao/ESS-master'));
cd('/home/research/Zijing/baselineeegtest');
addpath(genpath(pwd));

%% read data
% expName = 'X2 RSVP Expertise';
% 
% % load the container in to a MATLAB object
% obj = levelDerivedStudy('level2XmlFilePath', ...
%     ['/home/zijing.mao/' expName '/']);
% 
% % get all the recording files 
% filenames = obj.getFilename;
% 
% % Step through all the recordings and apply a function
% for i=1:length(filenames)
%     [path, name, ext] = fileparts(filenames{i});
%     EEG = pop_loadset([name ext], path);
%     EEG = extract_epoch_hedtag(EEG);
% end;

%% read data (for test)
% expName = 'X1 Baseline RSVP second runA';

parfor sessionName = 1:sessionSize
    disp(num2str(sessionName));
    tag_one_session( expName, sessionName );
end

