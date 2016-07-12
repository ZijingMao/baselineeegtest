
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

%% plot imagesc
p = cell(3, 3);
for i = 1:3
for j = 1:3
h((j-1)*3+i)=subplot(3, 3, (j-1)*3+i);
p{(j-1)*3+i} = get(h((j-1)*3+i), 'pos');
colormap(jet);imagesc(squeeze(input_data(1:64, 1:64, 1, (j-1)*3+i)));caxis([-0.2, 1.2]);
end
end

%%
% [ha, pos] = tight_subplot(1,2,[.01 .01]) ;
load('neg.mat')
idx = [ 1, 3, 4, 6, 7];
c = [];
for i=1:length(idx)
b = padarray(squeeze(input_data(1:64, 1:64, 1, idx(i))), [1, 1], -1);
c = [c; b];
end
createfigure(c, 'neg_input.png');

c = [];
for i=1:length(idx)
b = padarray(squeeze(recon_data(1:64, 1:64, 1, idx(i))), [1, 1], -1);
c = [c; b];
end
createfigure_rec(c, 'neg_recon.png');

%%
% [ha, pos] = tight_subplot(1,2,[.01 .01]) ;
load('pos.mat')
idx = [ 3, 4, 5, 7, 9];
c = [];
for i=1:length(idx)
b = padarray(squeeze(input_data(1:64, 1:64, 1, idx(i))), [1, 1], -1);
c = [c; b];
end
createfigure(c, 'pos_input.png');

c = [];
for i=1:length(idx)
b = padarray(squeeze(recon_data(1:64, 1:64, 1, idx(i))), [1, 1], -1);
c = [c; b];
end
createfigure_rec(c, 'pos_recon.png');

%%
load('neg.mat')
a = squeeze(recon_data(1:64, 1:64, 1, 7));

% load('s01_erp.mat')

handles.visible = false;
handles.setcaxis = true;
handles.chanlocs = chanlocs64;
handles.min_val = -0.5;	% change the min value for the color
handles.max_val = 1.2;	% change the max value for the color
handles.mycmap = set_mycmap();	% Initialize colormap matrix
chanlocs64 = [];
load('C:\Users\EEGLab\Dropbox\UTSA Research\Collaboration\EEGRoomPC\Zijing Mao\baselineeegtest\Source\ChannelSrc\chanlocs_bk.mat', 'chanlocs64')
handles.chanlocs = chanlocs64;
handles.saveFig = false;

currTime = 15;
handles.child_fig = subplot(1, 2, 1);
generateBrainmap(currTime/64, a, currTime, handles);
load('pos.mat')
a = squeeze(recon_data(1:64, 1:64, 1, 9));
handles.child_fig = subplot(1, 2, 2);
generateBrainmap(currTime/64, a, currTime, handles);

currTime = 19;
handles.child_fig = subplot(1, 2, 1);
generateBrainmap(currTime/64, rawnon, currTime, handles);
handles.child_fig = subplot(1, 2, 2);
generateBrainmap(currTime/64, rawtar, currTime, handles);

%%

load('neg.mat')
curr_weights_neg = squeeze(recon_data(1:64, 1:64, 1, 7));

load('pos.mat')
curr_weights_pos = squeeze(recon_data(1:64, 1:64, 1, 9));

vis_multiple_frames_adapt(curr_weights_neg,curr_weights_pos, handles);
