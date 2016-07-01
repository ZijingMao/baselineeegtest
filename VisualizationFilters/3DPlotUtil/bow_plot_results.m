function bow_plot_results(conf_struct) 
% This function plots the relevant information as a result of the 
% implementation of a bag-of-words classifier on EEG datasets
% (simulated patrol data by default). General and observation results are
% plotted on different figures, as follows:
%
% GENERAL RESULTS (describes in overall the entire process)
% - Average Classifier's error rate (after X-fold cross-validation) (not
% very useful here, but very important for multi-mission algorithm)
% - All classifier trials with a threshold
% - ROC Curve
%
% OBSERVATION RESULTS (for a selected cross-validation iteration)
% - Distribution and relevancy of words on section A (using bars)
% - Distribution and relevancy of words on section B (using bars)
% - Distribution and relevancy of words on section A (using markers)
% - Distribution and relevancy of words on section B (using markers)
% - Observed Top N discrimininant features
% - Words Centroids
%
% The input is a struct with all the parameters and all the storaged data.
% by: Mauricio Merino, Jia Meng. UTSA, 2012



%++++++++++++++++++++++++++++  GENERAL RESULTS  +++++++++++++++++++++++++++

% 1.) ERROR RATE WITH NUMBER OF WORDS AND FEATURES
% Plot the error rate - Model selection results
figure, plot((conf_struct.model_selection(1):conf_struct.model_selection(2))...
    ,conf_struct.crossv_error_rates(1,:), 'r*-','LineWidth',2);
grid on
xlabel('Number of CLuster IDs (K-means)','Fontsize',16);
ylabel('Average of error rate after 10-fold cross-validation','Fontsize',16);
title('Average classifier error rate of all the cross-validation trials','Fontsize',16);
%---------------------------------------------------------------------------


% 2.) ALL THE CLASSIFIER TRIALS WITH A TRESHOLD (0.35)
% Plot all the obtained error rates from all cross-validation without the
% word number information for check anormal values
threhold_point = 0.25;
warning_line(1:length(conf_struct.all_error_rate)) = threhold_point;
figure, plot(conf_struct.all_error_rate,'*','LineWidth',3);
hold on
plot(warning_line,'r','LineWidth',3);
grid on
xlabel('Number of trials','Fontsize',14);
ylabel('Error rate value','Fontsize',14);
title(['Wrong or anormal error rate values: ', ...
    num2str(sum(conf_struct.all_error_rate >threhold_point)), ' of ',...
    num2str(length(conf_struct.all_error_rate)), '. Threshold: ',...
    num2str(threhold_point)],'Fontsize',13);
%---------------------------------------------------------------------------

% 3.) ROC CURVE OF THE CLASSIFIER
% Extract decision values from the struct
ROC_ratios = conf_struct.test_epoch_prob_values;

% ROC_ratios = [all testing epochs x 4] matrix. Columns were previously
% described. Sec A belongs to section A (1); Sec A belongs to section B (2);
% Sec B belongs to section B (3);  Sec B belongs to section A (4); 

pos_val = 0:length(ROC_ratios):4*length(ROC_ratios);  % an array with lenght of ROC_ratios (1 x N)
 
% Pre-allocate socres and labels for ROC
scores = zeros(1,4*length(ROC_ratios));
labels = scores;   % 1 is the numeric label for section A, 2 for section B

% Assign scores and values:
% Testing A belongs to section A (correct)
scores(1:pos_val(2)) = ROC_ratios(:,1); 
labels(1:pos_val(2)) = 1; 

% Testing A belongs to section B (incorrect)
scores(pos_val(2)+1:pos_val(3)) = ROC_ratios(:,2);
labels(pos_val(2)+1:pos_val(3)) = 2;  

% Testing B belongs to section B (correct)
scores(pos_val(3)+1:pos_val(4)) = ROC_ratios(:,3);
labels(pos_val(3)+1:pos_val(4)) = 1;

