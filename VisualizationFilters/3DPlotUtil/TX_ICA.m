
clear all
close all
clc

addpath(genpath(pwd));

ICA_restult = cell(1,6);
tic
for i=1:6  % Loop for the 6 mission of subject 1

    dataset_name = char(['TX16EEGdata.filt.00', int2str(i),'.0',int2str(1),...
    '.',int2str(i),'.set']);

    % Read dataset and calculate ICA
    current_dataset = pop_loadset(dataset_name);
    current_dataset = pop_runica(current_dataset,'sphering','on');
    ICA_restult{i} = current_dataset.icaweights*(current_dataset.icasphere*current_dataset.data);
end
toc
clc
disp('Finished!!');