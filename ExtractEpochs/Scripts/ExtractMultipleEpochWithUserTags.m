for idxDataSet = 1:4
    
    %% your session size
    windStub = 'I:/BadWindowsBCIT/';
    windFile = [windStub expName{idxDataSet} 'badWindows.mat'];
    badWindows = [];
    load(windFile);
    dataPath = ['I:/level2_256Hz/' expName{idxDataSet} '/'];
    expStub = 'I:/level2_256Hz_epoch/';
    expPath = [expStub expName{idxDataSet} '/'];
    
    obj = levelDerivedStudy('levelDerivedXmlFilePath', dataPath);
    [files, dataRecordingUuids, taskLabels, sessionNumbers, Subjects] = ...
        obj.getFilename;
    
    if length(files) ~= length(badWindows)
        error('Please check the file list is correct');
    end
    
    sessionSize = length(files);
    
    %% run experiment
    % this will extract epochs without bad epoch filtering
    ExtractEpochWithUserTags;
    % this will filter bad epoch and concat sessions with same subjects
    % SaveEpochMatByExperiment;
    % save subject information
    
end