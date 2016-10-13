function [ train_x_freq ] = get_freq_feature( train_x )
%GET_FREQ_FEATURE Summary of this function goes here

train_x_freq = [];
[~, ~, epoch] = size(train_x);

processed_EEG.trials = 1;
processed_EEG.chanlocs = [];  % select channels loaded from the source location
processed_EEG.xmin = 0;
processed_EEG.xmax = 1000;
processed_EEG.srate = 64;
processed_EEG.pnts = 64;
processed_EEG.icachansind = [];
processed_EEG.nbchan = 30;  % select channels loaded from the source location
processed_EEG.event = [];
processed_EEG.xmax = 1;

for idx = 1:epoch
    a = squeeze(train_x(:, :, idx));
    processed_EEG.data = a;
    % curr_fig = figure;
    [freq_spectra_data, ~, ~, ~] = pop_spectopo(processed_EEG, 1, ...
        [processed_EEG.xmin (processed_EEG.xmax*1000)], ...
        'EEG' , 'freqrange', [0.5, 30], 'electrodes', 'off');
    % close(curr_fig);
    train_x_freq = cat(1, train_x_freq, freq_spectra_data(:, 1:64));      
end

end

