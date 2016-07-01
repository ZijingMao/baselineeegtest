% This program is an implementation of the Bag-of-Words method for 
% classifying between Mission sections in the patrol data. UTSA, 2012

clear all
close all
addpath(genpath(pwd));               % Add to the path all subdirectories
clc

    
%-------------------------   CONFIGURE THE MODEL --------------------------
% *************************************************************************
%             CREATE A STRUCT FOR CONFIGURATION PARAMETERS
bow.data_mission = 4;
bow.data_subject = 1;
bow.number_words = 16;
bow.number_features = 160;
bow.number_classes = 3;
bow.classifier_classes = zeros(1,(bow.number_classes*2));
bow.size_epoch = 50;
%  ************************************************************************


%-------   DEFINE CLASSES LOCATION AND CALL THE MAIN FUNCTION    ----------
% Define classes
bow.classifier_classes = [1 2 4 5 9 10];
bow = new_bow_model(bow);  


%-------------------------   PLOT THE RESULTS   ---------------------------
%bow_plot_results(patrol_bow);

%--------------------   SAVE RESULTS INTO A MAT FILE   --------------------
disp('Process completed!');
save(['new_bow_mission_', num2str(bow.data_mission)]);
