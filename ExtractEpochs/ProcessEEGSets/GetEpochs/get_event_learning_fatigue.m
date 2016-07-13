function [ events, epochRange ] = get_event_learning_fatigue( configs )

exp_label = configs.exp_names(configs.exp_id).label;
events = exp_label(3).metric.event;  % this is the indication of learning fatigue event
fprintf(['Event Behavior: ' exp_label(3).behavior '\n']);
epochRange = exp_label(3).etime;

end