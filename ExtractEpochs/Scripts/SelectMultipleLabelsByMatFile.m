datasetName = 'DatasetBinaryBaselineRSVP';
expStr = [expName(1), expName(2), expName(3), expName(4)];
expStub = 'I:/level2_256Hz_epoch/';
expDatasetFile = [expStub datasetName '/'];

if ~exist(expDatasetFile, 'dir')
    mkdir(expDatasetFile)
end

for expIdx = 1:length(expStr)
    dataPath = ['I:/level2_256Hz/' expStr{expIdx} '/'];
    expPath = [expStub expStr{expIdx} '/'];
    
    obj = levelDerivedStudy('levelDerivedXmlFilePath', dataPath);
    [files, dataRecordingUuids, taskLabels, sessionNumbers, Subjects] = ...
        obj.getFilename;
    
    sessionSize = length(files);
    
    load([expStub expStr{expIdx} '.mat'], 'labels');
    
    if sessionSize ~= length(labels)
        error('Please check the file list is correct');
    end
    
    interestLabels = [6, 7];    % represent right and left perturbation labels
    balanced = 1;
    
    %% run epoch extraction
    for idx = 15:sessionSize
        dataFile = files(idx);
        [path, name, ext] = fileparts(dataFile{:});
        fileName = [name '_tagepoch.set'];
        
        [ data, label ] = extract_epoch_label...
            ( expPath, fileName, labels{idx}, interestLabels, balanced );
        
        % save data and label file
        if ~isempty(data)
            save([expStub, datasetName, '/', expStr{expIdx}, num2str(idx), '.mat'], ...
                'data', 'label', '-v7.3');
        end
    end
end