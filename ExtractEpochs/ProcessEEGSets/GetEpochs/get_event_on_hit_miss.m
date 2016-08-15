function [ events, epochRange ] = get_event_on_hit_miss( configs )

exp_label = configs.exp_names(configs.exp_id).label;
events = exp_label(2).metric.event;  % this is the indication of learning fatigue event
fprintf(['Event Behavior: ' exp_label(2).behavior '\n']);
epochRange = exp_label(2).etime;

end