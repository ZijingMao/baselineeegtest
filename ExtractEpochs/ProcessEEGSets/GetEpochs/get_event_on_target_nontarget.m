function [ events, epochRange ] = get_event_target_nontarget( configs )

exp_label = configs.exp_names(configs.exp_id).label;
events = exp_label(1).metric.event;  % this is the indication of learning fatigue event
fprintf(['Event Behavior: ' exp_label(1).behavior '\n']);
epochRange = exp_label(1).etime;

end