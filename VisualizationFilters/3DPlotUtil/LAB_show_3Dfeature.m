function LAB_show_3Dfeature(logic_features, channel_struct, width, height, mode)

% LAB_show_3Dfeature: 3D visualization and Movie of logical features.
% Visualize logic activation features on two 3D  head perspective
% reference and save the result into a movie (.avi file) of widht and 
% height dimensions, Fullscreen is recomended.
%
% This function is an EEG Target-event features (channel-frequency-time) 
% visualization to show the result of a previous work of features
% extraction and classification. 3D Head model is just a reference, from
% the EEGLAB files (mheadnew.mat)
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
% Usage: LAB_show_3Dfeature((logic_features, channel_struct, width, height, mode)
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

% Calculate color scale (JET) and frequency values
freq_to_color = colormap(jet(frequencies));              % RGB values for a Blue-to-red scale
freq_values = exp(linspace(log(2),log(30),frequencies)); % real values            
close 

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

% MATLAB movie initialization                      % Get the screen size
fig1 = figure('Position',[1 1 width height]);      % Get the fullscreen size
winsize = get(fig1,'Position');                    % Create a Fullscreen empty window
winsize(1:2) = [0 0];                              % Adjust size to include title, label, etc.
set(fig1,'NextPlot','replacechildren');            % 1 figure for multiple plots
epoh_time = ((1:feature_samples) - 65)/32;         % Calculate epoch time from number of samples
fps = feature_samples/...                          % Frames per Second
    abs(epoh_time(feature_samples) - epoh_time(1));
movie_result = moviein(feature_samples,1,winsize); % Pre-allocate frames matrix
set(fig1,'Color',[1 1 1])                          % Set figure background color to white
POS = POS';

% --------------  Part 2: Identify features, and create movie  ---------------
% Search for features - through the samples
for i=1:feature_samples            % Time-size loop (lenght of the movie)
    
    % at the begining of the sample, all channels are gray
    channel_colors = ones(number_of_channels,3).*0.4;  
    % On the current frame, search for featured channels
    for j=1:number_of_channels
   
        % Find out if the current channel is feature-activated 
        if (sum(FEATURE(j,:,i)) >= 1)
                   
            % Calculate the average of the current channel      %(1:frequencies))...
            channel_frequency = floor(sum((FEATURE(j,:,i) == 1).*(freq_values))...
            /(sum(FEATURE(j,:,i) == 1))); 
                  
            % Get the channel's color based in frequency position
            channel_colors(j,1) = freq_to_color(channel_frequency,1);
            channel_colors(j,2) = freq_to_color(channel_frequency,2);
            channel_colors(j,3) = freq_to_color(channel_frequency,3);                    
        end
    end
    
    % Plot current frame, from back
    subplot(6,8,[1:4 9:10 17:20 25:28 33:36]);
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
    hold on
    scatter3(channel_locs(1,:), channel_locs(2,:), channel_locs(3,:)...
    ,24,channel_colors,'Linewidth',8);
    grid on
    title('FEATURE ACTIVATION, BACK','fontsize',16);
        
    % Plot current frame, front view
    subplot(6,8,[5:8 13:16 21:24 29:32 37:40]);
    view([-227.5 20]);
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
    hold on
    view([-227.5 20]);
    scatter3(channel_locs(1,:), channel_locs(2,:), channel_locs(3,:)...
    ,24,channel_colors,'Linewidth',8);
    grid on
    set(get(colorbar,'ylabel'),'string','Frecuency average (HZ)','fontsize',16);
    colormap(winter);
    caxis([min(freq_values) max(freq_values)]);
    title('FEATURE ACTIVATION, FRONT','fontsize',16);

    % Add the time bar at the bottom of the frame
    subplot(6,8,41:48);
    barh(-2,'red');
    hold on
    barh(3);
    hold on
    if (i<=65) 
        barh(epoh_time(i)); 
    else
        barh(epoh_time(i),'red'); 
    end
    xlabel('Seconds');
    title('TIME PROGRESS ALONG SAMPLES','fontsize',16);
    hold off                                      % Now 
    movie_result(:,i) = getframe(fig1,winsize);   % Add the last frame to movie matrix    
end

disp('finished');
% Save the movie matrix into a AVI vide file
movie2avi(movie_result,'features.avi','fps',fps);
disp('Done. Go to the current the directory to watch the AVI file');

end
