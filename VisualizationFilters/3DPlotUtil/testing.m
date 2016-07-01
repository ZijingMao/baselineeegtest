% AMPLITUDE VISUALIZATOR FOR EEG SIGNALS - TX16 EXPERIMENT
% By: Mauricio Merino, 2011

close all
clear all
clc

addpath(genpath(pwd));          % Add to the path all subdirectories
eeglab;                           % Load EEGLAB
close all;
clc

%plotmesh(TRI1, POS, NORM);
% http://www.youtube.com/watch?v=YQtrJs7AneM
% Print a welcome message
disp('****************************************************');
disp(' TX16 Experiment Data Visualiation and Basic Analysis');

% Load current dataset
current_dataset = pop_loadset('TX16EEGdata.filt.001.01.1.set');
current_dataset.splinefile = 'TX16EEGdata.filt.001.01.1.spl';
spl = 'TX16EEGdata.filt.001.01.1.spl';
% res = headplot(spl, current_dataset, 1);

%% Get important information about the dataset
current_signal = current_dataset.data;          % EEG channel-points
number_of_channels = current_dataset.nbchan;    % Number of channels
channel_locs = zeros(3,number_of_channels);     % XYZ Channel locations
[~,events_quantity] = size(current_dataset.event);
event_location = zeros(2,events_quantity+1);      % Points and time locs for events
for i=1:events_quantity
    event_location(1,i) = current_dataset.event(i).latency;
    event_location(2,i) = current_dataset.event(i).latency/...
        current_dataset.srate/current_dataset.nbchan;
end
event_location(1,events_quantity+1) = current_dataset.pnts;
event_location(2,events_quantity+1) = current_dataset.pnts...
    /current_dataset.srate/60;
%% Display basic information and plot the dataset
disp('                                                    ');
disp('----------------------------------');
temp_text1 = char([ 'EEG source: ' current_dataset.setname ]);
disp(temp_text1);           % Type of EEG data (source)
temp_text2 = char([ 'Dataset Filename: ' current_dataset.filename ]);
disp(temp_text2);           % Filename         
temp_text3 = char([ 'Number of Channels : ' int2str(current_dataset.nbchan) ]);
disp(temp_text3);           % Number of Channels
temp_text4 = char([ 'Sampling rate : ' int2str(current_dataset.srate) ]);
disp(temp_text4);           % Number of Channels
disp('Preprocessing Information :');
disp(current_dataset.desc);
eegplot(current_signal);    % Plot all channels with EEGLAB function



%% Plot the channel locations on the 3D model reference

% Prepare amplitude color-scale
max_amplitude = max(max(current_signal));
min_amplitude = min(min(current_signal));
amp_scale = min_amplitude:max_amplitude;
[~,number_of_amp] = size(amp_scale);
amp_colors = colormap(jet(number_of_amp)); % RGB values for every amplitude
channel_colors = zeros(number_of_channels,3);
close all

% Prepare Window
% fig1 = figure('Position',[200 200 1024 768]); % Get the fullscreen size
% winsize = get(fig1,'Position');               % Create a Fullscreen empty window
% winsize(1:2) = [0 0];                         % Adjust size to include title, label, etc.
% set(fig1,'NextPlot','replacechildren');       % 1 figure for multiple plots
% set(fig1,'Color',[1 1 1]);                    % Set figure background color to white

% Prepare the event's thresholds
x_barrier = zeros(events_quantity+1,events_quantity+1);
y_barrier = zeros(events_quantity+1,events_quantity+1);
p_barrier = min_amplitude:(number_of_amp/8):max_amplitude;
p_barrier(events_quantity+1) = max_amplitude;

figure
% Analyse and plot every point for the signal
for i=1:current_dataset.pnts
    
%     channel_colors(:,:) = 0.4;
    % Calculate amplitude significant values and get channel colors
%     for j=1:number_of_channels
%         
%         % 1. Calculate the current value of the signal (j,i)
%         % 2. Find the nearest integer to that value
%         % 3. Find the binary positions where the ingeter
%         temp_position = max((floor(current_signal(j,i)) >= amp_scale)...
%             .*(1:number_of_amp));
%         
%         % Get current channel's colors
%         channel_colors(j,:) = amp_colors(temp_position,:);
%     end
    
    temp_max = max(current_signal(:,i));
    temp_min = min(current_signal(:,1));
    temp_ave = sum(current_signal(:,i))/number_of_channels;
    
