function [training_A, testing_A, training_B, testing_B, training_C, testing_C conf_struct] = ...
    bow2_step_4v2(features_trA, features_teA, features_trB, features_teB,...
    features_trC, features_teC, conf_struct)

% This function receives the [Channel - Frequency - Time] training and
% testing data for the A and B sections and perform Two sample T- test to
% find discriminat features between trainig data samples; then rank the top
% n (defined by user) discriminant feaures and extract the time points for
% the discriminat time - frequency pairs. Same combinations are used for 
% extract the time points for the testing data. UTSA, 2011.

% VERSION 2 FOR 3 CLASSES/2012


% Save number of channels and freq. components to the struct (same for all)
nclasses = 3;
[chan, freq, ~] = size(features_trA);
conf_struct.nchannels = chan;
conf_struct.nfeq = freq;
all_ttest = zeros(chan*freq,nclasses);


%-------- PERFORM T-TEST FOR THE 3 COMBINATIONS (1,2; 1,3; 2,3)------------
% Two sample T-test for training data ** MODIFY THIS FOR NEXT VERSION****
ttest_res = zeros(chan,freq,3);  % Z=3 because 3 classes
tmp = 0;
for i=1:chan
    for j=1:freq
        
        
        %/////////////////  CLASS 1 WITH CLASS 2 T-TEST   /////////////////
        tmp = tmp +1;
        [~,~,~,stats] = ttest2(features_trA(i,j,:), features_trB(i,j,:));
        ttest_res(i,j,1) = abs(stats.tstat); % T-value bigger value, more different
        all_ttest(tmp, 1) = ttest_res(i,j,1);
        
        %/////////////////  CLASS 1 WITH CLASS 3 T-TEST   /////////////////
        [~,~,~,stats] = ttest2(features_trA(i,j,:), features_trC(i,j,:));
        ttest_res(i,j,2) = abs(stats.tstat); % T-value bigger value, more different
        all_ttest(tmp, 2) = ttest_res(i,j,2);
        
        %/////////////////  CLASS 2 WITH CLASS 3 T-TEST   /////////////////
        [~,~,~,stats] = ttest2(features_trB(i,j,:), features_trC(i,j,:));
        ttest_res(i,j,3) = abs(stats.tstat); % T-value bigger value, more different
        all_ttest(tmp, 3) = ttest_res(i,j,3);
        
        
    end
end


% -------------------   PRE-ALLOCATE VARIABLES ---------------------------
% Get sizes from original datasets - training
[~,~,length1] = size(features_trA);    % Data points for training 1
[~,~,length2] = size(features_trB);    % Data points for training 1
[~,~,length3] = size(features_trC);    % Data points for training 1

% Pre-allocate discriminant training datasets
training_A = zeros(conf_struct.rank_n, length1);
training_B = zeros(conf_struct.rank_n, length2);
training_C = zeros(conf_struct.rank_n, length3);


% Get sizes from original datasets - testing
[~,~,length1t] = size(features_teA);    % Data points for training 1
[~,~,length2t] = size(features_teB);    % Data points for training 1
[~,~,length3t] = size(features_teC);    % Data points for training 1

% Pre-allocate discriminant training datasets
testing_A = zeros(conf_struct.rank_n, length1t);
testing_B = zeros(conf_struct.rank_n, length2t);
testing_C = zeros(conf_struct.rank_n, length3t);

% Final results, concatenating data from 3 classes
training_all_classes = zeros(conf_struct.rank_n, (length1 + length2 + length3) );
testing_all_classes = zeros(conf_struct.rank_n, (length1t + length2t + length3t) );


%-------  FIND THE CHAN/FREQ LOCATION OF THE DSCRIMINANT FEATURES  --------
% Every one of the features has now 3 associated t-values (because 3
% classes at this time).

% first, extract the biggest value from the 3 t-test value
best_tvalues = (max(all_ttest, [], 2))';
best_tvalues = reshape(best_tvalues, [chan, freq]);
features = best_tvalues;   % Make a copy for be able to delete max values

% Now extract data from all classes at the locations of Top x discriminant
% features
pos = 1;

while pos <= conf_struct.rank_n
    
    % Get the logical location of the current maximum tstat value
    max_pos = ( best_tvalues == (max(max(features))) );
    
    % *** Case 1, there is only 1 maximun tstat value (default)
    if ( (sum(sum(max_pos))) == 1)
           
        % Save the Channel and Frequency containing the highest value
        [conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration)] = find(max_pos);
    
        % Extract the feature data related in the chan freq location
        training_A(pos,:) = features_trA(...
            conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
    
        training_B(pos,:) = features_trB(...
            conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
        
        training_C(pos,:) = features_trC(...
            conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
        
        testing_A(pos,:) = features_teA(...
            conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
        
        testing_B(pos,:) = features_teB(...
            conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
        
        testing_C(pos,:) = features_teC(...
            conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
        
        % Save the concatenated version
        training_all_classes(pos,:) = [training_A(pos,:), training_B(pos,:), training_C(pos,:)];
        testing_all_classes(pos,:) = [testing_A(pos,:), testing_B(pos,:), testing_C(pos,:)];
    
        % Erase the current maximum so the next one will be next
        features(conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
            conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration)) = 0;
        
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
            
            % Extract the feature data relative in the chanm freq location
            training_C(pos,:) = features_trC(conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
                conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
            
            testing_A(pos,:) = features_teA(conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
                conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
    
            testing_B(pos,:) = features_teB(conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
                conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
            
            testing_C(pos,:) = features_teC(conf_struct.discriminant_features_location(pos, 1, conf_struct.crossv_iteration),...
                conf_struct.discriminant_features_location(pos, 2, conf_struct.crossv_iteration),:);
            
            % Save the concatenated version
            training_all_classes(pos,:) = [training_A(pos,:), training_B(pos,:), training_C(pos,:)];
            testing_all_classes(pos,:) = [testing_A(pos,:), testing_B(pos,:), testing_C(pos,:)];
            
            
            % Erase the current highest value of tstat so the second higher value
            % will be next
            features(temp_row(i), temp_column(i)) = 0;
            
            pos = pos +1;
            
        end
        
    end
    
    
end


end


