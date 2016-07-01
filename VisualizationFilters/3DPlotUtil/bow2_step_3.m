function [training_A, testing_A, training_B, testing_B, training_C, testing_C, conf_struct]...
    = bow2_step_3(features_sec_A, features_sec_B, features_sec_C, conf_struct, ite)

% This funtion perform the cross-validation extraction of the training and
% testing data from the A & B Chan-Freq-Time sections.

% VERSION 2 FOR 3 CLASSES/2012

%----- ORGANIZE THIS PART LATER FOR THE AUTOMATIC VERSION ------------
% Pre-allocation
nclasses = 3;
conf_struct.test_start = zeros(1, nclasses);
conf_struct.test_end = zeros(1, nclasses);


%////////////////  SPLIT INFORMATION FOR CLASS 1 (SECTION A) //////////////
% Get Limits for testing data based on current cross-validation iteration
conf_struct.test_start(1)  = floor( conf_struct.crossv_test_size(1) * (ite-1)) + 1;
conf_struct.test_end(1) = floor( conf_struct.crossv_test_size(1) * ite);
        
% Split data into training and testing sections
% Testing data from section  A
testing_A = features_sec_A(:,:,conf_struct.test_start(1):conf_struct.test_end(1));


% Training data from section A
training_A = features_sec_A;
training_A(:,:,conf_struct.test_start(1):conf_struct.test_end(1)) = [];  



%////////////////  SPLIT INFORMATION FOR CLASS 2 (SECTION B) //////////////
% Get Limits for testing data based on current cross-validation iteration
conf_struct.test_start(2)  = floor( conf_struct.crossv_test_size(2) * (ite-1)) + 1;
conf_struct.test_end(2) = floor( conf_struct.crossv_test_size(2) * ite);
        
% Split data into training and testing sections
% Testing data from section  A
testing_B = features_sec_B(:,:,conf_struct.test_start(2):conf_struct.test_end(2));


% Training data from section A
training_B = features_sec_B;
training_B(:,:,conf_struct.test_start(2):conf_struct.test_end(2)) = [];  



%////////////////  SPLIT INFORMATION FOR CLASS 3 (SECTION C) //////////////
% Get Limits for testing data based on current cross-validation iteration
conf_struct.test_start(3)  = floor( conf_struct.crossv_test_size(3) * (ite-1)) + 1;
conf_struct.test_end(3) = floor( conf_struct.crossv_test_size(3) * ite);
        
% Split data into training and testing sections
% Testing data from section  A
testing_C = features_sec_C(:,:,conf_struct.test_start(3):conf_struct.test_end(3));


% Training data from section A
training_C = features_sec_C;
training_C(:,:,conf_struct.test_start(3):conf_struct.test_end(3)) = [];  


