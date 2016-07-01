function LAB_show_2Dfeature(logic_features, channel_struct, width, height, mode)

% LAB_show_2Dfeature: 2D visualization and Movie of logical features.
% Visualize logic activation features on a 2D  head reference and save 
% the result into a movie (.avi file) of widht and height dimensions, 
% Fullscreen is recomended.
%
% This function is an EEG Target-event features (channel-frequency-time) 
% visualization to show the result of a previous work of features
% extraction and classification. 2D Head model is just a reference, a 2D
% view of the 3D model from the EEGLAB files (mheadnew.mat)
%
% logic features, is a logical matrix  3D (Ch. Freq. Time) of features.
%
% loc, is a [1 x number_of_channels] struct with the channle's locations
% (X, Y, Z). 
%
% width & height, are the dimension of the visualiation window, as well the
% resolution of the movie file.
%
% mode, is an intenger that indicates how to show the 2D model, 1 for a
% semi-realistic surface, 2, for a basic triangulation and 3, for display
% the points only. Semi-realistic view is achieved modifying the EEGLAB
% plotmesh function (plotmesh.m) by Arnaud Delorme, SCCN/INC/UCSD, 2003
%
% Usage: LAB_show_2Dfeature((logic_features, channel_struct, width, height, mode)
% The movie will be saved in the current directory.
% The University of Texas at San Antonio, 10/2011
% By: Mauricio Merino



% --------------  Part 1:Data initialization and treatment  ---------------
% Load the feature matrix, channels locations struct and head model
POS = zeros(10,10); % Declare it to use its name later (avoid unused error)
load mheadnew
FEATURE = logic_features;
loc = channel_struct;

% Get the number of channels, frequencies and samples
[number_of_channels,frequencies,feature_samples] = size(FEATURE);
channel_locs = zeros(3,number_of_channels);                  % channel locs

% Calculate color scale (Lines) and frequency values
freq_to_color = colormap(lines(5));              % RGB values for a Blue-to-red scale
freq_values = exp(linspace(log(2),log(30),frequencies)); % real values            
close 
freq_per_sample = zeros(1,number_of_channels);

% Load channel locations from struct
for i=1:number_of_channels
    channel_locs(1,i) = loc(1,i).X;
    channel_locs(2,i) = loc(1,i).Y;
    channel_locs(3,i) = loc(1,i).Z;  
end

% Adapt the head xyz points to the channel locations size
% calculate lenght's per dimension
channel_lenght_X = max(channel_locs(1,:)) - min(channel_locs(1,:));
channel_lenght_Y = max(channel_locs(2,:)) - min(channel_locs(2,:));
channel_lenght_Z = max(channel_locs(3,:)) - min(channel_locs(3,:));

% The size for the head model is different, calculate lenghts
head_lenght_X = max(POS(:,2)) - min(POS(:,2));
head_lenght_Y = max(POS(:,1)) - min(POS(:,1));
head_lenght_Z = max(POS(:,3)) - min(POS(:,3));

% How many times Head model size is bigger than channel locations
head_ratio_X = channel_lenght_X/head_lenght_X;
head_ratio_Y = channel_lenght_Y/head_lenght_Y;
head_ratio_Z = channel_lenght_Z/head_lenght_Z;

% Using the rate, approximate head model to channel's location size
POS = POS';
POS(2,:) = POS(2,:).*head_ratio_X;
POS(1,:) = POS(1,:).*head_ratio_Y;
POS(3,:) = POS(3,:).*head_ratio_Z;

% Move each channel to the closest point of the 3D head model
[~,headpnumber] = size(POS);
diff_XYZ = zeros(3,headpnumber);
diff_average = zeros(1,headpnumber);
for i=1:number_of_channels
    
    % Calculate 3D distance from current channel to all head points
    for j=1:headpnumber
        diff_XYZ(1,j) = abs(channel_locs(1,i) - POS(2,j));
        diff_XYZ(2,j) = abs(channel_locs(2,i) - POS(1,j));
        diff_XYZ(3,j) = abs(channel_locs(3,i) - POS(3,j));
        diff_average(j) = (diff_XYZ(1,j) + diff_XYZ(2,j) + diff_XYZ(3,j))/3;
    end
    
    % Get the closest xyz point based on distances and change channel loc
    close_point = sum((1:headpnumber).*(diff_average == min(diff_average)));
    channel_locs(1,i) = POS(2,close_point);
    channel_locs(2,i) = POS(1,close_point);
    channel_locs(3,i) = POS(3,close_point);  
end

% MATLAB movie initialization
fig1 = figure('Position',[1 1 width height]);      % Get the fullscreen size
winsize = get(fig1,'Position');                    % Create a Fullscreen empty window
winsize(1:2) = [0 0];                              % Adjust size to include title, label, etc.
set(fig1,'NextPlot','replacechildren');            % 1 figure for multiple plots
epoh_start = 65;
epoh_time = ((1:feature_samples) - epoh_start)/32;         % Calculate epoch time from number of samples
fps = 4;%feature_samples/...                          % Frames per Second
    abs(epoh_time(feature_samples) - epoh_time(1));
movie_result = moviein(feature_samples,1,winsize); % Pre-allocate frames matrix
set(fig1,'Color',[1 1 1])                          % Set figure background color to white
POS =POS';
% --------------  Part 2: Identify features, and create movie  ---------------
% Search for features - through the samples
for i=1:feature_samples            % Time-size loop (lenght of the movie)
    
    % at the begining of the sample, all channels are gray
    channel_colors = ones(number_of_channels,3).*0.4;  
    % On the current frame, search for featured channels
    for j=1:number_of_channels
        
        % Find out if the current channel is feature-activated 
        if (sum(FEATURE(j,:,i)) >= 1)
    
            % Calculate average of feature activated freq. (current channel)
            channel_frequency = floor(sum((FEATURE(j,:,i) == 1).*(freq_values))...
            /(sum(FEATURE(j,:,i) == 1)));  % Value between 2-30 HZ (average)
            freq_per_sample(j) = channel_frequency;
            
            % Classify the obtained average into 5 regions for freq types:
            % Delta, Theta, Alpha, Beta, Gamma waves.      
            if (channel_frequency<= 3.99)
                channel_frequency = 1;
            end
            if (4<channel_frequency<= 7.99)
                channel_frequency = 2;
            end
            if (8<channel_frequency<= 12.99)
                channel_frequency = 3;
            end
            if (13<channel_frequency<= 30)
                channel_frequency = 4;
            end
            if (channel_frequency> 30)
                channel_frequency = 5;
            end
            channel_colors(j,1) = freq_to_color(channel_frequency,1);
            channel_colors(j,2) = freq_to_color(channel_frequency,2);
            channel_colors(j,3) = freq_to_color(channel_frequency,3);                    
        end        
    end
    
    % Get Channels for highest, lowest and most changed frequency
    chan_maxfsample = sum(freq_per_sample == max(freq_per_sample));
    chan_minfsample = sum(freq_per_sample == min(freq_per_sample));   
    
    % Plot current frame, from back
    subplot(6,5,[1:3 6:8 11:13 16:18 21:23]);
    view([-90.5 90]);  % Sets 2D
    scatter3(channel_locs(1,:), channel_locs(2,:), channel_locs(3,:)...
    ,24,channel_colors,'Linewidth',10);  % The channel locs
    hold on
    view([-90.5 90]);
    if mode == 1
        plotmesh(TRI1, POS, NORM); %Head semi-realistic surface
        hold on
    elseif mode == 2
        trisurf(TRI1, POS(:,2), POS(:,1), POS(:,3)); %triangles
        hold on
    elseif mode == 3
        plot3(POS(:,2), POS(:,1), POS(:,3),'black.','Linewidth',0.5); %Points
        hold on
    end
    axis off
    colorbar('YTickLabel',{' ','Delta',' ','Theta','  ','Alpha',...
        '  ','Beta','  ','Gamma', '  '})
    colormap lines(5)  % The colorbar
    title('FEATURE ACTIVATION','fontsize',14);
    
    % The window for track the current's highest freq
    subplot(6,5,[4:5 9:10 14:15 19:20 24:25]);
    plot(i,chan_maxfsample,'r^');
    hold on
    plot(i,chan_minfsample,'b*');
    grid on
    axis([1 feature_samples 1 number_of_channels]);
    legend('Max','Min');
    title('LOW/HIGH FREQ. CHANNELS PER SAMPLE','fontsize',14);
                 
    % Add the time bar at the bottom of the frame
    subplot(6,5,26:30);
    barh(epoh_time(1),'red');
    hold on
    barh(max(epoh_time));
    hold on
    if (i<=epoh_start) 
        barh(epoh_time(i)); 
    else
        barh(epoh_time(i),'red'); 
    end
    xlabel('Seconds');
    title('TIME PROGRESS ALONG SAMPLES                    ','fontsize',14);
    hold off                                      % Now 
    movie_result(:,i) = getframe(fig1,winsize);   % Add the last frame to movie matrix    
end

disp('finished');
% Save the movie matrix into a AVI vide file
movie2avi(movie_result,'features.avi','fps',fps);
disp('Done. Go to the current the directory to watch the AVI file');

end