% Testing B belongs to section A (incorrect)
scores(pos_val(4)+1:pos_val(5)) = ROC_ratios(:,4);
labels(pos_val(4)+1:pos_val(5)) = 2;

% Generate and graph ROC curve
[X Y, ~, AUC] = perfcurve(labels, scores, 1);
figure, plot(X,Y,'red', 'LineWidth', 3);
legend(['Bag of words (AUC :', num2str(AUC), ')'], 'Location', 'South');
grid on
xlabel('False Positive rate', 'FontSize',15);
ylabel('True postivies rate ', 'FontSize',15);
title(['ROC for Bag of Words Classifier. Mission: ', ...
    num2str(conf_struct.TX_mission), ' Features: ', ...
    num2str(conf_struct.rank_n), ' Words: ', ...
    num2str(conf_struct.current_words_number)], 'FontSize', 13);
hold on
plot([0 1], [0 1], 'magenta');
%---------------------------------------------------------------------------




%++++++++++++++++++++++ SELECTED OBSERVATION RESULTS ++++++++++++++++++++++
% 1.) DISTRIBUTION AND RELEVANCY OF WORDS ON SECTION A (USING BARS)
words_line = zeros(1, length(conf_struct.dictionary(1:end/2)));
words_relevancy = sort(conf_struct.words_disc_powers, 'descend'); % Organize relevancies
temp = words_relevancy > 0;                                       % Positios of A relvancies
words_relevancy_A = words_relevancy(temp);                        % Extract positive values
words_relevancy_B = words_relevancy(~temp);                       % Extract negative values
word_A_color = colormap(summer(length(words_relevancy_A)));       % RGB values for positives
word_B_color = colormap(gray(length(words_relevancy_B)));         % RGB values for negatives
plot_legend = cell(1, conf_struct.nwords);

% plot words location accoridng to relevancy
pos = 0;
figure
for i=1:conf_struct.nwords % Going from higher to lower significancy
    
    % Search and plot current word
    word_rank = sum((1:conf_struct.nwords).*(conf_struct.words_disc_powers == words_relevancy(i)));
    word_pos = (conf_struct.dictionary(1:end/2) == word_rank)';
    
    % Chech if the word exists on section and save legend
    if (sum(word_pos) > 0)
        word_percentage = (sum(word_pos)/conf_struct.section_size)*100;
        plot_legend{i} = char(['Word ', num2str(word_rank), ' (',...
            num2str(word_percentage), ' %)' ]);
        words_line(word_pos) = conf_struct.words_disc_powers(word_rank); 
    else
        plot_legend{i} = char(['Word ', num2str(word_rank), ' (missing)']);
        words_line(:) = NaN;         % Assign void
    end
    
    % Extract and plot the word relevancy
    if ( words_relevancy(i) >= 0)
        plot(words_line, 'Color', [word_A_color(i,1) word_A_color(i,2)...
            word_A_color(i,3)], 'LineWidth', 1);
        hold on
    else
        pos = pos +1;
        plot(words_line, 'Color', [word_B_color(end - (pos - 1),1) word_B_color(end - (pos - 1),2)...
            word_B_color(end - (pos - 1),3)], 'LineWidth', 1);
        hold on
    end
    words_line(:) = 0;
end
axis([0 conf_struct.section_size min(words_relevancy) max(words_relevancy)]);        % Adjust axis
hold off
ylabel(' Words Relevancy', 'FontSize', 16);
xlabel('EEG data sample (time)', 'FontSize', 16);
title(['Words distribution. Mission:  ', ...
    num2str(conf_struct.TX_mission), ', LOW TASK LOAD SECTION (',...
    num2str(conf_struct.sec1(1)), '), A'], 'FontSize', 18);
legend(plot_legend, 'location', 'EastOutside');
%---------------------------------------------------------------------------

