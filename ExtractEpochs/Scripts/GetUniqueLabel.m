% 1. find the unique label information
% 2. find the number of each unique label

%% configuration
clc
clear
cd 'I:/level2_256Hz_code/eeglab13_4_4b';
eeglab;
close all;

% addpath(genpath('/home/zijing.mao/ESS-master'));
cd('C:\Users\zijing\Dropbox\EEG Projects\Zijing\baselineeegtest');
addpath(genpath(pwd));

%% set experiments (change your folder here)
expStub = 'I:/level2_256Hz_epoch/';

expName{1} = 'Experiment X6 Speed Control';
expName{2} = 'Experiment X2 Traffic Complexity';
expName{3} = 'Experiment XB Baseline Driving';
expName{4} = 'Experiment XC Calibration Driving';
expName{5} = 'X3 Baseline Guard Duty';
expName{6} = 'X4 Advanced Guard Duty';
expName{7} = 'X2 RSVP Expertise';
expName{8} = 'X1 Baseline RSVP';

% construct the label information for exp 7 & 8 first, because the datasize
% is huge, these two dataset have to use separate .mat file to store data
% for expIdx = 7:8
%     cd([expStub expName{expIdx}]);
%     fileList = dir;
%     fileLength = length(fileList) - 3; % the 2 parent symbol & 1 subID.mat
%     tmpLabels = cell(fileLength, 1);
%     for fileIdx = 1:fileLength
%         Labels = [];
%         load([num2str(fileIdx) '.mat'], 'Labels');
%         tmpLabels{fileIdx} = Labels;
%     end
%     Labels = tmpLabels;
%     cd ..
%     save([expName{expIdx} '.mat'], 'Labels', '-v7.3');
% end

lenExp = length(expName);
infoSubNum = cell(1, lenExp);

%% save the extracted epoch information
% the idea is remember all the information from experiment and store them
% and then transfer each of the unique tag combs into labels and store the
% label back to each mat file
for expIdx = 1:lenExp
    Labels = [];
    load([expStub expName{expIdx}], 'Labels');

    lblLength = length(Labels);
    currentExpUniqueLabel = [];
    currentExpUniqueCount = [];
    currentExpMatrix= [];
    for subIdx = 1:lblLength
        currentSubLabel = Labels{subIdx};
        currentSubLabelMat = cell2mat(currentSubLabel')';
        
%         [currSubUniLbl, ~, currSubUniIdx] = ...
%             unique(currentSubLabelMat, 'rows');
%         hist(currSubUniIdx,unique(currSubUniIdx));

        currentExpMatrix = cat(1, currentExpMatrix, currentSubLabelMat);
    end
    infoSubNum{expIdx} = currentExpMatrix;
end

% concat every data inorder to have the data information
epochSize = zeros(lenExp, 1);
expMatrix = [];
for expIdx = 1:lenExp
    epochSize(expIdx) = length(infoSubNum{expIdx});
    expMatrix = cat(1, expMatrix, infoSubNum{expIdx});
end
[expUniLbl, ~, expUniIdx] = unique(expMatrix, 'rows');
[exp_y, exp_x] = hist(expUniIdx,unique(expUniIdx));
exp_y = exp_y';

save([expStub, 'ExtractedEpochInformation.mat'], 'expUniLbl', 'exp_x', 'exp_y');

%% reverse back to each experiment
load([expStub, 'ExtractedEpochInformation.mat']);
for expIdx = 1:lenExp
    Labels = [];
    load([expStub expName{expIdx}], 'Labels');
    
    lblLength = length(Labels);
    labels = cell(lblLength, 1);
    for subIdx = 1:lblLength
        currentSubLabel = Labels{subIdx};
        currentSubLabelLength = length(currentSubLabel);
        currentNewSubLabel = zeros(currentSubLabelLength, 1);
        for currentDataIdx = 1:currentSubLabelLength
            for labelIdx = 1:size(expUniLbl, 1)
                if strcmp(currentSubLabel{currentDataIdx}',...
                        expUniLbl(labelIdx, :))
                    currentNewSubLabel(currentDataIdx) = labelIdx;
                end
            end
        end
        if sum(currentNewSubLabel == 0) == 0
            labels{subIdx} = currentNewSubLabel;
        else
            error('some epoch does not find correct label information, please check your data');
        end
    end
    
    save([expStub expName{expIdx}], 'labels','-append')
end

