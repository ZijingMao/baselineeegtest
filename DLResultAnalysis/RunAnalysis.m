
%%

DLPATH = ['C:\Users\EEGLab\Dropbox\UTSA Research\Collaboration\EEGRoomPC\Reports\MultiLayerAnalysis'];

result_folder = 'RSVP_X2_S01_RAW_CH64';

folderIdx = 7;

[ testAUCAll, trainAUCAll, validAUCAll, testAUCMax, testAUCIdx, ...
    currMaxIdx, setFilesList] = get_one_fold_result...
    ( DLPATH, result_folder, folderIdx );

[i,j]=find(validAUCAll == max(max(validAUCAll)));
testAUCAll(i,j);
max(max(validAUCAll))

[i,j]=find(testAUCAll == max(max(testAUCAll)));
a = testAUCAll(i, 1:j);
a = a';

%%

% DLPATH = ['C:\Users\EEGLab\Documents\result\SelectFeat\' hyper_param_str];
DLPATH = ['C:\Users\EEGLab\Documents\20160527_RSVP_DATASET\Result\'];
RLTPATH = ['C:\Users\EEGLab\Dropbox\UTSA Research\Collaboration' ...
    '\EEGRoomPC\Reports\CSA_Result'];

folderIdxs = [5];

top_value = 10;
total_sub = 10;

best1_vals_all = zeros(5, total_sub);

result_folders = {['RSVP_X2_S' num2str(subID, '%02i') '_NORM_CH64'], ...
    ['RSVP_X2_S' num2str(subID, '%02i') '_RAW_CH64'], ...
    ['RSVP_X2_S' num2str(subID, '%02i') '_RAWFREQ_CH64'], ...
    ['RSVP_X2_S' num2str(subID, '%02i') '_NORMFREQ_CH64'], ...
    ['RSVP_X2_S' num2str(subID, '%02i') '_FREQ_CH64']};

for subID = 1:total_sub
    
    for idx = 1:length(folderIdxs);
        folderIdx = folderIdxs(idx);
        total_type_size = length(result_folders);
        top16_vals = zeros(top_value, total_type_size);
        top16_models = cell(top_value, total_type_size);
        best1_vals = zeros(1, total_type_size);
        
        for rlt_fld_idx = 1:total_type_size
            
            [ testAUCAll, trainAUCAll, validAUCAll, testAUCMax, testAUCIdx, ...
                currMaxIdx, setFilesList] = get_one_fold_result...
                ( DLPATH, result_folders{rlt_fld_idx}, folderIdx );
            
            [i,j]=find(validAUCAll == max(max(validAUCAll)));
            best1_vals(rlt_fld_idx) = testAUCAll(i,j);
            
            [top16_vals(:, rlt_fld_idx), top16_models(:, rlt_fld_idx)] = ...
                get_top_16_model(validAUCAll, testAUCAll, setFilesList, top_value);
            
        end
        save([RLTPATH '\S' num2str(subID, '%02i') 'model' num2str(folderIdx) '.mat'],...
            'top16_models', 'top16_vals', 'best1_vals');
        best1_vals_all(:, subID ) = top16_vals(end, :);
    end
    
end

%%
topSize = 16;

hyper_param_str = 'Lr0.006';

DLPATH = ['C:\Users\EEGLab\Documents\result\SelectFeat\' hyper_param_str];
RLTPATH = ['C:\Users\EEGLab\Dropbox\UTSA Research\Collaboration' ...
    '\EEGRoomPC\Reports\CSA_Result'];

result_folders = {'RSVP_X2_S01_FREQ_CH64', ...
    'RSVP_X2_S01_RAWP300FREQ_CH64'};
folderIdxs = [0, 5];
for idx = 1:length(folderIdxs);
    folderIdx = folderIdxs(idx);
    total_type_size = length(result_folders);
    top16_vals = zeros(16, total_type_size);
    top16_models = cell(16, total_type_size);
    best1_vals = zeros(1, total_type_size);
    
    for rlt_fld_idx = 1:total_type_size
        
        [ testAUCAll, trainAUCAll, validAUCAll, testAUCMax, testAUCIdx, ...
            currMaxIdx, setFilesList] = get_one_fold_result...
            ( DLPATH, result_folders{rlt_fld_idx}, folderIdx );
        
        [i,j]=find(validAUCAll == max(max(validAUCAll)));
        best1_vals(rlt_fld_idx) = testAUCAll(i,j);
        
        [top16_vals(:, rlt_fld_idx), top16_models(:, rlt_fld_idx)] = ...
            get_top_16_model(validAUCAll, testAUCAll, setFilesList, topSize);
        
    end
    save([RLTPATH '\model' num2str(folderIdx) hyper_param_str '.mat'],...
        'top16_models', 'top16_vals', 'best1_vals');
end
%%
[h_norm_vs_raw, p_norm_vs_raw] = ttest(top16_vals(:, 1), top16_vals(:, 2));
[h_raw_vs_rawp300, p_raw_vs_rawp300] = ttest(top16_vals(:, 2), top16_vals(:, 4));
[h_raw_vs_rawfreq, p_raw_vs_rawfreq] = ttest(top16_vals(:, 2), top16_vals(:, 3));

