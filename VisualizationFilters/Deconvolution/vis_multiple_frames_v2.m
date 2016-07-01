function vis_multiple_frames( curr_weights_raw, curr_weights_res, handles )

%% MATLAB movie initialization                     % Get the screen size
fig1 = figure('Position',[100 100 640 1280]);      % Get the fullscreen size
winsize = get(fig1,'Position');                    % Create a Fullscreen empty window
winsize(1:2) = [0 0];                              % Adjust size to include title, label, etc.
set(fig1,'NextPlot','replacechildren');            % 1 figure for multiple plot
set(fig1,'Color',[1 1 1])                          % Set figure background color to white

feat_size = size(curr_weights_raw, 2);
epoh_time = 1:feat_size;         % Calculate epoch time from number of samples
fps = feat_size * 3/...                          % Frames per Second
    abs(epoh_time(feat_size) - epoh_time(1) + 1);
movie_result = moviein(feat_size,1,winsize); % Pre-allocate frames matrix
set(fig1, 'Renderer', 'OpenGL');

handles.visible = false;
handles.setcaxis = true;   % suggest to set true with the correct min and max caxis value

%% --------------  Part 2: Identify features, and create movie  ---------------
% Search for features - through the samples
max_val = max(size(curr_weights_raw, 3), size(curr_weights_res, 3));
max_row_col = ceil(sqrt(max_val));

for id=1:feat_size            % Time-size loop (lenght of the movie)
    %% change the corresponding figure location to the next figure
    % this part is for raw data
    for raw_idx = 1:size(curr_weights_raw, 3)
        fig_3d = subplot(max_row_col*2,max_row_col,raw_idx);

        filename = char(['image_', num2str(id), '.png']);
        handles.name = filename;
        handles.child_fig = fig_3d;
        generateBrainmap(((id-1)/64), curr_weights_raw(:, :, raw_idx), id, handles);    
    end
    
    %% add another axis handle here to generate another one as you want
    % this part is for reconstructed data
    for reconstruct_idx = 1:size(curr_weights_res, 3)
        fig_3d = subplot(max_row_col*2,max_row_col,max_row_col^2+reconstruct_idx);

        filename = char(['image_', num2str(id), '.png']);
        handles.name = filename;
        handles.child_fig = fig_3d;
        generateBrainmap(((id-1)/64), curr_weights_res(:, :, reconstruct_idx), id, handles);    
    end
    
    movie_result(:,id) = getframe(fig1,winsize);   % Add the last frame to movie matrix
    
    clf(fig1);
end

% Save the movie matrix into a AVI vide file
movie2avi(movie_result,[pwd '/Temp images/' num2str(feat_size) '.avi'],'fps',fps);
disp('Done. Go to the current the directory to watch the AVI file');

end

