function [disc_A, disc_B] = bow_discriminat_features(raw_section_A, raw_section_B, top_features)
% Function for apply time-frequency analysis (based on wavelet transform)
% and rank N (defined by user) discriminant features found by two sample
% T-test. 

% Set up parameters to perfomr Jia's Method 
parameter.PSD_frequencies_width=[2,30]; 
parameter.PSD_frequencies_no=10; 
parameter.PSD_down_sampling=1; 
parameter.sampling_frequency=256; 
parameter.log_PSD='Y'; 
parameter.PSD_normalization=0; 
parameter.start_time=1; 
parameter.end_time=length(raw_section_A(1,:));

%-------------------------------------------------------------
% Time-frequency anaylisis for the A & B raw data sections

% Generate Cell for A & B Sections
Y2A = cell(1,2);
Y2A{1} = raw_section_A;
Y2A{2} = raw_section_B;

% Apply function
PSD2 = calculate_PSD(Y2A,parameter);
    
% Extract the new data (Channel x Frequency x Time) for training
features_A = PSD2{1};
features_B = PSD2{2};
       
%-------------------------------------------------------------
% Find discrimant features with T-test and rank Top-N (input)

% Two sample T-test for training data
[chan,freq,time_p] = size(features_A);
ttest_res = zeros(chan,freq,2);
for i=1:chan
    for j=1:freq
        [~,p,~,stats] = ttest2(features_A(i,j,:), features_B(i,j,:));
        ttest_res(i,j,1) = p;           % 0 for different, 1 for equal
        ttest_res(i,j,2) = stats.tstat; % A bigger distance from 0 means more different
    end
end

% Get the Top X  Most discriminant features, tstat value as reference
ttest_res(:,:,2) = abs(ttest_res(:,:,2));               % sign doesn't matter
features = sort(ttest_res(:,:,2));                      % we want the highest values
discriminant_features_location = zeros(top_features,2); % Channel and Freq. for values
disc_A = zeros(top_features,time_p);             % The features_data only for
disc_B = zeros(top_features,time_p);             % the rank discriminant

% Find and save the values and locations (Channel x Frequency) of the top X
% highest tstat values for discriminant features, also Extract the 
% discriminat features data (rank x time_points) matrix

pos = 1;
while pos <= top_features
    
    % Get the logical location of the current maximum tstat value
    max_pos = ( ttest_res(:,:,2) == (max(max(features))) );
    
    % Case 1, there is only 1 maximun tstat value (default)
    if ( (sum(sum(max_pos))) == 1)
           
        % Save the Channel and Frequency containing the highest value
        [discriminant_features_location(pos,1),...
            discriminant_features_location(pos,2)] = find(max_pos);
    
        % Extract the feature data relative in the chanm freq location
        disc_A(pos,:) = features_A(...
            discriminant_features_location(pos,1),...
            discriminant_features_location(pos,2),:);
    
        disc_B(pos,:) = features_B(...
            discriminant_features_location(pos,1),...
            discriminant_features_location(pos,2),:);
    
        pos = pos + 1;
        
    % Case 2, Unlikely. There are mor of 1 maximun stat values    
    else
        
        temp_ind = find(max_pos);    % Get the numerical indices for positions
        [temp_row, temp_column] = ind2sub([chan, freq],temp_ind);  % convert from ind to row, colum
        
        for i=1:length(temp_row)  % How many maximum numbers there are
            
            % Save the Channel and Frequency containing the highest value
            discriminant_features_location(pos,1) = temp_row(i);
            discriminant_features_location(pos,2) = temp_column(i);
            
            % Extract the feature data relative in the chanm freq location
            disc_A(pos,:) = features_A(discriminant_features_location(pos,1),...
                discriminant_features_location(pos,2),:);
    
            disc_B(pos,:) = features_B(discriminant_features_location(pos,1),...
                discriminant_features_location(pos,2),:);
            pos = pos +1;
        end
        
    end
    
    % Erase the current highest value of tstat so the second higher value
    % will be next
    [temp1, temp2] = find((features == (max(max(features)))));
    features(temp1,temp2) = 0;
end
            
end
    
