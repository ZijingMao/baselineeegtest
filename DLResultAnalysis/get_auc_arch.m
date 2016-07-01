function [ testAUCAll, trainAUCAll, validAUCAll, testAUCMax, testAUCIdx, ...
    currMaxIdx, setFilesList ] = get_auc_arch...
    ( setFilesList, filePath )


testAUCAll = zeros(length(setFilesList), 1000);
trainAUCAll = zeros(length(setFilesList), 1000);
validAUCAll = zeros(length(setFilesList), 1000);
testAUCMax = zeros(length(setFilesList), 1);
testAUCIdx = zeros(length(setFilesList), 1);

emptyIdxSet = zeros(length(setFilesList), 1);
currMaxIdx = 1;
currMaxVal = 0;

for fileIdx = 1:length(setFilesList)
    
    fileName = setFilesList{fileIdx};
    
    d = dir([filePath fileName]);
    if d.bytes == 0
        outputFeatLen = 0;
    else        
        outputFeat = csvread([filePath fileName]);
        outputFeatLen = length(outputFeat);
    end    
    
    if outputFeatLen < 3
        % if the output feature is empty, then remove the file
        emptyIdxSet(fileIdx) = 1;
    else
        resFeatSize = mod(outputFeatLen, 3);
        outputFeat(end-resFeatSize+1:end) = [];
        
        iter_size = floor(outputFeatLen/3);
        outputFeat = reshape(outputFeat, [3, iter_size])';
        
        % get the index of the max performance of validation
        [maxVal, maxIdx] = max(outputFeat(:, 2));
        testAUC = outputFeat(maxIdx, 3);
        
        testAUCMax(fileIdx) = testAUC;
        testAUCAll(fileIdx, 1:iter_size) = outputFeat(:, 3);
        trainAUCAll(fileIdx, 1:iter_size) = outputFeat(:, 1);
        validAUCAll(fileIdx, 1:iter_size) = outputFeat(:, 2);
        
        testAUCIdx(fileIdx) = maxIdx;
        
        if currMaxVal < maxVal
            currMaxVal = maxVal;
            currMaxIdx = maxIdx;
        end
    end
    
end

setFilesList(emptyIdxSet==1) = [];
testAUCAll(emptyIdxSet==1, :) = [];
trainAUCAll(emptyIdxSet==1, :) = [];
validAUCAll(emptyIdxSet==1, :) = [];
testAUCMax(emptyIdxSet==1) = [];
testAUCIdx(emptyIdxSet==1) = [];

end

