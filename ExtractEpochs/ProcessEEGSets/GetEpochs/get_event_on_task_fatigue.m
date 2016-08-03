function [ events, epochRange ] = get_event_on_task_fatigue(configs)

exp_label = configs.exp_names(configs.exp_id).label;
events = exp_label.metric.event;  % this is the indication of learning fatigue event
fprintf(['Event Behavior: ' exp_label.behavior '\n']);
epochRange = exp_label.etime;



end