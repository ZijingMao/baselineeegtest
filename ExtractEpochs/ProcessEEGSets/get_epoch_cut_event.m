function [ events, epochRange ] = get_epoch_cut_event( configs, coder )

switch coder
    case 'Zijing'
        [ events, epochRange ] = get_event_learning_fatigue(configs);
    case 'Mehdi'
        [ events, epochRange ] = get_event_on_task_fatigue(configs);
    case 'Ehren'
        [ events, epochRange ] = get_event_on_target_nontarget(configs);
    case 'Ali'
        [ events, epochRange ] = get_event_on_hit_miss(configs);
    otherwise
        error('Not identified coder');
end

assert(~isempty(epochRange), 'Please check your define the epoch time range');
assert(length(epochRange) == 2, 'Please check epoch time range correct');

end

