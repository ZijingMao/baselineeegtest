function [ epochIdx, eventIdx ] = filter_epochs( eventStruct, events )

epoch = [];
eventTable = [];
tmpEvent = [];
unsortedEpoch = zeros(length(eventStruct), 1);

% first try to sort the epoch events - necessary because the epoching
% program might be buggingly change the epoch sort based on event time
for idx = 1:length(eventStruct)
    unsortedEpoch(idx) = eventStruct(idx).epoch;
end
[~, sortedEpochIdx] = sort(unsortedEpoch);
eventStruct = eventStruct(sortedEpochIdx);

for idx = 1:length(eventStruct)
    epochStruct = eventStruct(idx).epoch;
    eventTypeStruct = eventStruct(idx).type;
    if isempty(tmpEvent)
        tmpEvent = strmatch(eventTypeStruct, events);
    end    
    if ~any(epoch == epochStruct)
        epoch = [epoch; epochStruct];
        % always the first event is working as the event type
        eventTable = [eventTable; tmpEvent];
        % the next event should be this is a new epoch and the new epoch
        % event is the next event
        tmpEvent = strmatch(eventTypeStruct, events);
    end
end
eventTable = [eventTable; tmpEvent];


urevent = cell(1, length(epoch));
ureventTmp = [];
pointer = 1;
for idx = 1:length(eventStruct)
    
    epochStruct = eventStruct(idx).epoch;
    ureventStruct = eventStruct(idx).urevent;

%     if idx >= 241670
%         disp('');
%     end

    if epoch(pointer) ~= epochStruct
        urevent{pointer} = ureventTmp;
        pointer = pointer + 1;
        ureventTmp = [];
        ureventTmp = [ureventTmp, ureventStruct];
    else
        % has epoch exist
        ureventTmp = [ureventTmp, ureventStruct];
    end
        
end
urevent{pointer} = ureventTmp;

% filter epochs
prevUR = urevent{1};
prevEpoch = epoch(1);
prevEvent = eventTable(1);
epochIdx = [];
eventIdx = [];
for idx = 2:length(epoch)
    currUR = urevent{idx};
    currEpoch = epoch(idx);
    currEvent = eventTable(idx);
    
    % we always store the epoch that we defined has no overlapping
    % with the prevous epoch
    % if previous event is not a target but current event is a target
    % change the previous event to target, but if previous event is a
    % target, current event is also a target, we need to check if there is
    % overlappinging, if there is overlapping, then we just skip current
    % event and go to look at next event.
%     if currEvent == 2 && prevEvent ~= 2   % if it is a target, then we ignore the previous epoch
%         % if curr is a target, and has intersection with previous one, we
%         % skip the previous one rather than the current one
%         if ~isempty(intersect(prevUR, currUR))  
%             prevUR = currUR;
%             prevEpoch = currEpoch;
%             prevEvent = currEvent;
%             continue;
%         end
%     end

    if currEvent == 2   % if it is a target, then we ignore the previous epoch
        % if curr is a target, and has intersection with previous one, we
        % skip the previous one rather than the current one
        if prevEvent ~= 2
            prevUR = currUR;
            prevEpoch = currEpoch;
            prevEvent = currEvent;
        else
            % if previous is also a 2, check  if the previous 2 is the same
            % 2 of current one, if not, then also add event and set
            % previous epoch again
            if length(intersect(prevUR, currUR)) == length(prevUR)
                % this means it is actually the same event, then we shoud
                % do nothing for this
            else
                % this means it is actually a different epoch
                epochIdx = [epochIdx; prevEpoch];
                eventIdx = [eventIdx; prevEvent];
                prevUR = currUR;
                prevEpoch = currEpoch;
                prevEvent = currEvent;
            end
        end
    else
    
        if ~isempty(intersect(prevUR, currUR)) % if curr epoch has overlap with prev epoch
            %not use current epoch, we just skip it
            continue;
        else
            % current epoch does not have overlap with previous epoch, we
            % first store previous epoch to say this is a target epoch, and
            % then we change previous epoch = current epoch for the next
            % storation
            epochIdx = [epochIdx; prevEpoch];
            eventIdx = [eventIdx; prevEvent];
            prevUR = currUR;
            prevEpoch = currEpoch;
            prevEvent = currEvent;
        end
    
    end
end

end

