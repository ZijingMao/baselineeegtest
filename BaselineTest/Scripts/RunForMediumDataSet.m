% load('MIX_XN_S01_RAW_CH64.mat');
% 
fold = 1;

test_y = test_y';
train_y = train_y';
test_x = squeeze(test_x);
train_x = squeeze(train_x);

% [train_xx, train_y, test_xx, test_y] = getXDAWNFeature(train_x, train_y, test_x, test_y);

train_x = reshape(train_x, [64*64, size(train_x, 3)])';
test_x = reshape(test_x, [64*64, size(test_x, 3)])';

% normalize (optimal)
[~, mu, sigma] = zscore(train_x);
train_x = normalize(train_x, mu, sigma);
test_x = normalize(test_x, mu, sigma);

% aucXLDA(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'LDA');
% aucLDA(fold) 	= 	train_classifier(train_x, train_y, test_x, test_y, 'LDA');
% aucXBLDA(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'BLDA');
aucBLDA(fold)	= 	train_classifier(train_x, train_y, test_x, test_y, 'BLDA');

% aucXSVM(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'SVM');
% aucXBag(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'Bag');
% aucBag(fold) 	= 	train_classifier(train_x, train_y, test_x, test_y, 'Bag');
% aucSVM(fold) 	= 	train_classifier(train_x, train_y, test_x, test_y, 'SVM');