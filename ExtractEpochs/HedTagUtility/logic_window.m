function [ badChanIdx ] = logic_window( cWin, dWin, chanIdx )

% bad channel window remove strategy set here

cLogicMatrix = cWin.windowValues > cWin.threshold;
dLogicMatrix = dWin.windowValues > dWin.threshold;

logicMatrixAllChannel = cLogicMatrix | dLogicMatrix;
logicMatrixEEG = logicMatrixAllChannel(chanIdx, :);

logicVector = sum(logicMatrixEEG)/length(chanIdx);

% remove the largest 5% of bad epochs
[sortVec,idx] = sort(logicVector);
badChanIdx = idx(end-ceil(length(sortVec)*0.05):end);

end

