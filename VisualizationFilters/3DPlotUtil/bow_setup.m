% This script is an implementation of the bag-of-words method for 
% classify Mission sections in the patrol data. UTSA, 2011
% By: Mauricio Merino, Jia Meng.

clear all
close all
clc

%-------------------------   CONFIGURE THE MODEL --------------------------
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


%---------------------   CALL THE MAIN FUNCTION   ----------------------
% Perform a complete bag of words model, with cross-validation and ROC.
% All the important results will be saved on the same struct
patrol_bow = bow_core(patrol_bow);  


%-------------------------   PLOT THE RESULTS   --------------------------
% Plot the error rate - Model selection results
figure, plot((patrol_bow.model_selection(1):patrol_bow.model_selection(2))...
    ,patrol_bow.crossv_error_rates(1,:), 'r*-','LineWidth',2);
grid on
xlabel('Number of CLuster IDs (K-means)','Fontsize',14);
ylabel('Average of error rate after 10-fold cross-validation','Fontsize',14);

% Plot all the obtained error rates from all cross-validation without the
% word number information for check anormal values
warning_line(1:length(patrol_bow.all_error_rate)) = 0.45;
figure, plot(patrol_bow.all_error_rate,'*','LineWidth',6);
hold on
plot(warning_line,'r','LineWidth',3);
xlabel('Number of trials','Fontsize',14);
ylabel('Error rate value','Fontsize',14);
title(['Wrong or anormal error rate values: ', ...
    num2str(sum(patrol_bow.all_error_rate >0.46)), 'of ',...
    num2str(length(patrol_bow.all_error_rate))],'Fontsize',14);
%-------------------------------------------------------------------------