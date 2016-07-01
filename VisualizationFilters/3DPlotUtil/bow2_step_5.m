function [Cluster_training_A, Cluster_training_B, Cluster_training_C, config_parameters] = ...
    bow2_step_5(training_data_A, training_data_B, training_data_C, config_parameters)
     
% kmeans clustering. After this process, split
% again the result cluster array into training data. UTSA 2011

% VERSION 2 FOR 3 CLASSES/2012

%--------------------  K-MEANS CLUSTERING -------------------------------
% Kmeans clustering process
temp = [training_data_A, training_data_B, training_data_C]';
[Cluster_IDT, words_centroids ] = kmeans_new(temp', config_parameters.current_words_number);
words_centroids = words_centroids';


%------------ SPLIT CLUSTER ARRAY INTO TRAINING AND TESTING ----------------     
% After Clustering, Split again A, B and C sections 
% Section A
[~, nsamples] = size(training_data_A);
Cluster_training_A = Cluster_IDT(1:nsamples)';
       
% Section B
tmp = Cluster_IDT';
tmp(1:nsamples) = [];
[~, nsamples] = size(training_data_B);
Cluster_training_B = tmp(1:nsamples);

% Section C
tmp(1:nsamples) = [];
Cluster_training_C = tmp;

% Save the centroids for clustering the testing data later
config_parameters.current_centroids = words_centroids;

% Save dictionary for training data on the selected observation
if config_parameters.crossv_iteration == config_parameters.observation
    config_parameters.words_ctrs = words_centroids;
    config_parameters.dictionary = Cluster_IDT;
end

end
