function [training_A, training_B, testing_A, testing_B] = LDA_step_2(...
    features_trA, features_trB, features_teA, features_teB, conf_struct)

% This function receives the Channel - Frequency - Epocs training and
% testing power data for the A and B sections and perform Two sample T-test
% in order to find discriminat features between trainig data samples; 
% then rank the top n (defined by user) discriminant feaures and extrac
% data for the respective Channel - Frequency  discriminant pairs
% Same combinations are used for extract the  data on the testing sectionst
%
% By: Mauricio Merino, Jia meng. UTSA, 2011.


%------- Find discrimant features with T-test and rank Top-N (input) ------

% Pre-allocate the further results
[chan,freq,~] = size(features_trA);
training_A = zeros(conf_struct.rank_n, conf_struct.crossv_num_trai_epochs);
training_B = zeros(conf_struct.rank_n, conf_struct.crossv_num_trai_epochs);
testing_A = zeros(conf_struct.rank_n, conf_struct.crossv_num_test_epochs);
testing_B = zeros(conf_struct.rank_n, conf_struct.crossv_num_test_epochs);

% Two sample T-test for training data
ttest_res = zeros(chan,freq);       % To save tstat in all chan-freq pairs
for i=1:chan
    for j=1:freq
        [~,~,~,stats] = ttest2(features_trA(i,j,:), features_trB(i,j,:));
        ttest_res(i,j) = stats.tstat; % A bigger distance from 0 means more different
        if j >= freq/2
            ttest_res(i,j)=0;
        end
    end
end

% Get the Top X  Most discriminant features, tstat value as reference
ttest_res(:,:) = abs(ttest_res(:,:));                         % Sign doesn't matter
features = sort(ttest_res(:,:));                              % We want the highest values
discriminant_features_location = zeros(conf_struct.rank_n,2); % Channel and Freq. for values


%---------------  Find and extract discriminat data  ----------------------
% Find and save the values and locations (Channel x Frequency) of the top X
% highest tstat values for discriminant features, also Extract the 
% discriminat features data (rank x time_points) matrix

for i=1:conf_struct.rank_n
    
    % Get the logical location of the current maximum tstat value
    max_pos = ( ttest_res(:,:) == (max(max(features))) );
    
    % Save the Channel and Frequency containing the highest value
    [discriminant_features_location(i,1),...
    discriminant_features_location(i,2)] = find(max_pos);
    
    % Extract the feature data related in the chanm freq location
    training_A(i,:) = features_trA(...
    discriminant_features_location(i,1),...
    discriminant_features_location(i,2),:);
    
    training_B(i,:) = features_trB(...
    discriminant_features_location(i,1),...
    discriminant_features_location(i,2),:);
        
    testing_A(i,:) = features_teA(...
    discriminant_features_location(i,1),...
    discriminant_features_location(i,2),:);
        
     testing_B(i,:) = features_teB(...
     discriminant_features_location(i,1),...
     discriminant_features_location(i,2),:);
 
    % Erase the current highest value of tstat so the second higher value
    % will be next
    [temp1, temp2] = find((features == (max(max(features)))));
    features(temp1,temp2) = 0;
   
end
    
end