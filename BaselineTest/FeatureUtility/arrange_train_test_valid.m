function [train_x, train_y, test_x, test_y, valid_x, valid_y] = ...
            arrange_train_test_valid(x, y, trainTargetSize, testTargetSize, maxTrainTargetSize)

    xSizeLen = length(size(x));

    if xSizeLen > 3
        x = squeeze(x);
        x = permute(x, [2, 1, 3]);
        y = y';
    end
        
    idxA = find(y(:, 1)==1);
    idxB = find(y(:, 1)==0);
    
    maxtrA  = randsample(idxA, maxTrainTargetSize, 'false');
    maxtrB  = randsample(idxB, maxTrainTargetSize, 'false');
    trainA  = randsample(maxtrA, trainTargetSize, 'false');
    trainB  = randsample(maxtrB, trainTargetSize, 'false');
    
    otherA  = setdiff(idxA, maxtrA);
    otherB  = setdiff(idxB, maxtrB);
    testA   = randsample(otherA, testTargetSize, 'false');
    testB   = randsample(otherB, testTargetSize, 'false');
    validA  = setdiff(otherA, testA);
    validB  = setdiff(otherB, testB);
    
    train_x = x(:, :, [trainA;trainB]);
    train_y = y([trainA;trainB], 1);
    tr_size = length(train_y);
    kk      = randperm(tr_size);
    train_x = train_x(:, :, kk);
    train_y = train_y(kk);
    
    test_x  = x(:, :, [testA;testB]);
    test_y  = y([testA;testB], 1);
    valid_x = x(:, :, [validA;validB]);
    valid_y = y([validA;validB], 1);
    
    disp(repmat('=', 1, 78));
    outputStr = sprintf(['train:\t' num2str(length(train_y)) ...
                        '\ntest:\t' num2str(length(test_y)) ...
                        '\nvalid:\t' num2str(length(valid_y))]);
    disp(outputStr);
    disp(repmat('=', 1, 78));
                    
end