function [Cluster_training_A, Cluster_training_B, config_parameters] = ...
    bow_step_5v2(training_data_A, training_data_B, config_parameters)
     
% kmeans clustering. After this process, split
% again the result cluster array into training data. UTSA 2011


%--------------------  K-MEANS CLUSTERING -------------------------------
% Kmeans clustering process
temp = [training_data_A, training_data_B]';
[Cluster_IDT, words_centroids ] = kmeans_new(temp', config_parameters.current_words_number);
words_centroids = words_centroids';
%------------ SPLIT CLUSTER ARRAY INTO TRAINING AND TESTING ----------------     
% After Clustering, Split again A & B sections into training and
% testing data.
    
% Section A
Cluster_training_A = Cluster_IDT(1:end/2)';
       
% Section B
Cluster_training_B = Cluster_IDT((end/2)+1:end)';

% Save the centroids for clustering the testing data later
config_parameters.current_centroids = words_centroids;

% Save dictionary for training data on the selected observation
if config_parameters.crossv_iteration == config_parameters.observation
    config_parameters.words_ctrs = words_centroids;
    config_parameters.dictionary = Cluster_IDT;
end

end
