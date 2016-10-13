% load('MIX_XN_S01_RAW_CH64.mat');
%I:\level2_256Hz_epoch\FatigueLevel\Experiment XB Baseline Driving\Results\RSVP_DRIVE_S100_RAW_CH64.mat

% load 'RSVP_DRIVE_S100_RAW_CH64.mat'
% load 'RSVP_X2_S04_RAW_CH64.mat'
load('I:\level2_256Hz_epoch\FatigueLevel\Experiment XB Baseline Driving\Results\RSVP_DRIVE_S100_RAW_CH64.mat');

for idx = 1:10
    
    if length(y{idx}) - 11000 > 1000
        steps = 11000;
    elseif length(y{idx}) - 10000 > 1000
        steps = 10000;
    elseif length(y{idx}) - 9000 > 1000
        steps = 9000;
    elseif length(y{idx}) - 8000 > 1000
        steps = 8000;
    elseif length(y{idx}) - 7000 > 1000
        steps = 7000;
    elseif length(y{idx}) - 6000 > 1000
        steps = 6000;
    elseif length(y{idx}) - 5000 > 1000
        steps = 5000;
    end
    
    train_x = x{idx}(:, :, 1:steps);
    train_y = y{idx}(1:steps);
    test_x = x{idx}(:, :, steps+1:end);
    test_y = y{idx}(steps+1:end);
    
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
