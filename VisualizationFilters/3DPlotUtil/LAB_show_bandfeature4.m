function LAB_show_bandfeature4(logic_values, channel_locs, freqs, width, height)

% LAB_show_bandfeature: shows activation and deactivation features at
% specific channel locations, on the scalp on a 3D semi-realistic model
% reference from the EEGLAB files (mheadnew.mat), and plotted with a
% modified plotmesh EEGLAB function (by Arnaud Delorme, SCCN/INC/UCSD, 2003) 
% and MATLAB's surfl. The function creates a visualization and
% records an .AVI movie on the current directory. 
%
% [Arguments]
% 1 The STSF struct, should contains at least the channel locations struct,
% the frequency values, feature location with the target and non-target 
% description for features:
%
% logic features, is a logical matrix or a struct containing the 
% the logical matrix specifying where the features are (Channel,
% Frequency, Time) and also the target o non-target nature of those
% feautes, as follows: 1 indicates, the feature has high values for target
% events and low values for non-target events; -1 indicates the opposite
% and 0 indicates no feature.
%
% loc, is a [1 x number_of_channels] struct with the channle's locations
% (X, Y, Z). 
%
% 2,3 width & height, are the dimension of the visualiation window, as well the
% resolution of the movie file.
%
% [Usage] 
% LAB_show_bandfeature(STSF_struct, 1280, 720) for save an HD movie
% The movie will be saved in the current directory.
% The University of Texas at San Antonio, 10/2011
% By: Mauricio Merino


% --------------  Part 1:Data initialization and treatment  ---------------
% Load the feature matrix, channels locations struct and head model
POS = zeros(10,10); % Declare it to use its name later (avoid unused error)
load mheadnew

% Get the number of channels, frequencies and samples
[number_of_channels,~,feature_samples] = size(logic_values);

% Get frequency values
freq_values = freqs;         

% Load channel locations from struct, adapt to the 3D scalp
channel_locs = LAB_electrodes_on_scalp(channel_locs);

% Time Epohcs Configuration
epoh_time = 1:feature_samples;     % Calculate epoch time from number of samples
fps = 15;%feature_samples/...                          % Frames per Second
    %abs(epoh_time(feature_samples) - epoh_time(1));

% MATLAB movie initialization                      % Get the screen size
central_figure = figure('Position',[1 1 width height]); % Get the fullscreen size
set(central_figure ,'NextPlot','replacechildren');      % 1 figure for multiple plots
set(central_figure ,'Color',[1 1 1]);                   % Set figure background color to white
set(central_figure , 'visible', 'off');
%EEG_movie = avifile(['features ' char(date) '.avi']);
EEG_movie = VideoWriter(['features ' char(date) '.avi']);
EEG_movie.FrameRate = fps;
%Current_MemUsg = memory;
%PC_mem_limit = 3.839344640000000e+09;



% Preallocate Channel Colors (cc) arrays for the 5 bands
cc1 = ones(number_of_channels,3);
cc2 = ones(number_of_channels,3);
cc3 = ones(number_of_channels,3);
cc4 = ones(number_of_channels,3);
cc5 = ones(number_of_channels,3);

% Find range of frequency values for the 5 brain waves bands
delta = zeros(1,2);
theta = zeros(1,2);  
alpha = zeros(1,2);  
beta = zeros(1,2);  

% logicals for freq. > value, the first 1 is the targe position, to get it,
% calculate the logical array of previous = 0 and then, the zero beforte
% the target 1 is 1, finally, get the position with .* (1:length(freq.))
% and calculate the maximum plus 1
delta(1,1) = max( ((freq_values>1.99) == 0) .* (1:length(freq_values))) + 1;
delta(1,2) = max( ((freq_values>3.8) == 0) .* (1:length(freq_values)));
theta(1,1) = max( ((freq_values>3.99) == 0) .* (1:length(freq_values))) + 1;
theta(1,2) = max( ((freq_values>7.8) == 0) .* (1:length(freq_values)));
alpha(1,1) = max( ((freq_values>7.99) == 0) .* (1:length(freq_values))) + 1;
alpha(1,2) = max( ((freq_values>12.8) == 0) .* (1:length(freq_values)));
beta(1,1) = max( ((freq_values>12.99) == 0) .* (1:length(freq_values))) + 1;
beta(1,2) = max( ((freq_values>29.8) == 0) .* (1:length(freq_values)));
act_channel = zeros(1,5);
rep_channel = zeros(1,5);

