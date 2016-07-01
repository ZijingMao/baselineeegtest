% This script is the first simple implementation of the bag-of-words method
% for classify Mission sections in the patrol data.

clear all
close all
addpath(genpath(pwd));          % Add to the path all subdirectories
clc

% *************************************************************************
%                     CONFIGURATION PARAMETERS

TX_mission = 004;          % Mission to be loaded (3 digits)
TX_subject = 01;           % Patrol data subjec   (2 digits)
rank_n = 20;               % Top discriminat features
model_selection = [2,20]; % Number of words (Cluster ID) for model selection
epochs_per_section = 50;  % Lenght of epoch for training and testind data
crossv_fold = 10;          % Cross-validation fold, 10 as default
%  ************************************************************************


% 1.) LOAD THE EEG DATA

% Load current dataset, as example, the first mision for the first subject
disp('*****************************************');
disp('Reading Dataset: Mission 004, Subject: 01');
disp('*****************************************');
current_dataset = pop_loadset('TX16EEGdata.filt.004.01.4.set');

% Extract info from the de EEGLAB-format loaded dataset
current_signal = current_dataset.data;             % Preprocesed EEG data
[~,events_quantity] = size(current_dataset.event); % # of events
event_location = zeros(2,events_quantity);       % Points and time locs
for i=1:events_quantity                    
    % Get latency in points AND time (minutes)
    % Time = (latency(points) / sampling rate (256) / 60 (minutes)
    event_location(1,i) = current_dataset.event(i).latency;
    event_location(2,i) = ((current_dataset.event(i).latency)/...
        current_dataset.srate)/60;
end

% 2.) GET THE 2 SECTIONS

% Extract some data from the active and non-active group
% Section A from the NON-ACTIVE group = section 1 of the mission
section_A = current_signal(:,event_location(1,1):event_location(1,2));
sA_size = length(section_A);
% Section B from the ACTIVE group = section 4 of the mission
section_B = current_signal(:,event_location(1,4):event_location(1,5));
sB_size = length(section_B);
% make both samples with the same size (lenght for the smallest sample)
if (sA_size > sB_size)
    section_A = section_A(:,1:sB_size);
else
    section_B = section_B(:,1:sA_size);
end

% 3.) APPLY TIME-FREQUENCY ANALYSIS

% Get time-frequency information - Jia's Method
% Set up parameters
parameter.PSD_frequencies_width=[2,30]; 
parameter.PSD_frequencies_no=10; 
parameter.PSD_down_sampling=1; 
parameter.sampling_frequency=256; 
parameter.log_PSD='Y'; 
parameter.PSD_normalization=0; 
parameter.start_time=1; 
parameter.end_time=sB_size;

% Generate Cell for A & B Sections
Y2A = cell(1,2);
Y2A{1} = section_A;
Y2A{2} = section_B;

% Apply function
PSD2A=calculate_PSD(Y2A,parameter);
clc

% 4.) PERFORM TWO SAMPLE T-TEST FOR CHANNEL-FREQUENCY PAIRS

features_A = PSD2A{1};
features_B = PSD2A{2};
[chan,freq,time_p] = size(features_A);
ttest_res = zeros(chan,freq,2);
for i=1:chan
    for j=1:freq
        [h,p,ci,stats] = ttest2(features_A(i,j,:), features_B(i,j,:));
        ttest_res(i,j,1) = p;
        ttest_res(i,j,2) = stats.tstat;
    end
end

% % Plot the results, P-values
% figure, pcolor(ttest_res(:,:,1));
% grid on;
% colormap(summer);
% colorbar
% xlabel('Frequencies','Fontsize',12);
% ylabel('Channels','Fontsize',12);
% title('Discriminant features basen on t-test P-values','Fontsize',12);
% 
% figure, pcolor(ttest_res(:,:,2));
% grid on;
% colormap(summer);
% colorbar
% xlabel('Frequencies','Fontsize',12);
% ylabel('Channels','Fontsize',12);
% title('Discriminant features basen on t-test T-stat value','Fontsize',12);

% 5.) FIND DISCRIMINANT FEATURES (TOP N) AND GET DISCRIMINAT DATA

% Get the Top 20 Most discriminant features, tstat value as reference
ttest_res(:,:,2) = abs(ttest_res(:,:,2));  % sign doesn't matter
features = sort(ttest_res(:,:,2));         % we want the highest values
discriminant_features_values = zeros(1,rank_n);  % Top n high tstat values
discriminant_features_location = zeros(rank_n,2);% Channel and Freq. for values
discriminant_data_A = zeros(rank_n,time_p);      % The features_data only for
discriminant_data_B = zeros(rank_n,time_p);      % the rank discriminant

% Find and save the values and locations (Channel x Frequency) of the top X
% highest tstat values for discriminant features, also Extract the 
% discriminat features data (rank x time_points) matrix
for i=1:rank_n
    % Find the current maximum tstat value
    discriminant_features_values(i) = max(max(features));
    
    % Logical location on the Abs value
    temp =  ttest_res(:,:,2) == discriminant_features_values(i);
    
    % Save the Channel and Frequency containing the highest value
    [discriminant_features_location(i,1),...
        discriminant_features_location(i,2)] = find(temp);
    
    % Extract the feature data relative in the chanm freq location
    discriminant_data_A(i,:) = features_A(...
        discriminant_features_location(i,1),...
        discriminant_features_location(i,2),:);
    
     discriminant_data_B(i,:) = features_B(...
        discriminant_features_location(i,1),...
        discriminant_features_location(i,2),:);
    
    % Erase the current highest value of tstat so the second higher value
    % will be next
    [temp1, temp2] = find((features == (max(max(features)))));
    features(temp1,temp2) = 0;
end

% 6.) CALL BAG-OF-WORDS FUNCTION, WITH X-FOLD CROSS - VALIDATION AND MODEL
% SELECTION

bow_model_results = model_selection(1):model_selection(2);
temp1 = 0;
for i = model_selection(1):model_selection(2)
       
    temp1 = temp1 + 1;
    % Clustering by K-means
    number_of_clusters = i;
    Cluster_IDT = kmeans([discriminant_data_A';discriminant_data_B'],...
        number_of_clusters,'replicates',10,'emptyaction','singleton');
    
    Cluster_IDA = Cluster_IDT(1:end/2)';
    Cluster_IDB = Cluster_IDT(end/2:end)';

    % Clustering by Hierachical Tree
    % step_1 = pdist(discriminant_data_A');
    % step_2 = linkage(step_1);
    % threshold = 1.1;
    % Cluster2_ID = cluster(step_2,'cutoff',threshold);

    % Check for a valid configuration (at least 1 testing epoch)
    if ( (time_p/crossv_fold) > epochs_per_section) 
        [bow_model_results(temp1), crossv_err] = bag_of_words(Cluster_IDA, Cluster_IDB, ...
        number_of_clusters, time_p, crossv_fold, epochs_per_section);
    else
        disp('Error: Invalid configuration of fold cross-validation & epoch size');
    end
    disp(crossv_err);
    fprintf('%d Fold Cross Validation complete for %d words. Error rate: %f',...
        crossv_fold, i,bow_model_results(temp1) );
end

figure, plot((model_selection(1):model_selection(2)),bow_model_results, 'r*-','LineWidth',2);
grid on
xlabel('Number of CLuster IDs (K-means)');
ylabel('Average of error rate after 10-fold cross-validation');