% 2.) DISTRIBUTION AND RELEVANCY OF WORDS ON SECTION B (USING BARS)
words_line = zeros(1, length(conf_struct.dictionary((end/2)+1:end)));
words_relevancy = sort((conf_struct.words_disc_powers).*-1, 'descend'); % Organize relevancies
temp = words_relevancy > 0;                                 % Positios of A relvancies
words_relevancy_A = words_relevancy(temp);                  % Extract positive values
words_relevancy_B = words_relevancy(~temp);                 % Extract negative values
word_A_color = colormap(summer(length(words_relevancy_A)));  % RGB values for positives
word_B_color = colormap(gray(length(words_relevancy_B)));   % RGB values for negatives
plot_legend = cell(1, conf_struct.nwords);

% plot words location accoridng to relevancy
pos = 0;
figure
for i=1:conf_struct.nwords % Going from higher to lower significancy
    
    % Search and plot current word
    word_rank = sum((1:conf_struct.nwords).*(conf_struct.words_disc_powers == (words_relevancy(i)*-1)));
    word_pos = (conf_struct.dictionary((end/2)+1:end) == word_rank)';
    
    % Chech if the word exists on section and save legend
    if (sum(word_pos) > 0)
        word_percentage = (sum(word_pos)/conf_struct.section_size)*100;
        plot_legend{i} = char(['Word ', num2str(word_rank), ' (',...
            num2str(word_percentage), ' %)' ]);
        words_line(word_pos) = (conf_struct.words_disc_powers(word_rank)).*-1; 
    else
        plot_legend{i} = char(['Word ', num2str(word_rank), ' (missing)']);
        words_line(:) = NaN;         % Assign void
    end
    
    % Extract and plot the word relevancy
    if ( words_relevancy(i) >= 0)
        plot(words_line, 'Color', [word_A_color(i,1) word_A_color(i,2)...
            word_A_color(i,3)], 'LineWidth', 1);
        hold on
    else
        pos = pos +1;
        plot(words_line, 'Color', [word_B_color(end - (pos - 1),1) word_B_color(end - (pos - 1),2)...
            word_B_color(end - (pos - 1),3)], 'LineWidth', 1);
        hold on
    end
    words_line(:) = 0;
end
axis([0 conf_struct.section_size min(words_relevancy) max(words_relevancy)]);        % Adjust axis
hold off
ylabel(' Words Relevancy', 'FontSize', 16);
xlabel('EEG data sample (time)', 'FontSize', 16);
title(['Words distribution. Mission:  ', ...
    num2str(conf_struct.TX_mission), ', HIGH TASK LOAD SECTION (',...
    num2str(conf_struct.sec2(1)), '), A'], 'FontSize', 18);
legend(plot_legend, 'location', 'EastOutside');
%---------------------------------------------------------------------------

% 3.) DISTRIBUTION AND RELEVANCY OF WORDS ON SECTION A (USING MARKERS)
size = length(conf_struct.dictionary(1:end/2));
words = zeros(1, size);
time_scale = (1:size)./256;
words2 = words;
marker_type = {'r+','ro','rx','rs','rd','r^','rv','r>','r<','rp','rh'};
plot_legend = cell(1, conf_struct.nwords);

figure
pos = 1;
for i=1:conf_struct.nwords
    temp = (conf_struct.dictionary(1:end/2) == i)';
    words(temp)  = conf_struct.words_disc_powers(i);
    words2(temp) = conf_struct.words_disc_powers(i);
    if (conf_struct.words_disc_powers(i) >0 )
        plot(time_scale, words, marker_type{pos}, 'LineWidth', 2);
        hold on
        pos = pos +1 ;
    else
        plot(time_scale, words, '.');
        hold on
    end
    plot_legend{i} = char(['Word ', num2str(i)]);
    words(1:size) = 0;
