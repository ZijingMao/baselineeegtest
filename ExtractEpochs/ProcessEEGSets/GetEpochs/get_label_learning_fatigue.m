function [ labels ] = get_label_learning_fatigue(EEG, configs, events)

srate = EEG.srate;
urevent = EEG.urevent;
epoch = EEG.epoch;

epoch_event = events{1};
label_event = events{2};

urevent_prev_time = 1;

labels = zeros(length(epoch), 1);

for idx = 1:length(epoch)
    curr_epoch = epoch(idx);
    
    [ mattype1 ] = event_strcmp( curr_epoch.eventtype, epoch_event{1} );
    [ mattype2 ] = event_strcmp( curr_epoch.eventtype, epoch_event{2} );
    
    type_event = mattype1 | mattype2;
    
    non_zero_event = find(type_event);
    
    event_start_time = non_zero_event(end);
    urevent_start_time = curr_epoch.eventurevent{event_start_time};
    epoch_event_latency = urevent(urevent_start_time).latency;
    % from previous to start
    % it should not be with the same time as start_time
    urevent_range = extractfield(urevent(urevent_prev_time:urevent_start_time-1), 'type');
    mattype_logic = zeros(1, length(urevent_range));
    for event_idx = 1:length(label_event)
        [ mattype_tmp ] = event_strcmp( urevent_range, label_event{event_idx} );
        mattype_logic = mattype_logic | mattype_tmp;
    end
    non_zero_event = find(mattype_logic);
    % if there is an label related event
    if ~isempty(non_zero_event)
        label_event_start_time = non_zero_event(end);
        label_event_latency = urevent(urevent_prev_time+label_event_start_time-1).latency;
        labels(idx) = (epoch_event_latency - label_event_latency)/srate;
    end    
    % the previous event is most recent processed event
    urevent_prev_time = urevent_start_time;
end

end