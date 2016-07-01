% TEST FEATURE EXTRACTION

clear all
close all
clc

load temp1

top_discriminant_features = 160;
section_A_3D = section_A_3D(:,:,1:120);
discriminant_class = extract_disc_data(section_A_3D, top_discriminant_features);
disp('finished');

%%

% TEST CLUSTERING

% Now Clustering

clear all
close all
clc

load temp

% my method
tic
[dictionary, winfo] = new_clustering(16, [raw_section_A raw_section_B]);
toc

% compare with K-means
tic
[Cluster_IDT, words_centroids] = kmeans([raw_section_A';raw_section_B'],16,...
'replicates',10,'emptyaction','singleton');
toc

%%

% TEST BAG-OF-WORDS

clear all
close all
clc

% load class data
load disc_example.mat
class_data(1).Data = [disc_testing_A disc_training_A];
class_data(2).Data = [disc_testing_B disc_training_B];
class_data(3).Data = [disc_testing_A disc_training_A];
class_data(4).Data = [disc_testing_B disc_training_B];

% create struct info
bow.number_words = 16;
bow.number_features = 160;
bow.number_classes = 3;
bow.size_epoch = 50;

% test the first alternative
l = bow_alternative_1(bow, class_data);





