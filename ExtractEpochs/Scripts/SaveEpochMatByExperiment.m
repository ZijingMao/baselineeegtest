expName = 'X4 Advanced Guard Duty';
filePath = ['/home/research/Zijing/' expName '/'];

% % Get all the file names
% filelist2cell = @(str) extractfield( (dir(str)), 'name' );
% eegDatasetList = filelist2cell(filePath)';
% eegDatasetList(1:2) = [];
% 
% % Keep only the .set files on the list (used for loading EEG data)
% selectSetFile = @(str) str(1:( strfind(str, '.set') + 3));
% eegDatasetList = cellfun(@(str) selectSetFile(str), eegDatasetList, 'UniformOutput', false);
% emptyEntries = logical(cell2mat(cellfun(@(str) isempty(str), eegDatasetList, 'UniformOutput', false)));
% setFilesList = eegDatasetList(~emptyEntries)';
% 
% assert(length(setFilesList) == 1, 'Not clear which .set file you want to choose...');

% load eeg data

fileName = dir(filePath);
fileName(1:2) = [];
subSize = length(fileName);
Inputs = cell(1, subSize);
Labels = cell(1, subSize);
SubIDs = cell(1, subSize);
parfor idx = 1:subSize
    [Inputs{idx}, Labels{idx}, SubIDs{idx}] = generate_epochs(idx, filePath, fileName(idx).name);
end

subIDs = zeros(length(SubIDs), 1);
for i = 1:length(SubIDs)
    subIDs(i) = str2double(SubIDs{i});
end
subIDs = subIDs - 3200;

%% separate data by subject

subIDs = unique(subIDs);
subSize = length(subIDs);
a = cell(1, subSize); 
b = cell(1, subSize);
for i = 1:subSize
    idx = find(subIDs==subIDs(i));
    for j = 1:length(idx)
        a{i} = cat(3, a{i}, Inputs{idx(j)});
        b{i} = cat(2, b{i}, Labels{idx(j)});
    end
end
Inputs = a;
Labels = b;

save([expName, '.mat'], 'Inputs', 'Labels', '-v7.3');
