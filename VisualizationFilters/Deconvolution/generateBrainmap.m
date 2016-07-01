function generateBrainmap(time_var, weights_matrix, pos, handles)
% Create an invisible figure where a brainmap is displayed (using EEGLAB's
% topoplot function) plot is optimized and saved as an image on the
% 'Temp images' folder (existing or a new one) using the input filename

% Declare used variables for topolot
handles.key_values{1} = 'electrodes';
handles.key_values{2} = 'off';
handles.key_values{3} = 'verbose';
handles.key_values{4} = 'off';
handles.key_values{5} = 'chaninfo';
handles.key_values{6} = struct('plotrad', {0.56}, 'shrink', {[]}, 'nosedir', ...
    {'+X'}, 'nodatchans', {[]}, 'icachansind', {[]});

% Create a brainmap (topoplot) using the input data
if handles.visible
    hfig = figure('Visible', 'on');
else
    % hfig = figure('Visible', 'off');
    hfig = handles.child_fig;
end

topoplot(weights_matrix(:, pos), handles.chanlocs, ...
    'maplimits', 'absmax', handles.key_values{:});

% Add title and color information
if handles.setcaxis
    set(hfig, 'Color', [1, 1, 1]);
    caxis([handles.min_val, handles.max_val]);
end

if ~isempty(time_var)
    % title([num2str(time_var, 3), ' Seconds'], 'FontSize', 16, 'Position', [0 -0.65]);
    title([num2str(time_var, 3), ' Seconds'], 'FontSize', 16);
end
%
% set(hfig, 'Color', [0.40, 0.40, 0.40]);
% caxis([handles.min_val, handles.max_val]);
% title([num2str(time_var, 3), ' Seconds'], 'FontSize', 20, 'Color', [1, 1, 1], 'Position', [0 -0.65]);

% Change figure properties (optimize it to be saved as image)
set(gcf, 'PaperPositionMode', 'auto')
set(gcf, 'Colormap', handles.mycmap);
set(gca,'LooseInset',get(gca,'TightInset'))
set(gcf, 'InvertHardCopy', 'off');

if handles.saveFig
    if exist([pwd, '/Temp images'], 'dir') == 0
        mkdir(pwd, '/Temp images');
    end
    % saveas(gcf, [pwd, '/Temp images/', handles.name]);
    print(gcf, [pwd, '/Temp images/', handles.name], '-dpng');
    if handles.visible
        close(hfig);
    end
end

end


