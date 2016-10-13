function [ accuracy, accuracyC ] = train_classifier( train_x, train_y, test_x, test_y, algorithm )

if strcmpi(algorithm, 'SVM')
    t = templateSVM('Standardize',1);
    SVMModel = fitcecoc(train_x,train_y,'Learners',t);
    [~,pred] = predict(SVMModel,test_x);
    
elseif strcmpi(algorithm, 'LDA')
    LDAModel = fitcdiscr(train_x,train_y,'DiscrimType','diagLinear');
    [~,pred] = predict(LDAModel,test_x);
elseif strcmpi(algorithm, 'BLDA')
    BLDA = bayeslda(1);
    BLDA.verbose = 0;
    train_y = (train_y-0.5)*2;
    BLDA = train_BLDA(BLDA, train_x', train_y');
    weights = BLDA;
    % score = classify_BLDA(weights, train_x' )';
    score_test = classify_BLDA(weights, test_x' )';
    test_y = (test_y-0.5)*2;
    pred = score_test;
    pred(:, 2) = pred(:, 1);
else
    ensemble = fitensemble(train_x,train_y,'bag',100,'Tree', 'Type', 'Classification');
    [~,pred] = predict(ensemble, test_x);
end

% [~,~,~,AUC] = perfcurve(test_y,pred(:, 2), 1);
if size(pred, 2) > 2
    [~, label] = max(pred, [], 2);
    accuracy = sum(test_y == label-1)/length(test_y);
    accuracyC = confusionmat(test_y+1, label);
else
    [~,~,~,accuracy] = perfcurve(test_y,pred(:, 2), 1);
end

end