% --------------  Part 2: Identify features, and create movie  ---------------
open(EEG_movie)
% Search for features - through the samples
for i=1:10%feature_samples % Sample-size loop 
    disp(['Current iteration: ' int2str(i) ' of ' int2str(feature_samples)]);
        
    % at the begining of the sample, all channels are gray (all bands)
    cc1 = cc1.*0;
    cc2 = cc2.*0;  
    cc3 = cc3.*0;  
    cc4 = cc4.*0;  
    cc5 = cc5.*0;  
    
    act_channel(:) = 0;
    rep_channel(:) = 0;
        
    % On the current frame, search for featured channels
    for j=1:number_of_channels
        
               
        % Check for  features in Delta Band (2~3.99 Hz)
        % Active Features
        if ( sum(logic_values(j,delta(1,1):delta(1,2),i) == 1) > 0)
            cc1(j,1) = 1;
            cc1(j,2) = 0;
            cc1(j,3) = 0;
            act_channel(1) = act_channel(1) + 1;
        end
        % Repressive Features
        if ( sum(logic_values(j,delta(1,1):delta(1,2),i) == -1) > 0)
            cc1(j,1) = 0;
            cc1(j,2) = 1;
            cc1(j,3) = 0;
            rep_channel(1) = rep_channel(1) + 1;
        end
                    
        % Check for  features in Theta Band (4~7.99 Hz)
        % Active Features
        if ( sum(logic_values(j,theta(1,1):theta(1,2),i) == 1) > 0)
            cc2(j,1) = 1;
            cc2(j,2) = 0;
            cc2(j,3) = 0;
            act_channel(2) = act_channel(2) + 1;
        end
        % Repressive Features
        if ( sum(logic_values(j,theta(1,1):theta(1,2),i) == -1) > 0)
            cc2(j,1) = 0;
            cc2(j,2) = 1;
            cc2(j,3) = 0;
            rep_channel(2) = rep_channel(2) + 1;
        end
        
        % Check for  features in Alpha Band (8~12.99 Hz)
        % Active Features
        if ( sum(logic_values(j,alpha(1,1):alpha(1,2),i) == 1) > 0)
            cc3(j,1) = 1;
            cc3(j,2) = 0;
            cc3(j,3) = 0;
            act_channel(3) = act_channel(3) + 1;
        end
        % Repressive Features
        if ( sum(logic_values(j,alpha(1,1):alpha(1,2),i) == -1) > 0)
            cc3(j,1) = 0;
            cc3(j,2) = 1;
            cc3(j,3) = 0;
            rep_channel(3) = rep_channel(3) + 1;
        end
        
        % Check for  features in Beta Band (13~30 Hz)
        % Active Features
        if ( sum(logic_values(j,beta(1,1):beta(1,2),i) == 1) > 0)
            cc4(j,1) = 1;
            cc4(j,2) = 0;
            cc4(j,3) = 0;
            act_channel(4) = act_channel(4) + 1;
        end
        % Repressive Features
        if ( sum(logic_values(j,beta(1,1):beta(1,2),i) == -1) > 0)
            cc4(j,1) = 0;
            cc4(j,2) = 1;
            cc4(j,3) = 0;
            rep_channel(4) = rep_channel(4) + 1;
        end
    end      % End of the Chanels loop
    
   %------------------------- plot the figures --------------------
   % Special and invisible subplot for the title and legend
   subplot('Position',[0.3 0.94 0.4 0.0050]);
   plot(1,1,'r');
   hold on
   plot(2,2,'green');
   axis off
   title(['Brain Activity on Target events VS Non-target events ('...
       int2str(number_of_channels) ' Channels)'], 'fontsize',24);
   leg = legend('  Active features','  Repressive features',...
   'Location','SouthOutside','Orientation','horizontal');
   set(leg, 'Fontsize',20);
   
      % Plot the first head, Delta brain waves
   subplot('Position',[0.01 0.25 0.2375 0.50]);
   %view([-204 12]);
   plotmesh(TRI1, POS, NORM);
   hold on
   %view([-204 12]);
   scatter3(channel_locs(:,2), channel_locs(:,1), channel_locs(:,3)...
   ,24,cc1,'Linewidth',4);
   title({'DELTA BAND'; '[2~3.99Hz]'; ['Act:',int2str(act_channel(1)),...
       '  Rep:',int2str(rep_channel(1))]},'fontsize',18);   
   axis off

   % Plot the second head, Theta brain waves
   subplot('Position',[0.2475 0.25 0.2375  0.50]);
   %view([-204 12]);
   plotmesh(TRI1, POS, NORM);
   hold on
   %view([-204 12]);
   scatter3(channel_locs(:,2), channel_locs(:,1), channel_locs(:,3)...
   ,24,cc2,'Linewidth',4);
   title({'THETA BAND'; '[4~7.9Hz]'; ['Act:',int2str(act_channel(2)),...
       '  Rep:',int2str(rep_channel(2))]},'fontsize',18);
   axis off
  
   % Plot the third head, Alpha brain waves
   subplot('Position',[0.4850 0.25 0.2375  0.50]);
   %view([-204 12]);
   plotmesh(TRI1, POS, NORM);
   hold on
   %view([-204 12]);
   scatter3(channel_locs(:,2), channel_locs(:,1), channel_locs(:,3)...
   ,24,cc3,'Linewidth',4); 
   title({'ALPHA BAND'; '[8~12.9Hz]'; ['Act:',int2str(act_channel(3)),...
       '  Rep:',int2str(rep_channel(3))]},'fontsize',18);
   axis off
  
   % Plot the fourth head, Beta brain waves
   subplot('Position',[0.7225 0.25 0.2375 0.50]);
   %view([-204 12]);
   plotmesh(TRI1, POS, NORM);
   hold on
   %view([-204 12]);
   scatter3(channel_locs(:,2), channel_locs(:,1), channel_locs(:,3)...
   ,24,cc4,'Linewidth',4); 
   title({'BETA BAND'; '[13~30Hz]'; ['Act:',int2str(act_channel(4)),...
       '  Rep:',int2str(rep_channel(4))]},'fontsize',18);
   axis off
                
   % Add the time bar at the bottom of the frame
   subplot('Position',[0.1 0.15 0.8 0.040]);
   barh(feature_samples,'white');
   hold on
   barh(epoh_time(i),'black');
   axis([epoh_time(1) floor(max(epoh_time)) 0.6 1 ]);
   title(['PROGRESS ALONG SAMPLES:  ' int2str(i) '/' int2str(feature_samples) ],'fontsize',18);
   set(gca,'fontsize',18);
   hold off   
   
   % At the end of the current plotting, add the frame to the movie object
   % EEG_movie = addframe(EEG_movie, central_figure);
   current_frame = getframe;
   writeVideo(EEG_movie, current_frame);
   
end

% Finish the movie (close)
close(EEG_movie)

%EEG_movie = close(EEG_movie);
%close(central_figure);

disp('finished');
disp('Done. Go to the current the directory to watch the AVI file');

end
