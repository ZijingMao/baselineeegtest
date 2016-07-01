function epochedData = ExtractEpochs(signal, epochIndices, epoch, sampleRate)
% Parameters
numEpochs = length(epochIndices);
epochSamples = floor((epoch/1000) * sampleRate);
epochLength = epochSamples(2) - epochSamples(1);
% Create epoch


 epochedData = zeros(size(signal, 1), epochLength, numEpochs);



for ind = 1:numEpochs
    epochedData(:,:, ind) = signal(:, epochIndices(ind)+epochSamples(1):epochIndices(ind)+epochSamples(2)-1);
    epochedData(:,:, ind) = epochedData(:, :, ind) - repmat(mean(epochedData(:, :, ind), 2), 1, size(epochedData, 2));
end
 