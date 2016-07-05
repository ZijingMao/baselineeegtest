function parse_one_session( filename, expPath, configs, varargin )

badWindow = [];
if nargin > 3
    badWindow = varargin{1};
end

[path, name, ext] = fileparts(filename);
EEG = pop_loadset([name ext], path);
EEG = extract_epoch_by_type(EEG, configs, ...
    'resample', 64, ...
    'rechannel', 64, ...
    'filtering', [0.1, 55], ...
    'rejectepoch', true, ...
    'badwindow', badWindow);

pop_saveset(EEG, 'filename',[name configs.epoch_postfix ext],...
    'filepath',expPath, 'version', '7.3');

end

