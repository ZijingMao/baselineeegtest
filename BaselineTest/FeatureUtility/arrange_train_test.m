function [ train_x, train_y, test_x, test_y ] = arrange_train_test( x, y, fold, maxFold )

% data should be:
% channel * time * epoch
% label should be:
% epoch * 1

% check dimension
xSizeLen = length(size(x{1}));

if xSizeLen > 3
    for i  = 1:10
        x{i} = squeeze(x{i});
        x{i} = permute(x{i}, [2, 1, 3]);
        y{i} = y{i}';
    end
end

% get fold information
currentIdx = 1:length(x);
foldSize = floor(length(x)/maxFold);
currentTestIdx = (fold-1)*foldSize+1:fold*foldSize;
currentTrainIdx = setdiff(currentIdx, currentTestIdx);

% get the train and test dataset
test_x = [];test_y = [];train_x = [];train_y = [];
for idx = 1:length(currentTestIdx)
    test_x = cat(3, test_x, x{currentTestIdx(idx)});
    test_y = cat(1, test_y, y{currentTestIdx(idx)});
end
for idx = 1:length(currentTrainIdx)
    train_x = cat(3, train_x, x{currentTrainIdx(idx)});
    train_y = cat(1, train_y, y{currentTrainIdx(idx)});
end


end

