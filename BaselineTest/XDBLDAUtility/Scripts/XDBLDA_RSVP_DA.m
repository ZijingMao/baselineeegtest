function [AUC] = XDBLDA_RSVP_all(x, y)

rng(20);

steps = 225; % don't exceed 250
opt = 'DA';

for subjectID = 1:15
    
    xx = x{subjectID};
    yy= y{subjectID};
    xx = xx(:, 1:16:512,:);
    signal = reshape(xx, [64, 32* size(yy, 1)]);
    classA = xx(:, :, yy(:, 1)==1);
    classB = xx(:, :, yy(:, 1)==0);
    idxA = find(yy(:, 1)==1);
    idxB = find(yy(:, 1)==0);
    trainA = randsample(idxA, steps, 'false');
    trainB = randsample(idxB, steps, 'false');
    testA = setdiff(idxA, trainA);
    testB = setdiff(idxB, trainB);

    if strcmpi(opt, 'WS')
        train_x = xx(:, :, [trainA;trainB]);
        train_y = yy([trainA;trainB], 1);
        train_size = length(train_y);
        kk = randperm(train_size);
        train_x = train_x(:, :, kk);
        train_y = train_y(kk);
    elseif strcmpi(opt, 'DA')
        train_x = xx(:, :, [trainA;trainB]);
        train_y = yy([trainA;trainB], 1);
        train_size = length(train_y);
        kk = randperm(train_size);
        train_x = train_x(:, :, kk);
        train_y = train_y(kk);
        
        for otherID = 1:15
            if otherID ~= subjectID
                xx_other = x{otherID};
                yy= y{otherID};
                xx_other = xx_other(:, 1:16:512,:);
                train_x = cat(3, train_x, xx_other);
                train_y = cat(1, train_y, yy(:, 1));
            end
        end
        
        train_size = length(train_y);
        kk = randperm(train_size);
        train_x = train_x(:, :, kk);
        train_y = train_y(kk);
        
    elseif strcmpi(opt, 'CS')
        train_x = [];
        train_y = [];
        
        for otherID = 1:15
            if otherID ~= subjectID
                xx_other = x{otherID};
                yy = y{otherID};
                xx_other = xx_other(:, 1:16:512,:);
                train_x = cat(3, train_x, xx_other);
                train_y = cat(1, train_y, yy(:, 1));
            end
        end
        
        train_size = length(train_y);
        kk = randperm(train_size);
        train_x = train_x(:, :, kk);
        train_y = train_y(kk);
    end
    s = reshape(train_x, [64, 32*size(train_x, 3)]);
    s = double(s');
    idx.blockLength = 32;
    idx.indexStimulus = 1:32:size(train_x, 3)*32;
    
    nontarget = find(train_y == 0);
    idx.indexStimulus(nontarget) = [];

    [enhancedResponse, DTarget, D] = mxdawn(s,idx, 0);

    data = s*enhancedResponse.spatialFilter;
    data = data';
    train = reshape(data, [64, 32, train_size]);

    if subjectID == 2
        steps_test = 35;
    else 
        steps_test = 50;
    end
    test_x = xx(:, :, [testA(1:steps_test);testB(1:steps_test)]);
    test_y = yy([testA(1:steps_test);testB(1:steps_test)],1);
    test_tmp = reshape(test_x, [64, 32*size(test_x, 3)]);
    data_test = test_tmp'*enhancedResponse.spatialFilter;
    data_test = data_test';
    test = reshape(data_test, [64, 32, size(data_test, 2)/32]);

    % train_xx = reshape(train_x, [64*32, size(train_x,3)]);

    train_xx = [];

    for i = 1:8
        train_xx = [train_xx; squeeze(double(train(i, :, :)))];    
    end


    train_yy = (train_y-0.5)*2;
    
%     LDAModel = fitcdiscr(train_xx', train_yy);
    BLDA = bayeslda(1);
    BLDA.verbose = 0;
    BLDA = train_BLDA(BLDA, train_xx, train_yy');

    weights = BLDA;
    score = classify_BLDA(weights, train_xx )';


%     test_xx = reshape(test_x, [64*32, size(test_x,3)]);

    test_xx = [];
    for i = 1:8
        test_xx = [test_xx; squeeze(double(test(i, :, :)))];
    end

    score_test = classify_BLDA(weights, test_xx )';

%     [~, score_test] = predict(LDAModel, test_xx');
    test_yy = (test_y-0.5)*2;
    [~, ~, ~, auc(subjectID)] = perfcurve(test_yy, score_test(:, 1),1);

end

mean(auc)
