function [training_A, training_B, testing_A, testing_B, conf_struct] = bow_step_3(...
    features_sec_A, features_sec_B, conf_struct, ite)

% This funtion perform the cross-validation extraction of the training and
% testing data from the A & B Chan-Freq-Time sections.

% Get Limits for testing data based on current cross-validation iteration
conf_struct.test_start  = floor( conf_struct.crossv_test_size * (ite-1)) + 1;
conf_struct.test_end = floor( conf_struct.crossv_test_size * ite);
        
% Split data into training and testing sections
% Testing data from section  A
testing_A = features_sec_A(:,:,conf_struct.test_start:conf_struct.test_end);

%Testing data from section  B
testing_B = features_sec_B(:,:,conf_struct.test_start:conf_struct.test_end);  

% Training data from section A
training_A = features_sec_A;
training_A(:,:,conf_struct.test_start:conf_struct.test_end) = [];  

%Training data from section B
training_B = features_sec_B;
training_B(:,:,conf_struct.test_start:conf_struct.test_end) = [];   
 
end