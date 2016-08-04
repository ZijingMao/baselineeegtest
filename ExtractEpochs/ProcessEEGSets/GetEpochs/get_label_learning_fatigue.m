function [ labels ] = get_label_learning_fatigue(EEG, configs, events)

srate = EEG.srate;
urevent = EEG.urevent;
epoch = EEG.epoch;

epoch_event = events{1};
label_event = events{2};

labels = zeros(length(epoch), 1);

for idx = 1:length(epoch)-1
    curr_epoch = epoch(idx);
    next_epoch = epoch(idx+1);
    
    [ non_zero_event ] = get_event_logic( curr_epoch.eventtype, epoch_event );
    
    event_start_time = non_zero_event(end);
    urevent_start_time = curr_epoch.eventurevent{event_start_time};
    epoch_event_latency = urevent(urevent_start_time).latency;
    % from previous to start
    % it should not be with the same time as start_time
    [ non_zero_event ] = get_event_logic( next_epoch.eventtype, epoch_event );
    event_next_time = non_zero_event(end);
    urevent_next_time = next_epoch.eventurevent{event_next_time};
    
    urevent_range = extractfield(urevent(urevent_start_time:urevent_next_time), 'type');
    
    [ non_zero_event ] = get_event_logic( urevent_range, label_event );
    
    % if there is an label related event
    if ~isempty(non_zero_event)
        label_event_duration_time = non_zero_event(end);
        label_event_latency = urevent(urevent_start_time+label_event_duration_time-1).latency;
        labels(idx) = (label_event_latency - epoch_event_latency)/srate;
    end
end

% define the last epoch event
curr_epoch = epoch(end);

[ non_zero_event ] = get_event_logic( curr_epoch.eventtype, epoch_event );

event_start_time = non_zero_event(end);
urevent_start_time = curr_epoch.eventurevent{event_start_time};
epoch_event_latency = urevent(urevent_start_time).latency;

urevent_range = extractfield(urevent(urevent_start_time:end), 'type');

[ non_zero_event ] = get_event_logic( urevent_range, label_event );

if ~isempty(non_zero_event)
    label_event_duration_time = non_zero_event(1); % the first event that is button press
    label_event_latency = urevent(urevent_start_time+label_event_duration_time-1).latency;
    labels(end) = (label_event_latency - epoch_event_latency)/srate;
end

end