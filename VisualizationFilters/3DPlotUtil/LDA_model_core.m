function conf_struct = LDA_model_core(conf_struct)
% LDA_model_core: Complete implementation of LDA using MATLAB functions.
% The process described in this function starts with the 2 Raw sections of 
% EEG data (section A and section B). This function executes in overall 
% the following operations:
% * Split sections in training and testing data according cross-validation
% * Perform Time-frequency analysis using wavelet transform
% * Find discriminant features
% * Rank Top-X (defined by user) discriminant features
% * Organize results and directly classify using MATLAB's classify command
% * (Linear Discriminant Anaylisis)
% * Evaluate results and calculate error rate
% * Draw the average ROC Curve
% The function returns complete stats of the model execution into a struct
% Usage: model_stats = bow_function(sectionA, sectionB, conf_struct)
%
% function by: Mauricio Merino and Jia Meng. UTSA, 2011


% Individual corss-validation error rates
error_r = zeros(1,conf_struct.crossv_fold);        
n_fetures = length(conf_struct.features_range);

% Save model status: error rates x features x Mission
conf_struct.model_mission = zeros(6, n_fetures); 

% Preallocate all the classifier scores to build ROC curve
conf_struct.LDA_total_scores = zeros(2,(conf_struct.number_mission * ...
    sum(conf_struct.features_range)));
conf_struct.score_pos = 1;



% ++++++++++++++++++++++ THE EEG PATROL MISSION LOOP ++++++++++++++++++++++
for z=1:conf_struct.number_mission
    
    disp('+++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    disp(['LDA Model will be tested for Mission: ', num2str(z)]);
    disp('+++++++++++++++++++++++++++++++++++++++++++++++++++++++');
    disp('                                                       ');
    conf_struct.TX_mission = z;
    
    %-------- SETP 0: LOAD AND EXTRACT RAW SECTIONS, PREALLOCATE VAR --------
    % Load the EEG dataset and extract the RAW Section A and Section B data
    % Get the sizes for testing and training data, check for errors in config.
    [raw_section_A, raw_section_B, conf_struct] = bow_step_1(conf_struct);
 

%///////////////////////  THE DISCRMINANT FEATURES CYCLE //////////////////////
for k=1:n_fetures
    
    conf_struct.rank_n = conf_struct.features_range(k);
    disp('-------------------------------------------------------');
    disp(['LDA Model for EEG Patrol. ', ...
        num2str(conf_struct.features_range(k)), ' Discriminant Features']);
    disp('-------------------------------------------------------');
    disp('                                                       ');
    disp('============================================================');

    %**********************  THE CROSS-VALIDATION CYCLE ***********************
    for i=1:conf_struct.crossv_fold
        
        %--- SETP 1: OBTAIN TRAINING AND TESTING EPOCHS, CALCULATE POWERS -----
        [training_epocs_A, training_epocs_B, testing_epocs_A, testing_epocs_B] = ...
            LDA_step_1(raw_section_A, raw_section_B, conf_struct, i);
        disp('Frequency Analysis. Complete!');
        
    
        %------  SETP 2: EXTRACT POWERS FROM DISCRIMINANT CHANNELS  -----------
        [training_disc_A, training_disc_B, testing_disc_A, testing_disc_B] = ...
            LDA_step_2(training_epocs_A, training_epocs_B, testing_epocs_A,...
            testing_epocs_B, conf_struct);
        disp('Discriminant data extracted');
    
        
        %------  SETP 3: CLASSIFY DATA USING LDA (Classify function)  --------
        % create array of true positive values for testing segments
        testing_values = [testing_disc_A,testing_disc_B];
        training_values = [training_disc_A,training_disc_B];
        real_values = zeros(1, length(training_values));
        real_values(1:end/2) = 1;         % Corresponding to the A section
        real_values(end/2:end) = 2;       % Corresponding to the A section
    
        % Implement LDA Classifier
        [classify_predictions, ~, ~, ~, LDA_coef] = ...
            classify(testing_values',training_values', real_values' );
        
        % Save the scores for the current number of features
        conf_struct.LDA_total_scores(1,conf_struct.score_pos:...
            conf_struct.score_pos+conf_struct.features_range(k)-1) = LDA_coef(1,2).linear;
        conf_struct.LDA_total_scores(2,conf_struct.score_pos:...
            conf_struct.score_pos+conf_struct.features_range(k)-1) = LDA_coef(2,1).linear;
        conf_struct.score_pos = (conf_struct.score_pos+conf_struct.features_range(k));
        
        % Calculate the error rate for the current prediction set
        classify_predictions = classify_predictions';
        classify_error = sum(classify_predictions(1:end/2) == 2);
        classify_error = classify_error + sum((classify_predictions(end/2:end) == 1));
        classify_error = classify_error/length(classify_predictions);
        error_r(i) = classify_error;
    
        % After an iteration is completed, notify user
        words_msg3 = char(['Iteration ', num2str(i), ...
            ' Succesfully Complete. Error rate: ',num2str(error_r(i))]);
        disp(words_msg3);                  
    end
    %**************************************************************************

    % Display an indicator Message with the partial results
    erro_msg = char(['Cross-Validation Complete!.  Average error rate is:  ',...
        num2str(mean(error_r))]);
    disp(erro_msg);
    disp('============================================================');
    disp('                                                            ');

    % Save total result for the current features number
    conf_struct.model_mission(z,k)= mean(error_r);    % error rate (current feature)
    
    % Backup workspace variables and command window log
    save('LDA_partial_results.mat');        % Mat file (workspace variables)
    diary on
    diary('LDA_log.txt');                   % txt file (messages con command w.)
    diary off

end
%//////////////////////////////////////////////////////////////////////////////



end


end

