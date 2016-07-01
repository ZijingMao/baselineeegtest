function [ data, labels ] = extract_epoch_label...
    ( expPath, fileName, fileLabels, interestLabels, balanced )

% load the experiment string that stores labels

EEG = pop_loadset('filename',fileName,'filepath',expPath);

% initial variables
EEG.data = double(EEG.data);
if length(size(EEG.data)) ~= 3
    disp('Make sure you have epoched eeg data');
    data = [];
    labels = [];
    return;
end

epochLength = length(fileLabels);
labelLength = length(interestLabels);

epochLogicIdx = zeros(epochLength, 1);

labelInfo = cell(labelLength, 1);
labelInfoLen = zeros(labelLength, 1);
for idx = 1:labelLength
    % check the size , will be used if using balanced data
    labelInfo{idx} = find(fileLabels == interestLabels(idx));
    labelInfoLen(idx) = length(labelInfo{idx});
    epochLogicIdx(fileLabels == interestLabels(idx)) = interestLabels(idx);
end

if balanced
    [balancedLabelLength, balancedLabelIdx] = min(labelInfoLen);
    
    for idx = 1:labelLength
        if idx~=balancedLabelIdx
            currentlabelInfo = labelInfo{idx};
            currentNotPermIdx = randperm(labelInfoLen(idx));
            % mask those that part larger than the minimun epoch length
            currentNotPermIdx = currentNotPermIdx(balancedLabelLength+1:end);
            currentlabelMaskInfo = currentlabelInfo(currentNotPermIdx);
            epochLogicIdx(currentlabelMaskInfo) = 0;
        end
    end
end

logicIdx = epochLogicIdx ~= 0;
labels = epochLogicIdx(logicIdx);
data = EEG.data(:, :, logicIdx);

end

