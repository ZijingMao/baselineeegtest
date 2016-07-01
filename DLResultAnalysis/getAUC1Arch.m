function [ testAUCAll, trainAUCAll, validAUCAll, testAUCMax, testAUCIdx ] = getAUC1Arch...
    ( setFilesList, filePath, iter_size )

testAUCAll = zeros(length(setFilesList), iter_size);
trainAUCAll = zeros(length(setFilesList), iter_size);
validAUCAll = zeros(length(setFilesList), iter_size);
testAUCMax = zeros(length(setFilesList), 1);
testAUCIdx = zeros(length(setFilesList), 1);
currMaxVal = 0;
currFileIdx = 0;
for fileIdx = 1:length(setFilesList)
    fileName = setFilesList{fileIdx};
    outputFeat = csvread([filePath fileName]);
    outputFeat = reshape(outputFeat, [3, iter_size])';

    % get the index of the max performance of validation
    [maxVal, maxIdx] = max(outputFeat(:, 2));
    if maxVal >= currMaxVal
        currMaxVal = maxVal;
        % currMaxIdx = maxIdx;
        currFileIdx = fileIdx;
    end
    testAUC = outputFeat(maxIdx, 3);
    
    testAUCMax(fileIdx) = testAUC;
    testAUCAll(fileIdx, :) = outputFeat(:, 3);
    testAUCIdx(fileIdx) = maxIdx;
    
end

testAUCAll = testAUCAll(currFileIdx, :);
testAUCMax = testAUCMax(currFileIdx);
testAUCIdx = currFileIdx;

end

