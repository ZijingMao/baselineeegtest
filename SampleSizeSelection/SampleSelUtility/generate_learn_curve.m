function [auc, aucX] = generate_learn_curve(x, y, stepSize, logScale)

% given x and y, generate a learning curve to see the performance

[channel, time, ~] = size(x);

classifierName = {'SVM', 'LDA', 'BT', 'BLDA'};

testTargetSize = floor(sum(y==1)*0.1);
trainSampleSizeTarget = floor(sum(y==1)*0.8);

if logScale == true
    maxStep = floor(log2(trainSampleSizeTarget));
else
    maxStep = floor(trainSampleSizeTarget/stepSize);
end

auc     = zeros(maxStep, length(classifierName));
aucX    = zeros(maxStep, length(classifierName));

for step = 1:maxStep
    
    if logScale == true
        trainTargetSize = 2^step;
        maxTrainTargetSize = 2^maxStep;
    else
        trainTargetSize = stepSize*(step+1);
        maxTrainTargetSize = stepSize*(maxStep+1);
    end
    [train_x, train_y, test_x, test_y, valid_x, valid_y] = ...
        arrangeTrainTestValid(x, y, trainTargetSize, testTargetSize, maxTrainTargetSize);
    
    [ train_xx, enhancedResponse ] = ExtractXDAWNFilter( train_x, train_y );
    [ test_xx ] = Convert2XDAWN( test_x, enhancedResponse );
    
    train_x = reshape(train_x, [channel*time, size(train_x, 3)])';
	test_x = reshape(test_x, [channel*time, size(test_x, 3)])';
	% normalize
	[~, mu, sigma] = zscore(train_x);
	train_x = normalize(train_x, mu, sigma);
	test_x = normalize(test_x, mu, sigma);
    
    for classifierID = 1:length(classifierName)
        disp(['training with ' classifierName{classifierID}]);
        auc(step, classifierID) 	= 	trainClassifier...
            (train_x, train_y, test_x, test_y, classifierName{classifierID});
        aucX(step, classifierID) 	= 	trainClassifier...
            (train_xx, train_y, test_xx, test_y, classifierName{classifierID});
    end
    
    disp(['result R: ' num2str(round(auc(step, :)*100))]);
    disp(['result X: ' num2str(round(aucX(step, :)*100))]);
    disp(repmat('=', 1, 78));
    
end

end