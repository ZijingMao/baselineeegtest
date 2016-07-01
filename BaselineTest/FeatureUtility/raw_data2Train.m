function [train_x, train_y, test_x, test_y] = raw_data2Train(fold, ...
                                        dataClassA, dataClassB)

step = 1;
testSub = (fold-1)*step+1:fold*step;
trainSub = 1:15;
trainSub(testSub) = [];

train_x = [];
train_y = [];
test_x = [];
test_y = [];
% get all train data
for idx = 1:length(trainSub)
    subID = trainSub(idx);
        
    currentSubfeatDataA = dataClassA{subID};
    [chan, time, epoch] = size(currentSubfeatDataA);
    currentSubDataA = reshape(currentSubfeatDataA, ...
        [chan*time, epoch])';
    
    
    currentSubfeatDataB = dataClassB{subID};
    [chan, time, epoch] = size(currentSubfeatDataB);
    currentSubDataB = reshape(currentSubfeatDataB, ...
        [chan*time, epoch])';
        
                
    train_x = cat(1, train_x, currentSubDataA);
    train_y = cat(1, train_y, ones([size(currentSubDataA, 1), 1]));   
    train_x = cat(1, train_x, currentSubDataB);
    train_y = cat(1, train_y, 2*ones([size(currentSubDataB, 1), 1]));         
                
end

kk = randperm(size(train_x, 1));
train_x = train_x(kk, :);
train_y = train_y(kk, :);

for idx = 1:length(testSub)
    subID = testSub(idx);
        
    currentSubfeatDataA = dataClassA{subID};
    [chan, time, epoch] = size(currentSubfeatDataA);
    currentSubDataA = reshape(currentSubfeatDataA, ...
        [chan*time, epoch])';
    
    
    currentSubfeatDataB = dataClassB{subID};
    [chan, time, epoch] = size(currentSubfeatDataB);
    currentSubDataB = reshape(currentSubfeatDataB, ...
        [chan*time, epoch])';  
                
    test_x = cat(1, test_x, currentSubDataA);
    test_y = cat(1, test_y, ones([size(currentSubDataA, 1), 1]));   
    test_x = cat(1, test_x, currentSubDataB);
    test_y = cat(1, test_y, 2*ones([size(currentSubDataB, 1), 1]));         
                
end

                                    
end

