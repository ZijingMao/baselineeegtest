function [dataOut] = removeBaseline(data, baselineTime, sampleRate)

% removes the baseline mean from epoched data. EEG should have a field
% ".data" that is nChan x time x epoch. baselineTime should be the amount
% of time to use for the baseline. The first "baselineTime" part of the
% data field will be used to calculate the baselineMean.



% calculate the number of points in the baseline period
numPoints=floor(sampleRate*baselineTime);

% calculate the mean of each channel for each epoch
mnPoints = mean(data(:, 1:numPoints, :), 2);


% copy that mean for the entire temporal lenght of the data variable
mnPoints2 = repmat(mnPoints, 1, size(data, 2) - numPoints);

% remove the baseline
dataOut = data(:, numPoints+1:end, :) - mnPoints2;

