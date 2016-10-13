% % DLPATH = ['C:\Users\EEGLab\Documents\result\SelectFeat\' hyper_param_str];
% DLPATH = ['C:\Users\EEGLab\Documents\20160527_RSVP_DATASET\X2RSVP\'];
% RLTPATH = ['C:\Users\EEGLab\Dropbox\UTSA Research\Collaboration' ...
%     '\EEGRoomPC\Reports\CSA_Result'];
%
% folderIdxs = [5];
%
% top_value = 10;
% total_sub = 10;
%
% subID = 1;
%
% result_folders = {['RSVP_X2_S' num2str(subID, '%02i') '_NORM_CH64'], ...
%     ['RSVP_X2_S' num2str(subID, '%02i') '_RAW_CH64'], ...
%     ['RSVP_X2_S' num2str(subID, '%02i') '_RAWFREQ_CH64'], ...
%     ['RSVP_X2_S' num2str(subID, '%02i') '_NORMFREQ_CH64'], ...
%     ['RSVP_X2_S' num2str(subID, '%02i') '_FREQ_CH64']};
%
% result_folder = result_folders{2};
%
% load([DLPATH result_folder '.mat']);

load('C:\Users\EEGLab\Documents\20160527_RSVP_DATASET\X2RSVP64CHAN.mat');
train_x = []; train_y = []; test_x = []; test_y = []; steps = 0;
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
    [ tmp_train_x, tmp_train_y, ...
        tmp_test_x, tmp_test_y] = ...
        construct_train_test( x{idx}, y{idx}, steps, idx );
    train_x = cat(3, train_x, tmp_train_x);
    test_x = cat(3, test_x, tmp_test_x);
    train_y = cat(1, train_y, tmp_train_y);
    test_y = cat(1, test_y, tmp_test_y);
end

train_x = permute(train_x, [2, 1, 4, 3]);
test_x = permute(test_x, [2, 1, 4, 3]);
test_y = test_y-1;
train_y = train_y-1;

save(['C:\Users\EEGLab\Documents\20160527_RSVP_DATASET\SUB\SUBS11.mat'], ...
    'train_x', 'test_x', 'train_y', 'test_y', '-v7.3');
