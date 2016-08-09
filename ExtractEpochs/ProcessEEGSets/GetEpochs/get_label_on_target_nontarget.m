function [ labels ] = get_label_on_target_nontarget(EEG, configs, events)

srate = EEG.srate;
urevent = EEG.urevent;
epoch = EEG.epoch;

epoch_event = events{1};
label_event = events{2};

labels = zeros(length(epoch), 1);

lastUrevent = length(urevent);

responseLocked = configs.exp_id == 5 || configs.exp_id == 6;

if responseLocked
    allow_type = epoch_event{1};
    target_type = label_event{1}; 
    
    % define the first epoch separately
    curr_epoch = epoch(1);

    [ non_zero_event ] = get_event_logic( curr_epoch.eventtype, epoch_event );
    
    event_start_time = non_zero_event(end);
    urevent_start_time = curr_epoch.eventurevent{event_start_time};
    %epoch_event_latency = urevent(urevent_start_time).latency;
    
    local_urevent_start_time = max(urevent_start_time - 99, 1);

    local_urevent_latency = extractfield(urevent(local_urevent_start_time:urevent_start_time), 'latency');
    tMinus20_latency = urevent(urevent_start_time).latency - 20.0 * srate ;
    [ltTimeMinus20] = find(local_urevent_latency < tMinus20_latency);
    
    if ~isempty(ltTimeMinus20)
        tMinus20 = ltTimeMinus20(end) + 1;
    else
        tMinus20 = 1;
    end

    tMinus20_urevent_start_time = local_urevent_start_time + (tMinus20 - 1);
    urevent_range = extractfield(urevent(tMinus20_urevent_start_time:urevent_start_time), 'type');


    [ non_zero_event ] = get_event_logic( urevent_range, label_event );
    if ~isempty(non_zero_event)
        label_event_start_time = non_zero_event(end);
        label_urevent = urevent(tMinus20_urevent_start_time + label_event_start_time - 1);
        label_event_type = label_urevent.type;
        %label_event_latency = label_urevent.latency;
        next_urevent_type = urevent(urevent_start_time).type;
        
        %This is included in case you want to add a cutoff time
        %responseTime = (epoch_event_latency - label_event_latency)/srate
        %if (responseTime > 5.0)
        
        if strcmp(next_urevent_type, allow_type) == 1
            if strcmp(label_event_type, target_type) == 1
                labels(1) = 1;
            end
        else
            if strcmp(label_event_type, target_type) == 0
                labels(1) = 2;
            end
        end
        
        %end
    end    
else    
    % define the last epoch separately
    target_type = epoch_event{1};
end

