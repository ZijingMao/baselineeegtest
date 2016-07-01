function [ dataClass ] = reshape_4D( dataClass, timeLen )

[epochNum, chanNum, timeNum] = size(dataClass);

dataClass = reshape(dataClass, [epochNum, chanNum, timeNum/timeLen, timeLen]);

dataClass = permute(dataClass, [1, 4, 2, 3]);


end

