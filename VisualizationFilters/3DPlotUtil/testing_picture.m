% PATROL DATA

clear all
close all
addpath(genpath(pwd));          % Add to the path all subdirectories
clc

load feature_result
EEG_states = feature.sign;
[~,~,nsamples] = size(EEG_states);
channel_locations = feature.channel;
freq_range = feature.frequency;
width = 1024;
height = 768;
fig1 = figure('Position',[1 1 width height]);
set(fig1, 'visible', 'off');
A = getframe(fig1);
video_struct(nsamples).cdata = A.cdata;
video_struct(nsamples).colormap = A.colormap;
close

% Get frames in figures, save them in the movie struct
for i=1:2000%nsamples
    video_struct(i) = LAB_pictures(EEG_states, channel_locations,...
        freq_range, width, height, i);
    
end

% Save the movie into avi file
AAA = video_struct(1:2000);
movie2avi(AAA, ['PATROL_features ' char(date) '.avi'], 'fps', 1);
%movie2avi(video_struct, ['PATROL_features ' char(date) '.avi'], 'fps', 1);
disp('done');

%%

% RSVP DATA

clear all
close all
addpath(genpath(pwd));          % Add to the path all subdirectories
clc

load RSVP_test
EEG_states = STSF.STSF;
[~,~,nsamples] = size(EEG_states);
channel_locations = STSF.loc;
freq_range = STSF.frequency;
width = 1024;
height = 768;
fig1 = figure('Position',[1 1 width height]);
set(fig1, 'visible', 'off');
A = getframe(fig1);
video_struct(nsamples).cdata = A.cdata;
video_struct(nsamples).colormap = A.colormap;
close

% Get frames in figures, save them in the movie struct
for i=1:nsamples
    video_struct(i) = LAB_pictures2(EEG_states, channel_locations,...
        freq_range, width, height, i);
    
end

% Save the movie into avi file
%AAA = video_struct(1:10);
%movie2avi(AAA, ['RSVP_features ' char(date) '.avi'], 'fps', 1);
movie2avi(video_struct, ['RSVP_features ' char(date) '.avi'], 'fps', 1);
disp('done');