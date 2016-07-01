function [ testAUCAll, testAUCMax, testAUCIdx ] = getAUC1Model...
    ( setFilesList, filePath, iter_size )

testAUCAll = zeros(length(setFilesList), iter_size);
testAUCMax = zeros(length(setFilesList), 1);
testAUCIdx = zeros(length(setFilesList), 1);
for fileIdx = 1:length(setFilesList)
    fileName = setFilesList{fileIdx};
    outputFeat = csvread([filePath fileName]);
    outputFeat = reshape(outputFeat, [3, iter_size])';

    % get the index of the max performance of validation
    [~, maxIdx] = max(outputFeat(:, 2));
    testAUC = outputFeat(maxIdx, 3);
    
    testAUCMax(fileIdx) = testAUC;
    testAUCAll(fileIdx, :) = outputFeat(:, 3);
    testAUCIdx(fileIdx) = maxIdx;
    
end

end

