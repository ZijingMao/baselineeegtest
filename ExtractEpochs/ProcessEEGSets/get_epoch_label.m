function [ labels ] = get_epoch_label( EEG, configs, events, coder )

switch coder
    case 'Zijing'
        labels = get_label_learning_fatigue(EEG, configs, events);
    case 'Mehdi'
        labels = get_label_on_task_fatigue(EEG, configs, events);
    case 'Ehren'
        labels = get_label_on_target_nontarget(EEG, configs, events);
    case 'Ali'
        labels = get_label_on_hit_miss(EEG, configs, events);
    otherwise
        error('Not identified coder');
end

end

