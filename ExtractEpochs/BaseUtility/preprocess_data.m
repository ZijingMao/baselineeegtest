function [ data ] = preprocess_data...
    ( data, samplingRate, channelSize, timeRange )

[~, originalTimeSize, ~] = size(data);

if strcmpi(timeRange, 'positive')
    
    data = data(:, round(originalTimeSize/2)+1:end, :);
    
elseif strcmpi(timeRange, 'negative')
    
    data = data(:, 1:round(originalTimeSize/2), :);
    
end

[originalChanSize, originalTimeSize, ~] = size(data);

if originalChanSize > channelSize
   % resize the data
   varName = ['selectedIdx_' num2str(originalChanSize) '_' num2str(channelSize)];
   load('chanlocs.mat', varName);
   selectedIdx = eval(varName);
   
   data = data(selectedIdx, :, :);
end

if originalTimeSize > samplingRate
    
    data = data(:, 1:ceil(originalTimeSize/samplingRate):end, :);
    
end


