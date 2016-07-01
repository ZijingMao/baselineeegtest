function [trai_A, trai_B, test_A, test_B] = LDA_step_1(raw_section_A, raw_section_B, conf_struct, iteration)
% Function for handle the raw EEG data for Patrol Missions and organize
% them into training and testing epochs per channel, all into a 3D matrix
% (Channel x Time x Number of epochs). The the frequency power is
% calculated (abs(fft(array)))
%
% By: Mauricio Merino and Jia Meng, UTSA, 2011


%-------------------  PRE-ALLOCATE RESULTS MATRICES  ----------------------
[chan,~] = size(raw_section_A);
% (Channel x Time x Number of epochs)
test_A = zeros...                        % Testing epocs - section A
    (chan, conf_struct.epochs_per_section, conf_struct.crossv_num_test_epochs);
test_B = zeros...                        % Testing epocs - section B
    (chan, conf_struct.epochs_per_section, conf_struct.crossv_num_test_epochs);
trai_A = zeros...                         % Training epocs - section A
    (chan, conf_struct.epochs_per_section, conf_struct.crossv_num_trai_epochs);
trai_B = zeros...                         % Training epocs - section B
    (chan, conf_struct.epochs_per_section, conf_struct.crossv_num_trai_epochs);


%-------------------   EXTRACT TRAINING AND TESTING DATA   ----------------
% Perform the cross-validation extraction of the training and testing 
% data from the raw A and B EEG segments
% Get Limits for testing data based on current cross-validation iteration
conf_struct.test_start  = floor( conf_struct.crossv_test_size * (iteration-1)) + 1;
conf_struct.test_end = floor( conf_struct.crossv_test_size * iteration);
        
% Split data into training and testing sections
% Testing data from section  A
testing_A = raw_section_A(:,conf_struct.test_start:conf_struct.test_end);
testing_A = testing_A(:,1:...
        (conf_struct.crossv_num_test_epochs*conf_struct.epochs_per_section));

% Testing data from section  B
testing_B = raw_section_B(:,conf_struct.test_start:conf_struct.test_end);
testing_B = testing_B(:,1:...
        (conf_struct.crossv_num_test_epochs*conf_struct.epochs_per_section));

% Training data from section A
training_A = raw_section_A;
training_A(:,conf_struct.test_start:conf_struct.test_end) = [];  
training_A = training_A(:,1:(conf_struct.crossv_num_trai_epochs*conf_struct.epochs_per_section));

% Training data from section B
training_B = raw_section_B;
training_B(:,conf_struct.test_start:conf_struct.test_end) = []; 
training_B = training_B(:,1:(conf_struct.crossv_num_trai_epochs*conf_struct.epochs_per_section));


    % SPLIT DATA INTO EPOCHS THROUGH EVERY CHANNEL - TRAINING SECTIONS   
    for j=1:conf_struct.crossv_num_trai_epochs  % All the epochs loop
        
        % Calculate copying array positions
        pos_a = (conf_struct.epochs_per_section * (j - 1)) + 1;
        pos_b = (conf_struct.epochs_per_section * j);
    
        trai_A(:,:,j) = log(abs(fft(training_A(:,pos_a:pos_b),[],2)));  % Training A data into epochs
        trai_B(:,:,j) = log(abs(fft(training_B(:,pos_a:pos_b),[],2)));  % Training B data into epochs
    end
    
    
    % SPLIT DATA INTO EPOCHS THROUGH EVERY CHANNEL - TESTING SECTIONS   
    for j=1:conf_struct.crossv_num_test_epochs  % All the epochs loop
        
        % Calculate copying array positions
        pos_a = (conf_struct.epochs_per_section * (j - 1)) + 1;
        pos_b = (conf_struct.epochs_per_section * j);
    
        test_A(:,:,j) = log(abs(fft(testing_A(:,pos_a:pos_b),[],2)));  % Training A data into epochs
        test_B(:,:,j) = log(abs(fft(testing_B(:,pos_a:pos_b),[],2)));  % Training B data into epochs
    end

end
    
