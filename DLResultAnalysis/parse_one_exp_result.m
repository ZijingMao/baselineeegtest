function [ testAUCAll,  testAUCMax, testAUCIdx, fileLists] = parse_one_exp_result...
    ( rand_size, model_size, iter_size, level, DLPATH, result_folder )

if level == 2
    rand_size = 1;
end

testAUCAll = zeros(rand_size, iter_size, model_size);
testAUCMax = zeros(rand_size, model_size);
testAUCIdx = zeros(rand_size, model_size);
fileLists = cell(1, model_size);
% maxValAll = zeros(model_size, 1);
% maxIdxAll = zeros(model_size, 1);
% maxFileAll = cell(model_size, 1);

for folderIdx = 0:model_size-1
    disp(num2str(folderIdx));
    filePath = [DLPATH result_folder '\' num2str(folderIdx) '\'];
    
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
    fileLists{folderIdx+1} = setFilesList;
    % the index of the file
    if level == 2
        [ testAUCAll(:, :, folderIdx+1), ...
            testAUCMax(:, folderIdx+1), ...
            testAUCIdx(:, folderIdx+1)] = ...
            getAUC1Arch( setFilesList, filePath, iter_size );
    else
        [ testAUCAll(:, :, folderIdx+1), ...
            testAUCMax(:, folderIdx+1), ...
            testAUCIdx(:, folderIdx+1)] = ...
            getAUC1Model( setFilesList, filePath, iter_size );
    end
%     [maxVal, maxIdx] = max(testAUCMax(:, folderIdx+1));
%     maxValAll(folderIdx+1) = maxVal(1);
%     maxIdxAll(folderIdx+1) = maxIdx(1);
%     maxFileAll{folderIdx+1} = setFilesList{maxIdxAll(folderIdx+1)};
end

end

