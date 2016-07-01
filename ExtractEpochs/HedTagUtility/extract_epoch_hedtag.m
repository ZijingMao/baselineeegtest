function [EEG] = extract_epoch_hedtag(EEG, varargin)

% change to double precision
pop_editoptions('option_single', false, 'option_savetwofiles', false);  
EEG.data = double(EEG.data); 

postfix = [];
resampleRate = 256;
rechannelRate = 256;
channelIdx = 1:256;
isRejectEpoch = true;
filterband = [0.1 55];
epochRange = [-1 1];

if nargin > 2
    if ~(round(nargin/2) == nargin/2)
        error('Odd number of input arguments.')
    end
    for i = 1:2:length(varargin)
        Param = varargin{i};
        Value = varargin{i+1};
    
        if ~isstr(Param)
                error('Flag arguments must be strings')
        end
        Param = lower(Param);
        switch Param
            case 'resample'
                resampleRate = Value;
            case 'rechannel'
                rechannelRate = Value;
            case 'selectchannel'
                channelIdx = Value;
            case 'rejectepoch'
                isRejectEpoch = Value;
            case 'filtering'
                filterband = Value;
            case 'epochrange'
                epochRange = Value;
        end
    end
end

%% resampling
if resampleRate < EEG.srate % if sampling rate is smaller, then do resampling
    EEG = pop_resample( EEG, resampleRate);
    EEG = eeg_checkset( EEG );
    postfix = [postfix '.resample_' num2str(resampleRate) '_Hz'];
end

%% Re-channel
if rechannelRate == 64
    channel_location = EEG.chanlocs;
    selectedIdx = [];
    load chanidx.mat;
    % select correct channel
    EEG.nbchan = 64;
    EEG.data = EEG.data(selectedIdx, :);
    EEG.chanlocs = EEG.chanlocs(selectedIdx);
    EEG.urchanlocs = EEG.urchanlocs(selectedIdx);
    EEG = eeg_checkset( EEG );
    postfix = [postfix '.rechan_' num2str(rechannelRate)];
end

%% select channels
if ~isempty(channelIdx)
    EEG = pop_select( EEG,'channel', channelIdx );
end

%% do filtering
% isFilter = ture;
if length(filterband) == 2
    % high pass
    EEG = pop_eegfiltnew(EEG, [], filterband(1), [], true, [], 0);   
    % low pass
    EEG = pop_eegfiltnew(EEG, filterband(2), [], [], true, [], 0);
    close all;    
    postfix = [postfix '.filter_' num2str(filterband(1)) '_' num2str(filterband(2)) '_Hz'];
end

%% epoch extraction
if length(epochRange) == 2
    EEG = pop_epoch(EEG, {}, epochRange,'epochinfo','yes');
    if epochRange(1) < 0
        EEG = pop_rmbase(EEG, [1000*epochRange(1) 0]);   
    else
        EEG = pop_rmbase(EEG, []);
    end
    postfix = [postfix '.epoched_' num2str(epochRange(1)) '_' num2str(epochRange(2))];
end

%% reject abnormal probability distribution
% EEG = eeg_rejsuperpose( EEG, 1, 1, 1, 1, 1, 1, 1, 1);
% EEG = pop_rejepoch( EEG, [],0);
if isRejectEpoch == true
    EEG = pop_jointprob(EEG,1,[1:size(EEG.data,1)] ,8,8,1,0);
    EEG = eeg_rejsuperpose( EEG, 0, 1, 1, 1, 1, 1, 1, 1);
    rejIdx = find(EEG.reject.rejglobal);
    EEG = pop_rejepoch( EEG, rejIdx, 0);
    EEG.urevent(rejIdx) = [];
    postfix = [postfix '.rejected'];
end

%% epoch combination 
% combine epochs usertag if the event latencies are the same
[EEG] = unique_epoch(EEG);

%% get hedtag vectors
% % split the tag with comma
% for idx = 1:length(userTags)
%     inputTag = strsplit(userTags{idx},',');
% get the inputTag to generate hedTag and hedVector
[EEG.etc.hedVector, EEG.etc.hedTag] = hed_to_vector(EEG.etc.TrialTag, false);
% end

%% save the data and label
% eegdata = EEG.data;
% eeglabel = EEG.etc.hedVector';
% save([fileName, postfix, '.mat'], 'eegdata', 'eeglabel', '-v7.3');



end
