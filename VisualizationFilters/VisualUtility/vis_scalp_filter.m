function vis_scalp_filter( feat_size )

%% load data
load('ChanMapper.mat');

locChanlocsName = ['Location' num2str(feat_size) 'Chan'];
locChanlocs = eval(locChanlocsName);
meanLocChan = mean(locChanlocs);

idxChanlocsName = ['Idx' num2str(feat_size) 'Chan5Kernel'];
idxChanlocs = eval(idxChanlocsName);
[idxi, idxj] = find(idxChanlocs==0);
for idx = 1:length(idxi)
    idxChanlocs(idxi(idx), idxj(idx)) = idxi(idx);
end

channel_locs_strut_name = ['chanlocs' num2str(feat_size)];
channel_locs_strut = eval(channel_locs_strut_name);

mode = 1;

%% gen the animation
% clc;
% figure_data = figure;
% a = 60;
% for in = 1:size(locChanlocs, 1)
%
%     hold on;
%     for idx = 1:size(locChanlocs, 1)
%         r = 0.5; g = 0.5; b = 0.5;
%         scatter3(locChanlocs(idx, 1), locChanlocs(idx, 2), locChanlocs(idx, 3),...
%             a,'MarkerEdgeColor',[r g b],...
%             'MarkerFaceColor',[r g b],'LineWidth',0.5);
%     end
%     hold on;
%     for indexPointers = kernelSize:-1:1
%         if indexPointers == 1
%             markerE = [1, 0, 0];
%             markerF = [0.8, 0, 0];
%         else
%             markerE = [0, 1, 0];
%             markerF = [0, 0.8, 0];
%         end
%         idxChanKernel = idxChanlocs(in, indexPointers);
%         scatter3(locChanlocs(idxChanKernel, 1), ...
%             locChanlocs(idxChanKernel, 2), ...
%             locChanlocs(idxChanKernel, 3), ...
%             a, 'MarkerEdgeColor', markerE, 'MarkerFaceColor', markerF,...
%             'LineWidth',0.5);
%     end
%     view([locChanlocs(idxChanKernel, 3) locChanlocs(idxChanKernel, 2)]);
%     drawnow;
%     pause(0.2);
%
%     F(in) = getframe(gcf);
%     hold off;
% end
%
% filename = 'ScalpShowSlidingWindow.avi';
% v = VideoWriter(filename,'Uncompressed AVI');
% v.FrameRate = 3;
% open(v);
% writeVideo(v,F);
% close(v);

%% start ploting summary
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
% The University of Texas at San Antonio, 4/2016
% By: Mauricio Merino, Zijing Mao

%% --------------  Part 1:Data initialization and treatment  ---------------
% Load the feature matrix, channels locations struct and head model
FEATURE = idxChanlocs;

% Get the number of channels, frequencies and samples
[number_of_channels, number_of_kernels] = size(FEATURE);

% Calculate color scale (JET) and frequency values
% freq_to_color = colormap(jet(frequencies));              % RGB values for a Blue-to-red scale
% freq_values = exp(linspace(log(2),log(30),frequencies)); % real values
% close
freq_to_color = zeros(number_of_kernels, 3);
freq_to_color(1, 1:3) = [0.9, 0, 0];
for idxKern=2:number_of_kernels
    freq_to_color(idxKern, 1:3) = [0, 0.9, 0];
end

load mhead_hd.mat
% load mheadnew
channel_locs = LAB_electrodes_on_scalp_hd(channel_locs_strut);

cc1 = ones(size(channel_locs, 1),3);
cc1 = cc1.*0;

% plotmesh(TRI1, POS, NORM);
% hold on
% %view([-204 12]);
% scatter3(channel_locs(:,2), channel_locs(:,1), channel_locs(:,3) ,24,cc1,'Linewidth',4);
% zoom(1.5)
%
% % title({'DELTA BAND'; '[2~3.99Hz]'; ['Act:',int2str(act_channel(1)),...
% %     '  Rep:',int2str(rep_channel(1))]},'fontsize',18);
% axis off

%% MATLAB movie initialization                     % Get the screen size
fig1 = figure('Position',[100 100 1280 640]);      % Get the fullscreen size
winsize = get(fig1,'Position');                    % Create a Fullscreen empty window
winsize(1:2) = [0 0];                              % Adjust size to include title, label, etc.
set(fig1,'NextPlot','replacechildren');            % 1 figure for multiple plot
set(fig1,'Color',[1 1 1])                          % Set figure background color to white

epoh_time = ((1:feat_size) - 65)/1;         % Calculate epoch time from number of samples
fps = feat_size/...                          % Frames per Second
    abs(epoh_time(feat_size) - epoh_time(1));
movie_result = moviein(feat_size,1,winsize); % Pre-allocate frames matrix

