%% setup environment

% work_path = pwd;
% cd ..
DLPATH = ['C:\Users\EEGLab\Dropbox\UTSA Research\Collaboration\EEGRoomPC\Reports\MultiLayerAnalysis\'];
results_folder = {'RSVP_X2_S01_RAW_CH128_FOLD2'};

rand_size = 5;
model_size = 11;
iter_size = 100;

% 1 or 2, 1 means keep the random model information, 2 means keep the 11
% designed model information
level = 2;

%% start parsing

testAUCAll = zeros(length(results_folder), iter_size, model_size);
testAUCMax = zeros(length(results_folder), model_size);
testAUCIdx = zeros(length(results_folder), model_size);
for idx = 1:length(results_folder)
    result_folder = results_folder{idx};
    [ testAUCAll(idx, :, :),  testAUCMax(idx, :), testAUCIdx(idx, :)] =...
        parse_one_exp_result...
        ( rand_size, model_size, iter_size, level, DLPATH, result_folder );
end

%% statistic test

% ROICNN, CVCNN, LS, TSCNN, ROISCNN, ROITSCNN
% INFERENCE_ROICNN        = 0
% INFERENCE_CVCNN         = 1
% INFERENCE_LOCAL_T_CNN   = 2
% INFERENCE_LOCAL_S_CNN   = 3
% INFERENCE_GLOBAL_T_CNN  = 4
% INFERENCE_GLOBAL_S_CNN  = 5
% INFERENCE_DNN_CNN       = 6
% INFERENCE_STCNN         = 7
% INFERENCE_TSCNN         = 8
% INFERENCE_ROI_S_CNN     = 9
% INFERENCE_ROI_TS_CNN    = 10

comparing_idx = [0, 1, 3, 8, 9, 10];
comparing_idx = comparing_idx + 1;

comparing_idx = [3     5     6    8];

[h, p] = ttest(testAUCMax(1, comparing_idx), testAUCMax(2, comparing_idx));

