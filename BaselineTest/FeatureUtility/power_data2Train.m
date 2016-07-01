function [ train_x, train_y, test_x, test_y ] = power_data2Train( fold, ...
                                    pairDataA, pairDataB, pairDataC, ...
                                    powerDataA, powerDataB, powerDataC )

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
        
    currentSubPairDataA = pairDataA{subID};
    currentSubPowerDataA = powerDataA{subID};
    currentSubDataA = cat(2, currentSubPairDataA, currentSubPowerDataA);
    currentSubDataA = reshape(currentSubDataA, ...
        [size(currentSubDataA, 1), ...
        size(currentSubDataA, 2)*size(currentSubDataA, 3)]);
    
    
    currentSubPairDataB = pairDataB{subID};
    currentSubPowerDataB = powerDataB{subID};
    currentSubDataB = cat(2, currentSubPairDataB, currentSubPowerDataB);
    currentSubDataB = reshape(currentSubDataB, ...
        [size(currentSubDataB, 1), ...
        size(currentSubDataB, 2)*size(currentSubDataB, 3)]);
    
    
        currentSubPairDataC = pairDataC{subID};
    currentSubPowerDataC = powerDataC{subID};
    currentSubDataC = cat(2, currentSubPairDataC, currentSubPowerDataC);
    currentSubDataC = reshape(currentSubDataC, ...
        [size(currentSubDataC, 1), ...
        size(currentSubDataC, 2)*size(currentSubDataC, 3)]);
    
    
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
        
    currentSubPairDataA = pairDataA{subID};
    currentSubPowerDataA = powerDataA{subID};
    currentSubDataA = cat(2, currentSubPairDataA, currentSubPowerDataA);
    currentSubDataA = reshape(currentSubDataA, ...
        [size(currentSubDataA, 1), ...
        size(currentSubDataA, 2)*size(currentSubDataA, 3)]);
    
    
    currentSubPairDataB = pairDataB{subID};
    currentSubPowerDataB = powerDataB{subID};
    currentSubDataB = cat(2, currentSubPairDataB, currentSubPowerDataB);
    currentSubDataB = reshape(currentSubDataB, ...
        [size(currentSubDataB, 1), ...
        size(currentSubDataB, 2)*size(currentSubDataB, 3)]);
    
    
        currentSubPairDataC = pairDataC{subID};
    currentSubPowerDataC = powerDataC{subID};
    currentSubDataC = cat(2, currentSubPairDataC, currentSubPowerDataC);
    currentSubDataC = reshape(currentSubDataC, ...
        [size(currentSubDataC, 1), ...
        size(currentSubDataC, 2)*size(currentSubDataC, 3)]);
    
    
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

