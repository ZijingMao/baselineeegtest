
cd ..
cd ..
working_path = pwd;
addpath(genpath(pwd));

load('chanlocs_bk.mat', 'chanlocs64');

handles.visible = 'on';
handles.chanlocs = chanlocs64;
handles.min_val = -6;	% change the min value for the color
handles.max_val = 6;	% change the max value for the color
handles.mycmap = set_mycmap();	% Initialize colormap matrix
handles.saveFig = true; % set to false if you don't want to save figure

%% generate animation
% define your current weights here, the weight should be 64 by 64, it can
% be either an epoch data, or an reconstructed epoch data
randomly_selected_features = 9;

curr_weights_raw = rand(64, 64, randomly_selected_features)*2-1;    % change it to your input 
curr_weights_res = rand(64, 64, randomly_selected_features)*2-1;    % change it to your reconstructed input 

% version 2 can fit any epoch size for both two variables
% vis_multiple_frames_v2(curr_weights_raw, curr_weights_res, handles);
vis_multiple_frames(curr_weights_raw, curr_weights_res, handles);
% vis_multiple_frames_adapt(curr_weights_raw, curr_weights_res, handles);

%% curr_weights is your data which is 64 by 64 data
% run this code to have quick test if you want
% handles.visible = true;
% generate_frames(curr_weights, handles);
