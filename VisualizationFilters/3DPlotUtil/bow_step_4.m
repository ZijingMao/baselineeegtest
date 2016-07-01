function [training_A, training_B, testing_A, testing_B, conf_struct] = ...
    bow_step_4(features_trA, features_trB, features_teA, features_teB, conf_struct)

% This function receives the [Channel - Frequency - Time] training and
% testing data for the A and B sections and perform Two sample T- test to
% find discriminat features between trainig data samples; then rank the top
% n (defined by user) discriminant feaures and extract the time points for
% the discriminat time - frequency pairs. Same combinations are used for 
% extract the time points for the testing data. UTSA, 2011.


%------- Find discrimant features with T-test and rank Top-N (input) ------
% Pre-allocate the result training datasets
[chan,freq,time_p] = size(features_trA);
training_A = zeros(conf_struct.rank_n, time_p);
training_B = zeros(conf_struct.rank_n, time_p);

% Save number of channels and freq. components to the struct
conf_struct.nchannels = chan;
conf_struct.nfeq = freq;

% Two sample T-test for training data
ttest_res = zeros(chan,freq,2);
for i=1:chan
    for j=1:freq
        [~,p,~,stats] = ttest2(features_trA(i,j,:), features_trB(i,j,:));
        ttest_res(i,j,1) = p;           % 0 for different, 1 for equal
        ttest_res(i,j,2) = stats.tstat; % A bigger distance from 0 means more different
    end
end

% Get the Top X  Most discriminant features, tstat value as reference
ttest_res(:,:,2) = abs(ttest_res(:,:,2));                     % sign doesn't matter
features = sort(ttest_res(:,:,2));                            % we want higher values


%---------------  Find and extract discriminat data  ----------------------
% Find and save the values and locations (Channel x Frequency) of the top X
% highest tstat values for discriminant features, also Extract the 
% discriminat features data (number of features x time_points) matrix

% Pre-allocate the result testing datasets
[chan,freq,time_p] = size(features_teA);
testing_A = zeros(conf_struct.rank_n, time_p);
testing_B = zeros(conf_struct.rank_n, time_p);
pos = 1;

while pos <= conf_struct.rank_n
    
    % Get the logical location of the current maximum tstat value
    max_pos = ( ttest_res(:,:,2) == (max(max(features))) );
    
    % *** Case 1, there is only 1 maximun tstat value (default)
    if ( (sum(sum(max_pos))) == 1)
           
        % Save the Channel and Frequency containing the highest value
        [conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration)] = find(max_pos);
    
        % Extract the feature data related in the chanm freq location
        training_A(pos,:) = features_trA(...
            conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
    
        training_B(pos,:) = features_trB(...
            conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
        
        testing_A(pos,:) = features_teA(...
            conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
        
        testing_B(pos,:) = features_teB(...
            conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
    
        pos = pos + 1;
        
    % *** Case 2, Unlikely. There are more of 1 maximun stat values    
    else
        
        temp_ind = find(max_pos);    % Get the numerical indices for positions
        [temp_row, temp_column] = ind2sub([chan, freq],temp_ind);  % convert from ind to row, colum
        
        for i=1:length(temp_row)  % How many maximum numbers there are
            
            % Save the Channel and Frequency containing the highest value
            conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration) = temp_row(i);
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration) = temp_column(i);
            
            % Extract the feature data relative in the chanm freq location
            training_A(pos,:) = features_trA(conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
                conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
    
            training_B(pos,:) = features_trB(conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
                conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
            
            testing_A(pos,:) = features_teA(conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
                conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
    
            testing_B(pos,:) = features_teB(conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
                conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
            
            pos = pos +1;
            
        end
        
    end
    
    % Erase the current highest value of tstat so the second higher value
    % will be next
    [temp1, temp2] = find((features == (max(max(features)))));
    features(temp1,temp2) = 0;
end

end