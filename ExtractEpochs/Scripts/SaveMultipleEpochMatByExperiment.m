for idxDataSet = 5:6
    
    %% your session
    dataPath = ['I:/level2_256Hz/' expName{idxDataSet} '/'];
    expStub = 'I:/level2_256Hz_epoch/';
    expPath = [expStub expName{idxDataSet} '/'];
    
    obj = levelDerivedStudy('levelDerivedXmlFilePath', dataPath);
    [files, dataRecordingUuids, taskLabels, sessionNumbers, Subjects] = ...
        obj.getFilename;
    dataPath = ['I:/level2_256Hz/' expName{idxDataSet} '/session/'];
    expStub = 'I:/level2_256Hz_epoch/';
    
    sessionSize = length(files);
    
    %% run experiment
    % this will extract epochs without bad epoch filtering
    % ExtractEpochWithUserTags;
    % this will filter bad epoch and concat sessions with same subjects
    SaveEpochMatByExperiment;
    
end