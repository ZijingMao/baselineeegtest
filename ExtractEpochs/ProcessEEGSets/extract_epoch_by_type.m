function [ EEG ] = extract_epoch_by_type( EEG, configs, varargin )

assert(isfield(configs, 'exp_id'), ...
    ['Please specifiy a paricular experiment type to analysis',...
    '(1). Experiment X6 Speed Control;', ...
    '(2). Experiment X2 Traffic Complexity;', ...
    '(3). Experiment XB Baseline Driving;', ...
    '(4). Experiment XC Calibration Driving;', ...
    '(5). X3 Baseline Guard Duty;', ...
    '(6). X4 Advanced Guard Duty;', ...
    '(7). X2 RSVP Expertise;', ...
    '(8). X1 Baseline RSVP;', ...
    '(9). Experiment X7 Auditory Cueing;', ...
    '(10). Experiment X8 Mind Wandering;']);

% change to double precision
pop_editoptions('option_single', false, 'option_savetwofiles', false);
EEG.data = double(EEG.data);

postfix = [];
resampleRate = 256;
rechannelRate = 256;
channelIdx = [];
isRejectEpoch = true;
filterband = [0.1 55];
epochRange = [];
badWindow = [];

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
            case 'badwindow'
                badWindow = Value;
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
if rechannelRate == 64 && configs.exp_names(configs.exp_id).nbchan == 256
    % select correct channel
    %     EEG.nbchan = 64;
    %     EEG.data = EEG.data(configs.chanlocs256to64, :);
    %     EEG.chanlocs = EEG.chanlocs(configs.chanlocs256to64);
    %     EEG.urchanlocs = EEG.urchanlocs(configs.chanlocs256to64);
    %     EEG = eeg_checkset( EEG );
    %     postfix = [postfix '.rechan_' num2str(rechannelRate)];
    channelIdx = configs.chanlocs256to64;
elseif configs.exp_names(configs.exp_id).nbchan == 64
    channelIdx = 1:64;
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
    % close all;
    postfix = [postfix '.filter_' num2str(filterband(1)) '_' num2str(filterband(2)) '_Hz'];
end

%% epoch extraction
%==================  Key function =========================================
if isempty(epochRange)
    %     epochLabel = configs.exp_names(configs.exp_id).label;
    % the for loop will be used after code finished
    %     for idx_epochLabel = 1:length(epochLabel)   % extract epoch for each of them
    %         epochRange = epochLabel(idx_epochLabel).etime;
    %         assert(~isempty(epochRange), 'Please check your define the epoch time range');
    %         assert(length(epochRange) == 2, 'Please check epoch time range correct');
    
    [events, epochRange] = get_epoch_cut_event(configs, configs.epoch_type);   % TODO: define the function here
    EEG = pop_epoch(EEG, events{1}, epochRange, 'epochinfo','yes');
    EEG = pop_rmbase(EEG, []);
    %         if epochRange(1) < 0
    %             EEG = pop_rmbase(EEG, [1000*epochRange(1) 0]);
    %         else
    %             EEG = pop_rmbase(EEG, []);
    %         end
    EEG.etc.labels = get_epoch_label(EEG, configs, events, configs.epoch_type);   % TODO: define the function here
    assert(length(EEG.etc.labels) == length(EEG.epoch), 'Error: epoch size not match');
    %     end
end
%==================  Key function =========================================

%% filter bad channel
if ~isempty(badWindow)
    [EEG] = filter_bad_windows(EEG,badWindow);
end

%% reject abnormal probability distribution
% EEG = eeg_rejsuperpose( EEG, 1, 1, 1, 1, 1, 1, 1, 1);
% EEG = pop_rejepoch( EEG, [],0);
if isRejectEpoch == true
    EEG = pop_jointprob(EEG,1,[1:size(EEG.data,1)] ,8,8,1,0);
    EEG = eeg_rejsuperpose( EEG, 0, 1, 1, 1, 1, 1, 1, 1);
    rejIdx = find(EEG.reject.rejglobal);
    if ~isempty(rejIdx)
        EEG = pop_rejepoch( EEG, rejIdx, 0);
        EEG.urevent(rejIdx) = [];
    else
        EEG.event = [];
    end
    postfix = [postfix '.rejected'];
end

%% epoch combination
% combine epochs usertag if the event latencies are the same
% [EEG] = unique_epoch(EEG);

%% get hedtag vectors
% % split the tag with comma
% for idx = 1:length(userTags)
%     inputTag = strsplit(userTags{idx},',');
% get the inputTag to generate hedTag and hedVector
% [EEG.etc.hedVector, EEG.etc.hedTag] = hed_to_vector(EEG.etc.TrialTag, false);
% end

%% save the data and label
% eegdata = EEG.data;
% eeglabel = EEG.etc.hedVector';
% save([fileName, postfix, '.mat'], 'eegdata', 'eeglabel', '-v7.3');


end

