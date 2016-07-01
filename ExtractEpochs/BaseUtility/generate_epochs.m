function [ input, label, subID ] = generate_epochs( idx, varargin )

if nargin == 1
    FilePath = ['/home/zijing.mao/X2_RSVP_Expertise/session/' num2str(idx) '/'];

    filelist2cell = @(str) extractfield( (dir(str)), 'name' );
    eeg_dataset_list = filelist2cell(FilePath)';
    selectSetFile = @(str) str(1:( strfind(str, '.set')+3 ));
    eeg_dataset_list = cellfun(@(str) selectSetFile(str), eeg_dataset_list, 'UniformOutput', false);
    eeg_dataset_list_idx = find(~cellfun(@isempty,eeg_dataset_list));

    FileName = eeg_dataset_list{eeg_dataset_list_idx(1)};
else
    FilePath = varargin{1};
    FileName = varargin{2};
end

% load EEG data
EEG = pop_loadset('filename',FileName,'filepath',FilePath);

EEG.data = double(EEG.data);

input = EEG.data;
if isfield(EEG.etc, 'labels')
    label = EEG.etc.labels;
else
    label = EEG.etc.hedVector;
end
subID = EEG.etc.TrialData.subject;

end