end
grid on
k = legend(plot_legend);
set(k, 'Fontsize', 17);
title(' Words relevancy and locations on LOW-INTENSE Section (1)', 'FontSize', 17);
xlabel('Time (sec)', 'FontSize', 17);
ylabel('Words Relevancy', 'FontSize', 17);
grid on
axis([1 max(time_scale) min(conf_struct.words_disc_powers) max(conf_struct.words_disc_powers)+0.5]);
temp = words2 ==0;
words2(temp) = NaN;
plot(time_scale,words2);
hold off
%---------------------------------------------------------------------------

% 4.) DISTRIBUTION AND RELEVANCY OF WORDS ON SECTION B (USING MARKERS)
size = length(conf_struct.dictionary((end/2) +1:end));
conf_struct.words_disc_powers = conf_struct.words_disc_powers .* -1;  %INV
words = zeros(1, size);
time_scale = (1:size)./256;
words2 = words;
marker_type = {'r+','ro','rx','rs','rd','r^','rv','r>','r<','rp','rh'};
plot_legend = cell(1, conf_struct.nwords);

figure
pos = 1;
for i=1:conf_struct.nwords
    temp = (conf_struct.dictionary((end/2) +1:end) == i)';
    words(temp)  = conf_struct.words_disc_powers(i);
    words2(temp) = conf_struct.words_disc_powers(i);
    if (conf_struct.words_disc_powers(i) >0 )
        plot(time_scale, words, marker_type{pos}, 'LineWidth', 2);
        hold on
        pos = pos +1 ;
    else
        plot(time_scale, words, '.');
        hold on
    end
    plot_legend{i} = char(['Word ', num2str(i)]);
    words(1:size) = 0;
end
grid on
k = legend(plot_legend);
set(k, 'Fontsize', 17);
title(' Words relevancy and locations on HIGH-INTENSE Section (4)', 'FontSize', 16);
xlabel('Time (sec)', 'FontSize', 17);
ylabel('Words Relevancy', 'FontSize', 17);
grid on
axis([1 max(time_scale) min(conf_struct.words_disc_powers) max(conf_struct.words_disc_powers)+0.5]);
temp = words2 ==0;
words2(temp) = NaN;
plot(time_scale,words2);
hold off
%---------------------------------------------------------------------------

% 5.) OBSERVED TOP N DISCRIMINAT FEATURES
disp_features = zeros(conf_struct.nchannels, conf_struct.nfeq);
figure;
for i=1:conf_struct.rank_n
      
    % Extract dicriminant featrues from the selected observations
    % Most discriminant feature = rank_n value!
    disp_features(conf_struct.discriminant_features_location...
    (i,1,conf_struct.observation), conf_struct.discriminant_features_location...
    (i,2,conf_struct.observation)) = conf_struct.rank_n - (i-1);
end
    
pcolor(disp_features'); grid on
axis([1 conf_struct.nchannels 1 conf_struct.nfeq]);
colormap(cool(conf_struct.rank_n));
colorbar;
caxis([1 conf_struct.rank_n])
xlabel('EEG Channels', 'FontSize', 15);
ylabel('Frequency component', 'FontSize', 15);
title([' Observed discriminant features (', num2str(conf_struct.rank_n), ') ', ...
    'on Interation: ',num2str(conf_struct.observation)], 'FontSize', 15);
%---------------------------------------------------------------------------

% 6.) WORDS CENTROIDS
disp_word_centroids = ...
    zeros(conf_struct.nwords, conf_struct.rank_n);
figure
for i=1:conf_struct.nwords
    
    % Fulfill the centroid values for the selected feature positions
    disp_word_centroids(i,:) = conf_struct.words_ctrs(i,:);
end

% Plot the figure
pcolor(disp_word_centroids); grid on
colormap(hot(conf_struct.rank_n));
colorbar;
caxis([min(min(conf_struct.words_ctrs)) max(max(conf_struct.words_ctrs))]);
xlabel('Discriminat Features (High to Low)', 'FontSize', 15);
ylabel('Word', 'FontSize', 15);
title(' Word Centroids on the observed discriminant features', 'FontSize', 15);
%---------------------------------------------------------------------------
    
end


   