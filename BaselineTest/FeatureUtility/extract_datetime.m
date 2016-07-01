function [ EEGdate, EEGtime, EEGSub ] = extract_datetime( idx )

FilePath = ['/home/zijing.mao/X2_RSVP_Expertise/session/' num2str(idx) '/'];

filelist2cell = @(str) extractfield( (dir(str)), 'name' );
eeg_dataset_list = filelist2cell(FilePath)';
selectSetFile = @(str) str(1:( strfind(str, '.set')+3 ));
eeg_dataset_list = cellfun(@(str) selectSetFile(str), eeg_dataset_list, 'UniformOutput', false);
eeg_dataset_list_idx = find(~cellfun(@isempty,eeg_dataset_list));

FileName = eeg_dataset_list{eeg_dataset_list_idx(1)};

% load EEG data
EEG = pop_loadset('filename',FileName,'filepath',FilePath);


EEGdate = EEG.etc.date;
EEGtime = EEG.etc.time;
EEGSub = EEG.etc.TrialData.subject;

end

