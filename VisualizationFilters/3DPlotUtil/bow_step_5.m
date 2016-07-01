function [Cluster_training_A, Cluster_training_B, Cluster_testing_A, Cluster_testing_B, config_parameters] = ...
    bow_step_5(training_data_A, training_data_B, testing_data_A, testing_data_B, config_parameters)
     
% This function concatenates the training and testing data for every
% section (A&B) for kmeans clustering. After this process, split
% again the result cluster array into testing and training data. UTSA 2011

%----------------- CONCATENATE TESTING AND TRAINING ---------------------
% Preallocate vector for discriminant data in its original order
complete_discriminant_A = zeros...
    (config_parameters.rank_n,config_parameters.section_size);

complete_discriminant_B = zeros...
    (config_parameters.rank_n,config_parameters.section_size);
        
% Add the testing data to the vector
complete_discriminant_A(:,config_parameters.test_start:config_parameters.test_end) =...
    testing_data_A; 

complete_discriminant_B(:,config_parameters.test_start:config_parameters.test_end) =...
    testing_data_B;
       
% If any, include the begining of the array training data
if (config_parameters.test_start > 1)
    complete_discriminant_A(:,1:config_parameters.test_start-1) = ...
        training_data_A(:,1:config_parameters.test_start-1);
    
    complete_discriminant_B(:,1:config_parameters.test_start-1) = ...
        training_data_B(:,1:config_parameters.test_start-1);
end
       
% If any, include the end of the array training data
if ((config_parameters.section_size - config_parameters.test_end) > 1)
   complete_discriminant_A(:,config_parameters.test_end+1:end) = ...
       training_data_A(:,config_parameters.test_start:end);
   
   complete_discriminant_B(:,config_parameters.test_end+1:end) = ...
       training_data_B(:,config_parameters.test_start:end);
end
        
%--------------------  K-MEANS CLUSTERING -------------------------------
% Kmeans clustering process
[Cluster_IDT, words_centroids] = kmeans([complete_discriminant_A';complete_discriminant_B'],...
config_parameters.current_words_number,'replicates',10,'emptyaction','singleton');



%------------ SPLIT CLUSTER ARRAY INTO TRAINING AND TESTING ----------------     
% After Clustering, Split again A & B sections into training and
% testing data.
    
% Section A
Cluster_temp = Cluster_IDT(1:end/2)';
Cluster_testing_A = Cluster_temp(config_parameters.test_start:config_parameters.test_end);
Cluster_training_A = Cluster_temp;
Cluster_training_A(config_parameters.test_start:config_parameters.test_end) = [];
       
% Section B
Cluster_temp = Cluster_IDT(end/2:end)';
Cluster_testing_B = Cluster_temp(config_parameters.test_start:config_parameters.test_end);
Cluster_training_B = Cluster_temp;
Cluster_training_B(config_parameters.test_start:config_parameters.test_end) = [];


% Save the words distribition for training and testing data on the selected
% observation
if config_parameters.crossv_iteration == config_parameters.observation
    config_parameters.words_ctrs = words_centroids;
    config_parameters.dictionary = Cluster_IDT;
end

end