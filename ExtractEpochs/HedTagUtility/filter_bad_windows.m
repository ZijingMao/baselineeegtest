function [EEG] = filter_bad_windows(EEG, varargin)

if nargin == 1  % no bad window information, search from EEG struct
    error('not implemented');
else
    badWindow = varargin{1};
end

cWin = badWindow.correlation;
dWin = badWindow.deviation;

badChanIdx = logic_window(cWin, dWin, badWindow.evaluationChannels);
urevent = EEG.urevent;
srate = EEG.srate;

% intialize a logic for bad event
ureventLen = length(urevent);
ureventBadIdx = zeros(1, ureventLen);
ureventBadLatency = [];
for ureventIdx = 1:ureventLen
    currentEventLatency = urevent(ureventIdx).latency;
    for windIdx = 1:length(badChanIdx)
        startTime = (badChanIdx(windIdx)-1)*srate+1;
        endTime = badChanIdx(windIdx)*srate;
        % if the current event latency is in between start & end
        if startTime < currentEventLatency && endTime > currentEventLatency
            ureventBadIdx(ureventIdx) = 1;
            ureventBadLatency = [ureventBadLatency currentEventLatency];
        end
    end
end
% set bad event to empty
urevent(logical(ureventBadIdx)) = [];
% update EEG event
EEG.urevent = urevent;
EEG.event = urevent;
EEG.etc.ureventBadLatency = ureventBadLatency;
disp(['First round bad window ' num2str(length(ureventBadLatency)) ' removed']);
disp(['Take the percentage ' num2str(length(ureventBadLatency)/ureventLen)]);

end