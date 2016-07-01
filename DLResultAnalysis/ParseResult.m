 %% setup environment
work_path = pwd;
cd ..
DLPATH = [pwd '\Results\DL\'];
result_folder = 'RSVP_X2_S01_RAW_CH64_P_1L';

rand_size = 5;
model_size = 11;
iter_size = 100;

% 1 or 2, 1 means keep the random model information, 2 means keep the 11
% designed model information
level = 2;    

%% start parsing
[ testAUCAll,  testAUCMax, testAUCIdx] = parse_one_exp_result...
    ( rand_size, model_size, iter_size, level, DLPATH, result_folder );

%% statistical analysis
modelName = {'ROISLT', 'LSLT', 'LT', 'LS', 'GT', 'GS', ...
    'GSGT', 'GSLT', 'LSGT', 'ROIS', 'ROISGT'};
% GS vs LS
% GS-LS, GSGT-LSGT, GSLT-LSLT
leftIdx = [6, 7, 8];
rightIdx = [4, 9, 2];
[ p(1) ] = getFriedmanTest( leftIdx, rightIdx, sort(testAUCMax,'descend') );

% GT vs LT
leftIdx = [5, 7, 9];
rightIdx = [3, 8, 2];
[ p(2) ] = getFriedmanTest( leftIdx, rightIdx, sort(testAUCMax,'descend') );

% GT vs GS
leftIdx = [5, 9];
rightIdx = [6, 8];
[ p(3) ] = getFriedmanTest( leftIdx, rightIdx, sort(testAUCMax,'descend') );

% LT vs LS
leftIdx = [3, 8];
rightIdx = [4, 9];
[ p(4) ] = getFriedmanTest( leftIdx, rightIdx, sort(testAUCMax,'descend') );

% ROI vs LS
leftIdx = [1, 10, 11];
rightIdx = [2, 4, 9];
[ p(4) ] = getFriedmanTest( leftIdx, rightIdx, sort(testAUCMax,'descend') );

%% visualization
maxVal = max(max(testAUCMax));
[idxLayerCombo, idxModel] = find(testAUCMax == maxVal);

%% plot best model
folderIdx = idxModel-1;
filePath = [folder '/' num2str(folderIdx) '/'];
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
fileName = setFilesList{idxLayerCombo};
outputFeat = csvread([filePath fileName]);
outputFeat = reshape(outputFeat, [3, 100])';


%% plot every best model
maxIterEachModel = diag(testAUCIdx(maxIdxAll, :));
[sortedVal, sortedIdx] = sort(maxValAll);
newModelName = ModelName(sortedIdx);
% fill the legend
for idx = 1:maxModelSize
    newModelName{idx} = [newModelName{idx} ': ' num2str(sortedVal(idx), '%.02f')];
end
maxModelSize = 11;
figure;
for idx = 1:maxModelSize
    currSortedIdx = sortedIdx(idx);
    currModelIterData = testAUCAll(maxIdxAll(currSortedIdx),...
        1:maxIterEachModel(currSortedIdx), currSortedIdx);
    hold on;
    if idx < 4
        plot(currModelIterData, ':');
    elseif idx < 8
        plot(currModelIterData, '--');
    elseif idx < maxModelSize
        plot(currModelIterData);
    else
        plot(currModelIterData, 'r', 'LineWidth',4);
    end
end
title('Learning curve of 11 designed CNN models');
xlabel('Training Iteration'); % x-axis label
ylabel('Performance (AUC)'); % y-axis label
set(gca,'fontsize',18);
ax = gca;
ax.XTick = 0:10:50;
ax.XTickLabel = {'0','1000','2000','3000','4000','5000'};
% ax.XTickLabelRotation = 45;
axis([0 50 0.55 0.85]);
legend(newModelName, 'Location','southeast');


