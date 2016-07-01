function [Cluster_training_A, Cluster_training_B, Cluster_testing_A, Cluster_testing_B] = ...
    bow_kclustering(training_data_A, testing_data_A, training_data_B,...
    testing_data_B, config_parameters)
% This function concatenates the training and testing data for every
% section (A&B) for perform kmeans clustering. After this process, split
% again the result cluster array into testing and training data

%----------------- CONCATENATE TESTING AND TRAINING ---------------------
% Preallocate vector for discriminant data in its original order
complete_discriminant_A = zeros(config_parameters.rank_n,config_parameters.section_size);
complete_discriminant_B = zeros(config_parameters.rank_n,config_parameters.section_size);
        
% Add the testing data to the vector
complete_discriminant_A(:,config_parameters.test_start:config_parameters.test_end) = testing_data_A; 
complete_discriminant_B(:,config_parameters.test_start:config_parameters.test_end) = testing_data_B;
       
% If any, include the begin of the array training data
if (config_parameters.test_start > 1)
    complete_discriminant_A(:,1:config_parameters.test_start-1) = training_data_A(:,1:config_parameters.test_start-1);
    complete_discriminant_B(:,1:config_parameters.test_start-1) = training_data_B(:,1:config_parameters.test_start-1);
end
       
% If any, include the end of the array training data
if ((config_parameters.section_size - config_parameters.test_end) > 1)
   complete_discriminant_A(:,config_parameters.test_end+1:end) = training_data_A(:,config_parameters.test_start:end);
   complete_discriminant_B(:,config_parameters.test_end+1:end) = training_data_B(:,config_parameters.test_start:end);
end
        
%--------------------  K-MEANS CLUSTERING -------------------------------
% Kmeans clustering process
Cluster_IDT = kmeans([complete_discriminant_A';complete_discriminant_B'],...
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



end