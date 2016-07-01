function [ testAUCAll, trainAUCAll, validAUCAll, testAUCMax, testAUCIdx, ...
    currMaxIdx, setFilesList] = get_one_fold_result...
    ( DLPATH, result_folder, folderIdx )

% maxValAll = zeros(model_size, 1);
% maxIdxAll = zeros(model_size, 1);
% maxFileAll = cell(model_size, 1);

disp(num2str(folderIdx));
filePath = [DLPATH '\' result_folder '\' num2str(folderIdx) '\'];

filelist2cell = @(str) extractfield( (dir(str)), 'name' );
eegDatasetList = filelist2cell(filePath)';
eegDatasetList(1:2) = [];
% find auc csv file
selectSetFile = @(str) str(1:( strfind(str, '.auc.csv') + 7));
eegDatasetList = cellfun(@(str) selectSetFile(str),...
    eegDatasetList, 'UniformOutput', false);
emptyEntries = logical(cell2mat(cellfun(@(str) isempty(str),...
    eegDatasetList, 'UniformOutput', false)));
setFilesList = eegDatasetList(~emptyEntries)';
% the index of the file

[ testAUCAll, trainAUCAll, validAUCAll, testAUCMax, testAUCIdx, ...
    currMaxIdx, setFilesList ] = get_auc_arch...
    ( setFilesList, filePath );

end

