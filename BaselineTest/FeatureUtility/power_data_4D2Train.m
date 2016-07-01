function [ train_x, train_y, test_x, test_y ] = power_data_4D2Train( fold, ...
                                    powerDataA4D, powerDataB4D, powerDataC4D)

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
        
    currentSubpowerDataA = powerDataA4D{subID};
    [epoch, freq, chan, time] = size(currentSubpowerDataA);
    currentSubDataA = reshape(currentSubpowerDataA, ...
        [epoch, freq*chan*time]);
    
    
    currentSubpowerDataB = powerDataB4D{subID};
    [epoch, freq, chan, time] = size(currentSubpowerDataB);
    currentSubDataB = reshape(currentSubpowerDataB, ...
        [epoch, freq*chan*time]);
    
    currentSubpowerDataC = powerDataC4D{subID};
    [epoch, freq, chan, time] = size(currentSubpowerDataC);
    currentSubDataC = reshape(currentSubpowerDataC, ...
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
        
    currentSubpowerDataA = powerDataA4D{subID};
    [epoch, freq, chan, time] = size(currentSubpowerDataA);
    currentSubDataA = reshape(currentSubpowerDataA, ...
        [epoch, freq*chan*time]);
    
    
    currentSubpowerDataB = powerDataB4D{subID};
    [epoch, freq, chan, time] = size(currentSubpowerDataB);
    currentSubDataB = reshape(currentSubpowerDataB, ...
        [epoch, freq*chan*time]);
    
    currentSubpowerDataC = powerDataC4D{subID};
    [epoch, freq, chan, time] = size(currentSubpowerDataC);
    currentSubDataC = reshape(currentSubpowerDataC, ...
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

