function [ train_x, train_y, test_x, test_y ] = pair_data_4D2Train( fold, ...
                                    pairDataA4D, pairDataB4D, pairDataC4D)

step = 3;
testSub = (fold-1)*step+1:fold*step;
trainSub = 1:30;
trainSub(testSub) = [];

train_x = [];
train_y = [];
test_x = [];
test_y = [];
% get all train data
for idx = 1:length(trainSub)
    subID = trainSub(idx);
        
    currentSubPairDataA = pairDataA4D{subID};
    [epoch, freq, chan, time] = size(currentSubPairDataA);
    currentSubDataA = reshape(currentSubPairDataA, ...
        [epoch, freq*chan*time]);
    
    
    currentSubPairDataB = pairDataB4D{subID};
    [epoch, freq, chan, time] = size(currentSubPairDataB);
    currentSubDataB = reshape(currentSubPairDataB, ...
        [epoch, freq*chan*time]);
    
    currentSubPairDataC = pairDataC4D{subID};
    [epoch, freq, chan, time] = size(currentSubPairDataC);
    currentSubDataC = reshape(currentSubPairDataC, ...
        [epoch, freq*chan*time]);    
    
    [ currentSubDataA, currentSubDataB, currentSubDataC ] = getBalancedData...
                    ( currentSubDataA, currentSubDataB, currentSubDataC );
    
                
    train_x = cat(1, train_x, currentSubDataA);
    train_y = cat(1, train_y, ones([size(currentSubDataA, 1), 1]));   
    train_x = cat(1, train_x, currentSubDataB);
    train_y = cat(1, train_y, 2*ones([size(currentSubDataB, 1), 1])); 
    train_x = cat(1, train_x, currentSubDataC);
    train_y = cat(1, train_y, 3*ones([size(currentSubDataC, 1), 1]));            
                
end

kk = randperm(size(train_x, 1));
train_x = train_x(kk, :);
train_y = train_y(kk, :);

for idx = 1:length(testSub)
    subID = testSub(idx);
        
    currentSubPairDataA = pairDataA4D{subID};
    [epoch, freq, chan, time] = size(currentSubPairDataA);
    currentSubDataA = reshape(currentSubPairDataA, ...
        [epoch, freq*chan*time]);
    
    
    currentSubPairDataB = pairDataB4D{subID};
    [epoch, freq, chan, time] = size(currentSubPairDataB);
    currentSubDataB = reshape(currentSubPairDataB, ...
        [epoch, freq*chan*time]);
    
    currentSubPairDataC = pairDataC4D{subID};
    [epoch, freq, chan, time] = size(currentSubPairDataC);
    currentSubDataC = reshape(currentSubPairDataC, ...
        [epoch, freq*chan*time]);    
    
    [ currentSubDataA, currentSubDataB, currentSubDataC ] = getBalancedData...
                    ( currentSubDataA, currentSubDataB, currentSubDataC );
    
                
    test_x = cat(1, test_x, currentSubDataA);
    test_y = cat(1, test_y, ones([size(currentSubDataA, 1), 1]));   
    test_x = cat(1, test_x, currentSubDataB);
    test_y = cat(1, test_y, 2*ones([size(currentSubDataB, 1), 1])); 
    test_x = cat(1, test_x, currentSubDataC);
    test_y = cat(1, test_y, 3*ones([size(currentSubDataC, 1), 1]));            
                
end

end

