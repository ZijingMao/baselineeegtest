function [EEG] = unique_epoch(EEG)

% the data should be epoched
assert(length(size(EEG.data)) == 3, 'Make sure you have epoched data.');

% start recording duplicate event
record = 1;
recordEventLatency = EEG.urevent(record).latency;
epochLen = length(EEG.urevent);
epochNewLen = 1;

% define final variable to store usertag and epoch
eegdata = [];
userTags = {};

fprintf(1,'\nPercentage complete: ');
for idx = 2:epochLen
    % if urevent latency are not the same
    % should store old tag and change record to new record
    pcDone  =  num2str(floor(((idx-1)/epochLen) * 100));
    if(length(pcDone)  ==  1)
        pcDone(2)  =  pcDone(1);
        pcDone(1)  =  '0';
    end
    fprintf(1,'%s%%',pcDone);
    if EEG.urevent(idx).latency ~= recordEventLatency
        % disp(num2str(record));
        % define temp variable to store usertag and epoch
        tmpUserTag = [];
        % store tmp eeg data
        tmpEEGdata = EEG.data(:, :, record);
        % store tmp user tag
        startPointer = record;
        endPointer = idx - 1;
        for pointer = startPointer:endPointer
            % combine all the usertags
            tmpUserTag = [tmpUserTag ', ' EEG.urevent(pointer).usertags];          
        end
        tmpUserTag(1:2) = []; % remove the first comma
        % store the eegdata
        eegdata = cat(3, eegdata, tmpEEGdata);
        % store the usertags
        userTags(epochNewLen) = {tmpUserTag};
        % store the epoch
        epochInfo(epochNewLen) = EEG.epoch(record);
        epochInfo(epochNewLen).eventusertags = {tmpUserTag};
        % store the event
        eventInfo(epochNewLen) = EEG.event(record);
        % update record
        epochNewLen = epochNewLen + 1;
        record = idx;
        recordEventLatency = EEG.urevent(record).latency;
    end
    fprintf(1,'\b\b\b');
end
fprintf(1,'\bd.');
fprintf(1,'\n');

% record the last epoch
if record == epochLen
    % define temp variable to store usertag and epoch
    tmpUserTag = [];
    tmpEEGdata = EEG.data(:, :, record);
    % store tmp user tag
    tmpUserTag = EEG.urevent(record).usertags;       
    % store the eegdata
    eegdata = cat(3, eegdata, tmpEEGdata);
    % store the usertags
    userTags(epochNewLen) = {tmpUserTag};
    % store the epoch
    epochInfo(epochNewLen) = EEG.epoch(record);
    epochInfo(epochNewLen).eventusertags = {tmpUserTag};
    % store the event
    eventInfo(epochNewLen) = EEG.event(record);
end

% store everything in to EEG struct
EEG.trials = size(eegdata, 3);
EEG.data = eegdata;
EEG.event = eventInfo;
EEG.epoch = epochInfo;
EEG.etc.TrialTag = userTags;

EEG = eeg_checkset(EEG);

end