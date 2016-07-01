% This script is the first simple implementation of the bag-of-words method
% for classify Mission sections in the patrol data.

clear all
close all
clc

% *************************************************************************
%             CREATE A STRUCT FOR ALL THE CONFIGURATION PARAMETERS

patrol_bow.TX_mission = 4;            % Mission to be loaded (3 digits)
patrol_bow.TX_subject = 1;            % Patrol data subjec   (2 digits)
patrol_bow.sec1 = [1,2];              % Section for extract inactivity data
patrol_bow.sec2 = [4,5];              % Section for extract activity data
patrol_bow.rank_n = 30;               % Top discriminat features
patrol_bow.model_selection = [2,8];  % Number of words (Cluster IDs) for model selection
patrol_bow.epochs_per_section = 50;   % Lenght of epoch for training and testind data
patrol_bow.crossv_fold = 10;          % Cross-validation fold, 10 as default
%  ************************************************************************

% Load the EEG dataset and extract the Section A and Section B data
[section_A, section_B] = load_patrol_sections(patrol_bow);

% Check for erros in the configuration parameters
[~,sec_size] = size(section_A);
 if ( (sec_size/patrol_bow.crossv_fold) > patrol_bow.epochs_per_section) 
        % Perform a complete bag of words model, with cross-validation and ROC
        patrol_bow = bow_function(section_A, section_B, patrol_bow);
 else
        disp('Error: Invalid configuration of fold cross-validation & epoch size');
 end
 
 
% Plot the error rate - Model selection results
figure, plot((patrol_bow.model_selection(1):patrol_bow.model_selection(2))...
    ,patrol_bow.crossv_error_rates(1,:), 'r*-','LineWidth',2);
grid on
xlabel('Number of CLuster IDs (K-means)');
ylabel('Average of error rate after 10-fold cross-validation');

% Plot all the obtained error rates from all cross-validation without the
% word number information for check anormal values
warning_line(1:length(patrol_bow.all_error_rate)) = 0.45;
figure, plot(patrol_bow.all_error_rate,'*','LineWidth',6);
hold on
plot(warning_line,'r','LineWidth',3);
xlabel('Number of trials');
ylabel('Error rate value');
title(['Wrong or anormal error rate values: ', ...
    num2str(sum(patrol_bow.all_error_rate >0.46)), 'of ',...
    num2str(patrol_bow.nwords*patrol_bow.crossv_fold)]);


  



