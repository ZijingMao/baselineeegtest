
addpath(genpath(pwd));

load('X2RSVP.mat');
x = Inputs;
y = Labels;

%% cross-validate test
% 5 fold, leave the last 2
maxFold = 10;
aucSVM = zeros(1, maxFold);
aucLDA = zeros(1, maxFold);
aucBag = zeros(1, maxFold);
aucBLDA = zeros(1, maxFold);

aucXSVM = zeros(1, maxFold);
aucXLDA = zeros(1, maxFold);
aucXBag = zeros(1, maxFold);
aucXBLDA = zeros(1, maxFold);

for fold = 1:maxFold

    tic;
	%% orginize data
	[train_x, train_y, test_x, test_y] = arrange_train_test(x, y, fold, maxFold);
	[train_xx, train_y, test_xx, test_y] = getXDAWNFeature(train_x, train_y, test_x, test_y);

	% run test
	% aucBLDA = XDBLDA_CrossSubject(train_x, train_y, test_x, test_y);

	train_x = reshape(train_x, [64*128, size(train_x, 3)])';
	test_x = reshape(test_x, [64*128, size(test_x, 3)])';
	% normalize
	[~, mu, sigma] = zscore(train_x);
	train_x = normalize(train_x, mu, sigma);
	test_x = normalize(test_x, mu, sigma);

	aucSVM(fold) 	= 	train_classifier(train_x, train_y, test_x, test_y, 'SVM');
	aucLDA(fold) 	= 	train_classifier(train_x, train_y, test_x, test_y, 'LDA');
	aucBag(fold) 	= 	train_classifier(train_x, train_y, test_x, test_y, 'Bag');
	aucBLDA(fold)	= 	train_classifier(train_x, train_y, test_x, test_y, 'BLDA');

	%% run the test for XDAWN features
	
	% run test
	aucXSVM(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'SVM');
	aucXLDA(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'LDA');
	aucXBag(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'Bag');
	aucXBLDA(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'BLDA');

    disp(['Subj:' num2str(fold)]);
    disp(['aucR:' num2str(aucSVM(fold)) num2str(aucLDA(fold)) num2str(aucBag(fold)) num2str(aucBLDA(fold))]);
    disp(['aucX:' num2str(aucXSVM(fold)) num2str(aucXLDA(fold)) num2str(aucXBag(fold)) num2str(aucXBLDA(fold))]);
    toc;
    
end

save(['validBaselineCT2WS' datestr(datetime('now')) '.mat'], 'aucSVM', 'aucLDA', 'aucBag',...
		'aucBLDA', 'aucXSVM', 'aucXLDA', 'aucXBag', 'aucXBLDA');