for idx = 1:length(epoch)-1
    curr_epoch = epoch(idx); % <--- stimulus locked
    next_epoch = epoch(idx+1); % <--- response locked    

    if ~responseLocked
        [ non_zero_event ] = get_event_logic( curr_epoch.eventtype, epoch_event );

        event_start_time = non_zero_event(end);
        urevent_start_time = curr_epoch.eventurevent{event_start_time};
        epoch_event_latency = urevent(urevent_start_time).latency;   
        
        isTarget = (strcmp(urevent(urevent_start_time).type, target_type) == 1);        
        
        % Not likely to have more than 100 events in 2 seconds, probably
        % much less
        local_urevent_next_time = min(urevent_start_time + 99, lastUrevent);
        local_urevent_latency = extractfield(urevent(urevent_start_time:local_urevent_next_time), 'latency');
        tPlus2_latency = urevent(urevent_start_time).latency + 2.0 * srate;
        [ltTimePlus2] = find(local_urevent_latency > tPlus2_latency);
        
        if ~isempty(ltTimePlus2)
            tPlus2 = ltTimePlus2(1) + 1;
        else
            tPlus2 = 1;
        end
        
        tPlus2_urevent_next_time = urevent_start_time + (tPlus2 - 1);
        urevent_range = extractfield(urevent(urevent_start_time: tPlus2_urevent_next_time), 'type');
    else
        % from previous to start
        % it should not be with the same time as start_time
        [ non_zero_event ] = get_event_logic( next_epoch.eventtype, epoch_event );
        event_next_time = non_zero_event(end);
        urevent_next_time = next_epoch.eventurevent{event_next_time};

        local_urevent_start_time = max(urevent_next_time - 99, 1);
        local_urevent_latency = extractfield(urevent(local_urevent_start_time:urevent_next_time), 'latency');
        tMinus20_latency = urevent(urevent_next_time).latency - 20.0 * srate;
        [ltTimeMinus20] = find(local_urevent_latency < tMinus20_latency);
        
        if ~isempty(ltTimeMinus20)
            tMinus20 = ltTimeMinus20(end) + 1;
        else
            tMinus20 = 1;
        end
        
        tMinus20_urevent_start_time = local_urevent_start_time + (tMinus20 - 1);
        urevent_range = extractfield(urevent(tMinus20_urevent_start_time:urevent_next_time), 'type');
    end
    

    % if there is a label related event
    if responseLocked            
        [ non_zero_event ] = get_event_logic( urevent_range, label_event );
        if ~isempty(non_zero_event)
            label_event_start_time = non_zero_event(end);
            label_urevent = urevent(tMinus20_urevent_start_time + label_event_start_time - 1);
            label_event_type = label_urevent.type;
            %label_event_latency = label_urevent.latency;
            next_urevent_type = urevent(urevent_next_time).type;
            
            %next_event_latency = next_urevent.latency;            
            
            %This is included in case you want to add a cutoff time
            %responseTime = (next_event_latency - label_event_latency)/srate
            %if (responseTime > 5.0)   
            
            if strcmp(next_urevent_type,allow_type) == 1
                if strcmp(label_event_type,target_type) == 1
                    labels(idx+1) = 1;
                end
            else
                if strcmp(label_event_type,target_type) == 0
                    labels(idx+1) = 2;
                end
            end
            
            %end
        end
    else
        [ non_zero_event ] = get_event_logic( urevent_range, label_event );
        
        if ~isempty(non_zero_event)
            % Button pressed
            label_event_start_time = non_zero_event(1);         
            buttonPressLatency = urevent(urevent_start_time+label_event_start_time - 1).latency;
            response_time = (buttonPressLatency - epoch_event_latency)/srate;   
            
            if isTarget && (response_time < 2.0)                
                labels(idx) = 1;
            elseif ~isTarget && (response_time > 2.0)
                labels(idx) = 2;
            end
        elseif ~isTarget            
            labels(idx) = 2;
        end            
    end
end

if ~responseLocked
    % define the last epoch separately
    curr_epoch = epoch(end);

    [ non_zero_event ] = get_event_logic( curr_epoch.eventtype, epoch_event );

    event_start_time = non_zero_event(end);
    urevent_start_time = curr_epoch.eventurevent{event_start_time};
    epoch_event_latency = urevent(urevent_start_time).latency;

    isTarget = (strcmp(urevent(urevent_start_time).type, target_type) == 1);
    
    % Not likely to have more than 100 events in 2 seconds, probably
    % much less
    local_urevent_latency = extractfield(urevent(urevent_start_time:lastUrevent), 'latency');
    tPlus2_latency = urevent(urevent_start_time).latency + 2.0 * srate;
    [ltTimePlus2] = find(local_urevent_latency > tPlus2_latency);

    if ~isempty(ltTimePlus2)
        tPlus2 = ltTimePlus2(1) + 1;
    else
        tPlus2 = 1;
    end

    tPlus2_urevent_next_time = urevent_start_time + (tPlus2 - 1);
    urevent_range = extractfield(urevent(urevent_start_time: tPlus2_urevent_next_time), 'type');


    [ non_zero_event ] = get_event_logic( urevent_range, label_event );


    if ~isempty(non_zero_event)
        % Button pressed
        label_event_start_time = non_zero_event(1);         
        buttonPressLatency = urevent(urevent_start_time + label_event_start_time - 1).latency;
        response_time = (buttonPressLatency - epoch_event_latency)/srate;   

        if isTarget && (response_time < 2.0)                
            labels(idx) = 1;
        elseif ~isTarget && (response_time > 2.0)
            labels(idx) = 2;
        end
    elseif ~isTarget
        labels(idx) = 2;
    end      
    
end

end