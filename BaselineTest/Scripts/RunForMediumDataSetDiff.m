% load('MIX_XN_S01_RAW_CH64.mat');
%

load 'RSVP_DRIVE_S100_RAW_CH64.mat'
load 'RSVP_X2_S04_RAW_CH64.mat'

for idx = 1:10
   
%     test_y = test_y';
%     train_y = train_y';
    test_x = squeeze(test_x);
    train_x = squeeze(train_x);
    
    % [train_xx, train_y, test_xx, test_y] = getXDAWNFeature(train_x, train_y, test_x, test_y);
    
    train_x = reshape(train_x, [64*64, size(train_x, 3)])';
    test_x = reshape(test_x, [64*64, size(test_x, 3)])';
    
    % normalize (optimal)
    [~, mu, sigma] = zscore(train_x);
    train_x = normalize(train_x, mu, sigma);
    test_x = normalize(test_x, mu, sigma);
    
    % for multi label
    train_y = train_y - 4;
    test_y = test_y - 4;
    
    train_idx_sel_012 = find (train_y <= 2);
    test_idx_sel_012 = find (test_y <= 2);
    
    train_x[idx_sel_012]

    train_idx_sel_012 = find (train_y <= 2);
    test_idx_sel_012 = find (test_y <= 2);
    
    train_x[idx_sel_012]


    train_x = x{idx}(:, :, 1:steps);
    train_y = y{idx}(1:steps);
    test_x = x{idx}(:, :, steps+1:end);
    test_y = y{idx}(steps+1:end);
    
    % % run very fast
    % aucXLDA(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'LDA');
    % aucXBLDA(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'BLDA');
    % % run relative slow
    % aucXSVM(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'SVM');
    % aucXBag(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'Bag');
    % aucSVM(fold) 	= 	train_classifier(train_x, train_y, test_x, test_y, 'SVM');
    
    aucLDA(idx) 	= 	train_classifier(train_x, train_y, test_x, test_y, 'LDA');    
    aucBag(idx) 	= 	train_classifier(train_x, train_y, test_x, test_y, 'Bag');
    aucSVM(idx)	    = 	train_classifier(train_x, train_y, test_x, test_y, 'SVM');
    
end

save('100sub_result.mat', 'aucBag', 'aucBLDA', 'aucLDA');