%     % Now plot all the information for the current point
%     
%     % Head channels back
%     subplot(8,8,[1:4 9:12 17:20 25:28 33:36]);
%     scatter3(channel_locs(1,:), channel_locs(2,:), channel_locs(3,:)...
%     ,24,channel_colors,'Linewidth',8);
%     grid on
%     hold on
%     plot3(POS(2,:), POS(1,:), POS(3,:),'black.');
%     title('EEG SIGNAL, BACK','fontsize',16);
%             
%     % Head channels, front
%     subplot(8,8,[5:8 13:16 21:24 29:32 37:40]);
%     view([-227.5 20]);
%     scatter3(channel_locs(1,:), channel_locs(2,:), channel_locs(3,:)...
%     ,24,channel_colors,'Linewidth',8);
%     grid on
%     hold on
%     view([-227.5 20]);
%     plot3(POS(2,:), POS(1,:), POS(3,:),'black.');
%     set(get(colorbar,'ylabel'),'string','Amplitude (mV?)','fontsize',16);
%     caxis([min_amplitude max_amplitude]);
%     title('EEG SIGNAL, FRONT','fontsize',16);
% 
%     % Add the time bar at the bottom of the frame
%     subplot(8,8,41:48);
%     barh(1,'red');
%     hold on
%     barh(current_dataset.pnts/256/60);
%     title('TIME PROGRESS (MINUTES)','fontsize',16);
%     hold on  
% 
%     % The 5 sec aomplitude window
%     subplot(8,8,[49:51 57:59]);
%     % plot(current_signal(:,1:150),'blue');
%         
%     % The amplitude-frequency log window
%     subplot(8,8,[52:56 60:64]);
%     plot(temp_max,'b+');
%     hold on
%     plot(temp_ave,'b.');
%     hold on
%     plot(temp_min,'b*');
%     hold on
%     plot(xvisual,yvisual,'red--');
%     mTextBox = uicontrol('style','text');
%     set(mTextBox,'String','Viewing','fontsize',12);
%     grid on
%     hold on


end  
hold off

% Plot the event's window
total_average = zeros(1,current_dataset.pnts);
total_average(1:current_dataset.pnts) = sum(...
    current_signal(:,1:current_dataset.pnts))/current_dataset.nbchan;
for k=1:events_quantity+1
    x_barrier(1:events_quantity+1,k) = event_location(2,k);
    y_barrier(1:events_quantity+1,k) = p_barrier;
    plot(x_barrier(1:events_quantity+1,k),y_barrier(1:events_quantity+1,k),...
        'red','LineWidth',2);
    text('Position',[event_location(2,k)-0.45 max(p_barrier)+10],'String',...
        (['E' int2str(k-1)]));
    hold on
end
plot(((1:current_dataset.pnts)./current_dataset.srate)./60,total_average);
grid on;
hold off

% signals for "low activity"
a1_signal = current_signal(:,1:event_location(1,2));
[~,a1size] = size(a1_signal);
temp = event_location(1,events_quantity);
temp2 = event_location(1,events_quantity+1);

a2_signal = current_signal(:,temp:temp2);
[~,a2size] = size(a2_signal);

% signals for "low activity"
temp = event_location(1,2);
temp2 = event_location(1,2)+a1size;
b1_signal = current_signal(:,temp:temp2);

temp = event_location(1,events_quantity) - a2size;
temp2 = event_location(1,events_quantity);
b2_signal = current_signal(:,temp:temp2);

% get the mean of amplitudes
a1mean = sum(a1_signal(1:current_dataset.nbchan,:))./current_dataset.nbchan;
b1mean = sum(b1_signal(1:current_dataset.nbchan,:))./current_dataset.nbchan;
a2mean = sum(a2_signal(1:current_dataset.nbchan,:))./current_dataset.nbchan;
b2mean = sum(b2_signal(1:current_dataset.nbchan,:))./current_dataset.nbchan;

a1mean2 = zeros(1,a1size);
b1mean2 = zeros(1,a1size);
a2mean2 = zeros(1,a2size);
b2mean2 = zeros(1,a2size);

for m=1:current_dataset.nbchan
    
    a1mean2(m) = sum(a1_signal(m,:))./current_dataset.nbchan;
    b1mean2(m) = sum(b1_signal(m,:))./current_dataset.nbchan;
    a2mean2(m) = sum(a2_signal(m,:))./current_dataset.nbchan;
    b2mean2(m) = sum(b2_signal(m,:))./current_dataset.nbchan;
end

% plot the comparison
figure, subplot(1,2,1)
plot(a1mean);
hold on
plot(b1mean,'red');
hold off

subplot(1,2,2)
plot(a2mean);
hold on
plot(b2mean,'red');
hold off

% plot the comparison
figure, subplot(1,2,1)
hist(a1mean2);
hold on
hist(b1mean2);
hold off

subplot(1,2,2)
hist(a2mean2);
hold on
hist(b2mean2);
hold off


