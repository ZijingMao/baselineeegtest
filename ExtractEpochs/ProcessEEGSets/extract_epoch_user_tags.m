function extract_epoch_user_tags( configs, exp_id )

windStub = configs.windStub;
windFile = [windStub configs.exp_names(exp_id).name 'badWindows.mat'];

badWindows = [];
load(windFile);

% set input data path
dataPath = [configs.file_path configs.exp_names(exp_id).name '/'];

% set output data path
expStub = configs.save_path;
expPath = [expStub configs.exp_names(exp_id).name '/'];

disp(['parse experiment: ' configs.exp_names(exp_id).name ...
    ', added into configuration']);
configs.exp_id = exp_id;

% get all the recording files
obj = levelDerivedStudy('levelDerivedXmlFilePath', dataPath);
[files, dataRecordingUuids, taskLabels, sessionNumbers, Subjects] = ...
    obj.getFilename;

if length(files) ~= length(badWindows)
    error('Please check the file list is correct');
end

sessionSize = length(files);

if configs.ismultithread	
    parfor sessID = 1:sessionSize
        % disp(num2str(sessID));
        filename = files{sessID};
        badWindow = badWindows(sessID);
        parse_one_session( filename, expPath, configs, badWindow );
    end
else	
    for sessID = 1:sessionSize
        % disp(num2str(sessID));
        filename = files{sessID};
        badWindow = badWindows(sessID);
        parse_one_session( filename, expPath, configs, badWindow );
    end
end

end