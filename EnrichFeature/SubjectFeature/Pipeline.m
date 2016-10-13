%% load data
load('RSVP_DRIVE_S101_RAW_CH64.mat');
% train_x, test_x, train_y, test_y

%% preprocessing
test_x = squeeze(test_x);
train_x = squeeze(train_x);
% switch time by channel to channel by time
test_x = permute(test_x, [2, 1, 3]);
train_x = permute(train_x, [2, 1, 3]);

%% feature selection
% feature for the ar
[test_x_ar] = get_ar_feature(test_x);
[train_x_ar] = get_ar_feature(train_x);
save('C:\Users\EEGLab\Documents\20160527_RSVP_DATASET\Driving\DRIVE_SUB_S101_AR_CH64.mat', 'test_x_ar', 'train_x_ar', '-v7.3');
% feature for the freq
[ test_x_freq ] = get_freq_feature( test_x );
[ train_x_freq ] = get_freq_feature( train_x );
save('C:\Users\EEGLab\Documents\20160527_RSVP_DATASET\Driving\DRIVE_SUB_S101_FREQ_CH64.mat', 'test_x_freq', 'train_x_freq', '-v7.3');