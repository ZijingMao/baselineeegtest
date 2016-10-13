clear all;
clc;
load('I:\level2_256Hz_epoch\FatigueLevel\Experiment XB Baseline Driving\Results\RSVP_DRIVE_S100_RAW_CH64_only_alert_drowsy.mat');
addpath(genpath('C:\Users\zijing\Dropbox\EEGRoomPC\Zijing Mao\baselineeegtest'))

x_all=cat(3,train_x,test_x);
y_all=[train_y;test_y];

x_test{1}=x_all(:,:,1:2000);
y_test{1}=y_all(1:2000,:);
x_train{1}=x_all(:,:,2001:end);
y_train{1}=y_all(2001:end,:);

x_test{2}=x_all(:,:,2001:4000);
y_test{2}=y_all(2001:4000,:);
x_train{2}=cat(3,x_all(:,:,1:2000),x_all(:,:,4001:end));
y_train{2}=[y_all(1:2000,:);y_all(4001:end,:)];

x_test{3}=x_all(:,:,4001:6000);
y_test{3}=y_all(4001:6000,:);
x_train{3}=cat(3,x_all(:,:,1:4000),x_all(:,:,6001:end));
y_train{3}=[y_all(1:4000,:);y_all(6001:end,:)];

x_test{4}=x_all(:,:,6001:8000);
y_test{4}=y_all(6001:8000,:);
x_train{4}=cat(3,x_all(:,:,1:6000),x_all(:,:,8001:end));
y_train{4}=[y_all(1:6000,:);y_all(8001:end,:)];

for idx = 1:4
   idx 
%     if length(y{idx}) - 11000 > 1000
%         steps = 11000;
%     elseif length(y{idx}) - 10000 > 1000
%         steps = 10000;
%     elseif length(y{idx}) - 9000 > 1000
%         steps = 9000;
%     elseif length(y{idx}) - 8000 > 1000
%         steps = 8000;
%     elseif length(y{idx}) - 7000 > 1000
%         steps = 7000;
%     elseif length(y{idx}) - 6000 > 1000
%         steps = 6000;
%     elseif length(y{idx}) - 5000 > 1000
%         steps = 5000;
%     end
%     
%     train_x = x{idx}(:, :, 1:steps);
%     train_y = y{idx}(1:steps);
%     test_x = x{idx}(:, :, steps+1:end);
%     test_y = y{idx}(steps+1:end);
%     
% %     test_y = test_y';
% %     train_y = train_y';
%     test_x = squeeze(test_x);
%     train_x = squeeze(train_x);
    
    % [train_xx, train_y, test_xx, test_y] = getXDAWNFeature(train_x, train_y, test_x, test_y);
    
    train_x = reshape(x_train{idx}, [64*128, size(x_train{idx}, 3)])';
    test_x = reshape(x_test{idx}, [64*128, size(x_test{idx}, 3)])';
    
    % normalize (optimal)
    [~, mu, sigma] = zscore(train_x);
    train_x = normalize(train_x, mu, sigma);
    test_x = normalize(test_x, mu, sigma);
    
    train_y = y_train{idx};
    test_y = y_test{idx};
    
    % for multi label
%     train_y = train_y - 4;
%     test_y = test_y - 4;
    
    % % run very fast
    % aucXLDA(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'LDA');
    % aucXBLDA(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'BLDA');
    % % run relative slow
    % aucXSVM(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'SVM');
    % aucXBag(fold) 	= 	train_classifier(train_xx, train_y, test_xx, test_y, 'Bag');
    % aucSVM(fold) 	= 	train_classifier(train_x, train_y, test_x, test_y, 'SVM');
    
    aucLDA(idx) 	= 	train_classifier(train_x, train_y, test_x, test_y, 'LDA'); 
%     [accLDA, conLDA] = 	train_classifier(train_x, train_y, test_x, test_y, 'LDA'); 
    aucBag(idx) 	= 	train_classifier(train_x, train_y, test_x, test_y, 'Bag');
%      [accBag, conBag] = train_classifier(train_x, train_y, test_x, test_y, 'Bag');
    aucSVM(idx)	    = 	train_classifier(train_x, train_y, test_x, test_y, 'SVM');
%          [accSVM, conSVM] = train_classifier(train_x, train_y, test_x, test_y, 'SVM');

    
end

%save('100sub_result.mat', 'aucBag', 'aucBLDA', 'aucLDA');
