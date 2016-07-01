function [ accSVM, accLDA, accBag ] = data2perf( featDataA, featDataB, fold )

[train_x, train_y, test_x, test_y] = rawData2Train(fold, ...
                                    featDataA, featDataB);

accSVM = trainClassifier(train_x, train_y, test_x, test_y, 'SVM');
accLDA = trainClassifier(train_x, train_y, test_x, test_y, 'LDA');
accBag = trainClassifier(train_x, train_y, test_x, test_y, 'Bag');

%% use paper 2's feature: featData

% [train_x, train_y, test_x, test_y] = featData2Train(fold, ...
%                                     featDataA, featDataB);
% 
% accSVM = trainClassifier(train_x, train_y, test_x, test_y, 'SVM');
% accLDA = trainClassifier(train_x, train_y, test_x, test_y, 'LDA');
% accBag = trainClassifier(train_x, train_y, test_x, test_y, 'Bag');

end

