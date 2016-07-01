function tag_one_session( expName, sessionName )

sessionName = num2str(sessionName);
filePath = ['/home/research/BCIT_ESS_256Hz/' expName '/session/' sessionName '/'];

% % Get all the file names
% filelist2cell = @(str) extractfield( (dir(str)), 'name' );
% eegDatasetList = filelist2cell(filePath)';
% eegDatasetList(1:2) = [];
% 
% % Keep only the .set files on the list (used for loading EEG data)
% selectSetFile = @(str) str(1:( strfind(str, '.set') + 3));
% eegDatasetList = cellfun(@(str) selectSetFile(str), eegDatasetList, 'UniformOutput', false);
% emptyEntries = logical(cell2mat(cellfun(@(str) isempty(str), eegDatasetList, 'UniformOutput', false)));
% setFilesList = eegDatasetList(~emptyEntries)';
% 
% assert(length(setFilesList) == 1, 'Not clear which .set file you want to choose...');

% load eeg data

fileName = strsplit(ls(filePath));
fileName = fileName{1};
EEG = pop_loadset('filename',fileName, 'filepath', filePath);

% change to double precision
pop_editoptions('option_single', false, 'option_savetwofiles', false);  
EEG.data = double(EEG.data); 

% run extract epoch
EEG = extract_epoch_hedtag(EEG, fileName);

pop_saveset(EEG, 'filename',[fileName(1:end-4) '_tagepoch.set'],'filepath',filePath, 'version', '7.3');

end

