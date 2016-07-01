% First Look at the patrol data. Huanglab, utsa
% JIA THE EEGLAB AND THE TX16 DATA FOLDERS SHOULD BE INSIDE 
% THE CURRENT DIRECTORY WHEREVER THIS M FILE IS LOCATED

close all
clear all
clc


addpath(genpath(pwd));            % Add to the path all subdirectories
eeglab;                           % Load EEGLAB
close all;
clc

% Load current dataset, as example, the first mision for the first subject
current_dataset = pop_loadset('TX16EEGdata.filt.001.01.1.set');
current_dataset.splinefile = 'TX16EEGdata.filt.001.01.1.spl';
spl = 'TX16EEGdata.filt.001.01.1.spl';

% Get important information about the dataset
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

% Display basic information and plot the dataset
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

% Plot event's location
figure
max_amplitude = max(max(current_signal));
min_amplitude = min(min(current_signal));
amp_scale = min_amplitude:max_amplitude;
[~,number_of_amp] = size(amp_scale);

x_barrier = zeros(events_quantity+1,events_quantity+1);
y_barrier = zeros(events_quantity+1,events_quantity+1);
p_barrier = min_amplitude:(number_of_amp/8):max_amplitude;
p_barrier(events_quantity+1) = max_amplitude;
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


