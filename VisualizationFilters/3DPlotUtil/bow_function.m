function conf_struct = bow_function(secA, secB, conf_struct)
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


% ------------------   SOME INITIAL VARIABLES ----------------------------
% Sections length
[~,section_size] = size(secA);                        

% Size of the testing data   
crossv_test_size = floor(section_size/conf_struct.crossv_fold); 

% Number of testing epochs 
crossv_num_test_epochs = floor(crossv_test_size/conf_struct.epochs_per_section);            

% Number of training epochs
crossv_num_trai_epochs = floor( (crossv_test_size*(conf_struct.crossv_fold - 1))/...
    conf_struct.epochs_per_section);            

% Individual corss-validation error rates
error_r = zeros(1,conf_struct.crossv_fold);

% All the probability ratios from cross-validation
ROC_ratios = zeros(2, crossv_num_test_epochs, conf_struct.crossv_fold);



% --- INCLUDE IMPORTANT VARIABLES TO THE CONFIG. + RESULTS STRUCT --------- 
conf_struct.section_size = section_size;        
conf_struct.crossv_test_size = crossv_test_size;
conf_struct.crossv_num_test_epochs = crossv_num_test_epochs;
conf_struct.crossv_num_trai_epochs = crossv_num_trai_epochs;
conf_struct.nwords = conf_struct.model_selection(1):conf_struct.model_selection(2);
conf_struct.crossv_error_rates = zeros(2,length(conf_struct.nwords));
conf_struct.all_error_rate = zeros(1,(length(conf_struct.nwords)*conf_struct.crossv_fold));

tmp_var = 1;
%--------------------  THE MODEL SELECTION CYCLE CYCLE -------------------------
for model = conf_struct.model_selection(1):conf_struct.model_selection(2)
        
    % Display an indicator Message with the partial results
    disp('                                                            ');
    disp('============================================================');
    words_msg = char(['Bag of Words Model for: ', num2str(model), ' Words']);
    disp(words_msg);
    words_msg2 = char([num2str(conf_struct.crossv_fold), ...
        ' - Fold Cross-Validation configured.']);
    disp(words_msg2);
       
    %--------------------  THE CROSS-VALIDATION CYCLE -------------------------
    for i=1:conf_struct.crossv_fold
    
        % 1.) ********************************************
        % Step 1: Extract the RAW training and testing data 
    
        % Get Limits for testing data on clusters
        test_start  = floor( crossv_test_size * (i-1)) + 1;
        test_end = floor( crossv_test_size * i);
        
        % Add the testing boundries to the parameters
        conf_struct.test_start = test_start;
        conf_struct.test_end = test_end;
        
        % Split raw sections into training and testing raw sections
        testing_raw_A = secA(:,test_start:test_end);   % Raw Testing data from section  A
        testing_raw_B = secB(:,test_start:test_end);   % Raw Testing data from section  B
        training_raw_A = secA;
        training_raw_A(:,test_start:test_end) = [];    % Raw Training data from section A
        training_raw_B = secB;
        training_raw_B(:,test_start:test_end) = [];    % Raw Training data from section B
    
    
        % 2.) *******************************************************
        % Step 2: Time-Frequency Analysis & rank discriminat features
    
        % For the training segments
        [training_data_A, training_data_B] = bow_discriminat_features(...
            training_raw_A, training_raw_B, conf_struct.rank_n);
    
        % For the testing segments
        [testing_data_A, testing_data_B] = bow_discriminat_features(...
            testing_raw_A, testing_raw_B, conf_struct.rank_n);
    
    
        % 3.) *******************************************************
        % Step 3: Concatenate all sections for K-means Clustering
        conf_struct.current_words_number = model;
        [Cluster_training_A, Cluster_training_B, Cluster_testing_A, Cluster_testing_B] = ...
            bow_kclustering(training_data_A, testing_data_A, ...
            training_data_B, testing_data_B, conf_struct);
        
                             
        % 4.) *******************************************************
        % Step 4: Perform the bag-of-words model
        [error_r(i), ROC_ratios(:,:,i)] = bag_of_words_model(Cluster_training_A,...
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
    conf_struct.crossv_error_rates(1,tmp_var) = mean(error_r);
    conf_struct.crossv_error_rates(2,tmp_var) = model;
    error_r(1:end) = 0; 
    tmp_var = tmp_var + 1;
    
end  
%--------------------  END OF THE MODEL SELECTION CYCLE CYCLE --------------------

end

