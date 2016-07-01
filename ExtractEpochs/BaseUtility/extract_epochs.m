function extract_epochs(idx, isResample, isReChans, isFilter, isEpoch)

FilePath = ['/home/zijing.mao/X2_RSVP_Expertise/' num2str(idx) '/'];

filelist2cell = @(str) extractfield( (dir(str)), 'name' );
eeg_dataset_list = filelist2cell(FilePath)';
selectSetFile = @(str) str(1:( strfind(str, '.set')+3 ));
eeg_dataset_list = cellfun(@(str) selectSetFile(str), eeg_dataset_list, 'UniformOutput', false);
eeg_dataset_list_idx = find(~cellfun(@isempty,eeg_dataset_list));

FileName = eeg_dataset_list{eeg_dataset_list_idx(1)};

% load EEG data
EEG = pop_loadset('filename',FileName,'filepath',FilePath);

postfix = [];

% get channel inforamtion
if isReChans
    channel_location = EEG.chanlocs;
    selectedIdx = [];
    load chanidx.mat;
    % select correct channel
    EEG.nbchan = 64;
    EEG.data = EEG.data(selectedIdx, :);
    EEG.chanlocs = EEG.chanlocs(selectedIdx);
    EEG.urchanlocs = EEG.urchanlocs(selectedIdx);
    EEG = eeg_checkset( EEG );
    postfix = [postfix '_64chan'];
end

if isFilter
    [freq_spectra_data, ~, ~, ~] = pop_spectopo(EEG, 1, ...
            [EEG.xmin (EEG.xmax*1000)], ...
            'EEG' , 'percent', 15, 'freqrange', [2 25], 'electrodes', 'off');
    savefig(gcf, [num2str(idx) 'prev.fig']);
    close all;

    % high pass
    EEG = pop_eegfiltnew(EEG, [], 0.1, [], true, [], 0);

    [freq_spectra_data, ~, ~, ~] = pop_spectopo(EEG, 1, ...
            [EEG.xmin (EEG.xmax*1000)], ...
            'EEG' , 'percent', 15, 'freqrange', [2 25], 'electrodes', 'off');
    savefig(gcf, [num2str(idx) 'pqid.fig']);
    close all;
    
    % low pass
    EEG = pop_eegfiltnew(EEG, 55, [], [], true, [], 0);
    
    [freq_spectra_data, ~, ~, ~] = pop_spectopo(EEG, 1, ...
            [EEG.xmin (EEG.xmax*1000)], ...
            'EEG' , 'percent', 15, 'freqrange', [2 25], 'electrodes', 'off');
    savefig(gcf, [num2str(idx) 'post.fig']);
    close all;    
    postfix = [postfix '_0.1_55Hz'];
end

% resampling
if isResample
    EEG = pop_resample( EEG, 128);
    EEG = eeg_checkset( EEG );
    postfix = [postfix '_sample128'];
end

if isEpoch
    % get events
    nontarget_event = '1321';
    target_event = '1311';
    events = {  nontarget_event, target_event  };

    % extract epoch 252
    EEG = pop_epoch( EEG, events, [0 1], 'newname', ...
        'epochs', 'epochinfo', 'yes');
    
    EEG = eeg_checkset( EEG );
    EEG = pop_rmbase( EEG, []);
    
    [epochIdx, eventIdx] = filterEpochs(EEG.event, events);
    
    EEG.trials = length(epochIdx);
    EEG.data = EEG.data(:, :, epochIdx);
    EEG.epoch = EEG.epoch(epochIdx);
    EEG.etc.labels = eventIdx;
    
    EEG = eeg_checkset( EEG );
    
    postfix = [postfix '_epoched'];
end

EEG.data = double(EEG.data);

% remove the previous file
delete([FilePath FileName]);

% save data out
pop_saveset(EEG, 'filename',[FileName(1:end-4) postfix '.set'],'filepath',FilePath);

end