fig_3d = subplot(6,8,[1:4 9:10 17:20 25:28 33:36]);
set(fig1, 'Renderer', 'OpenGL');
light_handle = light('Parent', fig_3d);
lightangle(light_handle, 45,30);
% lightangle(light_handle, 120,-30);
light_handle = light('Parent', fig_3d);
lightangle(light_handle, 45+120,30);
% lightangle(light_handle, -120,-30);
light_handle = light('Parent', fig_3d);
lightangle(light_handle, 45+240,30);
% lightangle(light_handle, 180,60);
view([0 10]);

%% --------------  Part 2: Identify features, and create movie  ---------------
% Search for features - through the samples
for idxChan=1:number_of_channels            % Time-size loop (lenght of the movie)
    
    % at the begining of the sample, all channels are gray
    channel_colors = ones(number_of_channels,3).*0.4;
    % On the current frame, search for featured channels
    for idxKern=number_of_kernels:-1:1
        
        % Find out if the current channel is feature-activated
        % Calculate the average of the current channel      %(1:frequencies))...
        %         channel_frequency = floor(sum((FEATURE(j,i) == 1).*(freq_values))...
        %             /(sum(FEATURE(j,:,i) == 1)));
        
        % Get the channel's color based in frequency position
        channel_colors(FEATURE(idxChan,idxKern),1) = freq_to_color(idxKern,1);
        channel_colors(FEATURE(idxChan,idxKern),2) = freq_to_color(idxKern,2);
        channel_colors(FEATURE(idxChan,idxKern),3) = freq_to_color(idxKern,3);
    end
    
    fig_3d = subplot(6,8,[1:4 9:10 17:20 25:28 33:36]);
    % Plot current frame, from back
    if mode == 1
        plotmesh(TRI1, POS, NORM, fig_3d); %Head semi-realistic surface
        hold on
    elseif mode == 2
        trisurf(TRI1, POS(:,2), POS(:,1), POS(:,3)); %triangles
        hold on
    elseif mode == 3
        plot3(POS(:,2), POS(:,1), POS(:,3),'black.','Linewidth',0.5); %Points
        hold on
    end
    hold on
    scatter3(fig_3d, channel_locs(:,2), channel_locs(:,1), channel_locs(:,3), ...
        64,channel_colors,'filled');
    title_str = ['3D Mapper: ' num2str(number_of_channels) ' Channel'];
    title(title_str,'fontsize',16);
    x_dir = channel_locs_strut(idxChan).X - meanLocChan(1);
    y_dir = channel_locs_strut(idxChan).Y - meanLocChan(2);
    l_len = sqrt(x_dir^2 + y_dir^2);
    theta = x_dir/l_len + 1i * y_dir/l_len;
    rotation_az = rad2deg(angle(theta));
    view([rotation_az 10]);
    grid on
    
    % Plot current frame, front view
    % view([-227.5 20]);
    %     if mode == 1
    %         plotmesh(TRI1, POS, NORM, fig_2d); %Head semi-realistic surface
    %         hold on
    %     elseif mode == 2
    %         trisurf(TRI1, POS(:,2), POS(:,1), POS(:,3)); %triangles
    %         hold on
    %     elseif mode == 3
    %         plot3(POS(:,2), POS(:,1), POS(:,3),'black.','Linewidth',0.5); %Points
    %         hold on
    %     end
    hold on
    fig_2d = subplot(6,8,[5:8 13:16 21:24 29:32 37:40]);
    scatter(fig_2d, locChanlocs(:,2), -locChanlocs(:,1), ...
        36,channel_colors, 'filled');
    title_str = ['2D Mapper: ' num2str(number_of_channels) ' Channel'];
    title(title_str,'fontsize',16);
    axis off
    % grid on
    % set(get(colorbar,'ylabel'),'string','Frecuency average (HZ)','fontsize',16);
    
    title_str = 'Feat:';
    for idx=1:number_of_kernels
        title_str = [title_str ' ' num2str(FEATURE(idxChan,idx))];
    end
    
    fig_time = subplot(6,8,41:48);
    title_handle = title(title_str,'fontsize',16);
    set(title_handle,'Position',[0.5 0.5 0]);
    axis off
    
    % Add the time bar at the bottom of the frame
    %     subplot(6,8,41:48);
    %     barh(-2,'red');
    %     hold on
    %     barh(3);
    %     hold on
    %     if (i<=65)
    %         barh(epoh_time(i));
    %     else
    %         barh(epoh_time(i),'red');
    %     end
    %     xlabel('Seconds');
    %     title('TIME PROGRESS ALONG SAMPLES','fontsize',16);
    hold off                                      % Now
    movie_result(:,idxChan) = getframe(fig1,winsize);   % Add the last frame to movie matrix
end

% Save the movie matrix into a AVI vide file
movie2avi(movie_result,[num2str(feat_size) '.avi'],'fps',fps);
disp('Done. Go to the current the directory to watch the AVI file');

end

