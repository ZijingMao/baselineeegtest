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

train_x = []; train_y = []; test_x = []; test_y = []; steps = 0;
for idx = 9:108
    load(['I:\level2_256Hz_epoch\FatigueLevel\Experiment XB Baseline Driving\XB_sliced_labled\XB_subj' ...
          num2str(idx)]);
    datasize = length(y_sliced);
    
    % check datasize greater than 500 or not
    islarger500 = datasize > 500;
    if islarger500
        testing_size = mod(datasize, 100) + 100;
        training_size = datasize - testing_size;
    else
        testing_size = mod(datasize, 100);
        training_size = datasize - testing_size;
    end
    
    [ tmp_train_x, tmp_train_y, ...
        tmp_test_x, tmp_test_y] = ...
        construct_train_test( x_sliced, y_sliced, training_size, idx );
    train_x = cat(3, train_x, tmp_train_x);
    test_x = cat(3, test_x, tmp_test_x);
    train_y = cat(1, train_y, tmp_train_y);
    test_y = cat(1, test_y, tmp_test_y);
end

train_x = permute(train_x, [2, 1, 4, 3]);
test_x = permute(test_x, [2, 1, 4, 3]);
test_y = test_y';
train_y = train_y';
% test_y = test_y-1;
% train_y = train_y-1;

save(['I:\level2_256Hz_epoch\FatigueLevel\Experiment XB Baseline Driving\XB_sliced_labled\combined_subjects.mat'], ...
    'train_x', 'test_x', 'train_y', 'test_y', '-v7.3');
