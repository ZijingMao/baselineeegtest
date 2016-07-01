function conf_struct = bow_core_one_mission(conf_struct, section_A_3D, section_B_3D)
% bow_function: Complete implementation of a Bag-of-words model. The
% process described in this function starts with the 2 Raw sections of EEG
% data (section A and section B). This function executes in overall 
% the following operations:
% * Split sections in training and testing data according cross-validation
% * Perform Time-frequency analysis using wavelet transform
% * Find discriminant features
% * Rank Top-X (defined by user) discriminant features
% * discretize the data with K-means clustering and special config.
% * Divide sections into epochs, according to the defined length
% * Calculate words probability on the training data (model selection)
% * Get the probabilities for testing data, and estimate a classification
% * Evaluate results and calculate error rate
% * Draw the average ROC Curve
% The function returns complete stats of the model execution into a struct
% Usage: model_stats = bow_function(sectionA, sectionB, conf_struct)
%
% function by: Mauricio Merino and Jia Meng. UTSA, 2011


%-------------  INITIALIZATE VARIABLES AND START LOOPS  ------------------
% Individual corss-validation error rates
error_r = zeros(1,conf_struct.crossv_fold);

% All the probability ratios from cross-validation
ROC_ratios = zeros(2, conf_struct.crossv_num_test_epochs, conf_struct.crossv_fold);
tmp_var = 1;


%**********************  THE MODEL SELECTION CYCLE CYCLE ******************
for model = 1:length(conf_struct.model_selection)
    
    n_words = conf_struct.model_selection(model);
    
    % Display an indicator Message with the partial results
    disp('                                                            ');
    disp('============================================================');
    words_msg = char(['Bag of Words Model for: ', num2str(n_words), ' Words']);
    disp(words_msg);
    words_msg2 = char([num2str(conf_struct.crossv_fold), ...
        ' - Fold Cross-Validation configured.']);
    disp(words_msg2);
       
    %**********************  THE CROSS-VALIDATION CYCLE *******************
    for i=1:conf_struct.crossv_fold
    
        
        %-------- STEP 3: SPLIT SECTIONS IN TRAINING AND TESTING ----------
        % Sizes are the same but data changes in function of the
        % cross-validation current iteration
        [training_A_3D, training_B_3D, testing_A_3D, testing_B_3D, conf_struct] = ...
            bow_step_3(section_A_3D, section_B_3D, conf_struct, i);
        
        
        %-------- STEP 4: SPLIT SECTIONS IN TRAINING AND TESTING ----------
        % Perform Two sample T-test between all the Channel - Frequency
        % combinations on training A and training B data, rank top N
        % discriminant features. Extrac the time points of the discrminant
        % channels - frequency pairs
        [disc_training_A, disc_training_B, disc_testing_A, disc_testing_B] = ...
            bow_step_4(training_A_3D, training_B_3D, testing_A_3D, testing_B_3D, conf_struct);
        
              
        %---------- STEP 5: CONCATENATE ALL DATA FOR CLUSTERING -----------
        % Concatenate all the discriminant data accodingly to the original
        % data points order, once done perfomr K-means clusterint with some
        % options. After clustering is complete, split again the results
        % according the order into training and testing samples
        conf_struct.current_words_number = n_words;
        [Cluster_training_A, Cluster_training_B, Cluster_testing_A, Cluster_testing_B] = ...
            bow_step_5(disc_training_A, disc_training_B, disc_testing_A,...
            disc_testing_B, conf_struct);
          
        
        %------------  STEP 6: PERFORM THE BAG OF WORDS MODEL  ------------
        % The bag-of-words model. Calculates the word probabilty on the
        % training sections and uses them to obtaing the testing probabilty
        % values and estimate whether or not testing epochs belongs to
        % section A or B.
        [error_r(i), ROC_ratios(:,:,i)] = bow_step_6(Cluster_training_A,...
            Cluster_testing_A, Cluster_training_B, Cluster_testing_B, conf_struct);
        
        words_msg3 = char(['Iteration ', num2str(i), ' Succesfully Complete. Error rate: ',...
             num2str(error_r(i))]);
        disp(words_msg3);    
        
    end    
    %-------------------  END OF THE CROSS-VALIDATION CYCLE ---------------------
    
    % keep the record for all the error rates
    er_record_start = (conf_struct.crossv_fold*(tmp_var - 1)) + 1;
    er_record_end = (conf_struct.crossv_fold*tmp_var);
    conf_struct.all_error_rate(er_record_start:er_record_end) = error_r;
     
    % Display an indicator Message with the partial results
    erro_msg = char(['Cross-Validation Complete!.  Average error rate is:  ',...
        num2str(mean(error_r))]);
    disp(erro_msg);
    disp('============================================================');
    disp('                                                            ');
    
    % Save every ave. error rate result in the config struct
    conf_struct.model_results(conf_struct.rank_iteration, model) = mean(error_r);
    error_r(1:end) = 0; 
    tmp_var = tmp_var + 1;
    
end  
%--------------------  END OF THE MODEL SELECTION CYCLE CYCLE --------------------

end

