clear all
close all
clc

figure
marker_type = {'+','o','*','.','x','s','d','^','v','>','<','p','h'};
t = 1:100;
for i=1:length(marker_type)
    plot(t,sin(i*t),marker_type{i}, 'LineWidth',2, 'MarkerEdgeColor','k',...
                'MarkerFaceColor',[rand rand rand], 'MarkerSize',8);
    hold on
end
grid on
hold off
title('Marker for represent additional information on scalp maps (up to 13)', 'fontSize', 15);


            
figure
ni=6;
ni_colors = colormap(cool(ni));
Y = rand(ni);
h = bar('v6',Y);
for i=1:ni
    %use RGB
    set(h(i),'facecolor',[ni_colors(i,1) ni_colors(i,2) ni_colors(i,3)]);
end
grid on
title('4 INDEPENDENT VARIABLES REPRSENTATION');

%%

%++++++++++++++++++++++ SELECTED OBSERVATION RESULTS ++++++++++++++++++++++
% 1.) DISTRIBUTION AND RELEVANCY OF WORDS ON DATA SAMPLES (SECTION A)
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
    
    % Extrac and plot the word relevancy
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
    num2str(conf_struct.TX_mission), ', NON-ACTIVE SECTION (',...
    num2str(conf_struct.sec1(1)), '), A'], 'FontSize', 18);
legend(plot_legend, 'location', 'EastOutside');
%---------------------------------------------------------------------------

%%

% 2.) DISTRIBUTION AND RELEVANCY OF WORDS ON DATA SAMPLES (SECTION B)
close all
size = length(conf_struct.dictionary((end/2) +1:end));
conf_struct.words_disc_powers = conf_struct.words_disc_powers .* -1;
words = zeros(1, size)';
marker_type = {'+','o','x','s','d','^','v','>','<','p','h'};
plot_legend = cell(1, conf_struct.nwords);

figure
pos = 1;
for i=1:conf_struct.nwords
  
    temp = (conf_struct.dictionary((end/2) +1:end) == i)';
    words(temp) = conf_struct.words_disc_powers(i);
    words(~temp) = NaN;
    if (conf_struct.words_disc_powers(i) >0 )
        plot(words, marker_type{pos});
        hold on
        pos = pos +1 ;
    else
        plot(words, 'r.');
        hold on
    end
    
    plot_legend{i} = char(['Word ', num2str(i)]);
    words(1:size) = 0;
end
hold off
grid on
legend(plot_legend);
title(' Words relevancy distribution on ACTIVE Section (B)', 'FontSize', 16);
xlabel(' EEG DAta Samples (time)', 'FontSize', 14);
ylabel('Words Relevancy (for current section)', 'FontSize', 14);
grid on
axis([1 length(words) min(conf_struct.words_disc_powers) max(conf_struct.words_disc_powers)+0.5]);
clc


%%

close all
words = zeros(conf_struct.nwords,length(conf_struct.dictionary(1:end/2)));
for i=1:conf_struct.nwords
    temp = conf_struct.dictionary(1:end/2) == i;
    if (conf_struct.words_disc_powers(i) >0 )
        words(i,temp) = conf_struct.words_disc_powers(i);
    else
        words(i,temp) = 0;
    end
end

% remove bad values
temp = words == 0;
words(temp) = NaN;
colors = colormap(hot(conf_struct.nwords));
plot(words)
h = bar('v6', words);
for i=1: conf_struct.nwords
    set(h(i,:), 'facecolor', [colors(i,1) rand(i,2) rand(i,3)]);
end
title(' Words relevancy distribution on NON_ACTIVE Section (A)', 'FontSize', 16);
xlabel(' EEG DAta Samples (time)', 'FontSize', 14);
ylabel('Words Relevancy (for current section)', 'FontSize', 14);
grid on
axis([1 length(words) 1 max(conf_struct.words_disc_powers)]);
clc
PLOT

%%

% 2.) DISTRIBUTION AND RELEVANCY OF WORDS ON DATA SAMPLES (SECTION A)
close all
%size = length(conf_struct.dictionary((end/2) +1:end));
size = length(conf_struct.dictionary(1:end/2));
%conf_struct.words_disc_powers = conf_struct.words_disc_powers .* -1;
words = zeros(1, size)';
words2 = words;
marker_type = {'r+','ro','rx','rs','rd','r^','rv','r>','r<','rp','rh'};
plot_legend = cell(1, conf_struct.nwords);

figure
pos = 1;
for i=1:conf_struct.nwords
  
    %temp = (conf_struct.dictionary((end/2) +1:end) == i)';
    temp = (conf_struct.dictionary(1:end/2) == i)';   
    words(temp)  = conf_struct.words_disc_powers(i);
    words2(temp) = conf_struct.words_disc_powers(i);
    words(~temp) = NaN;
    if (conf_struct.words_disc_powers(i) >0 )
        plot(words, marker_type{pos}, 'LineWidth', 2);
        hold on
        pos = pos +1 ;
    else
        plot(words, '.');
        hold on
    end
    
    plot_legend{i} = char(['Word ', num2str(i)]);
    words(1:size) = 0;
end

grid on
Z = legend(plot_legend);
set(Z, 'Fontsize', 16);
%title(' Words relevancy (ZOOMED) on ACTIVE Section (4)', 'FontSize', 20);
title(' Words relevancy (ZOOMED) on NON-ACTIVE Section (1)', 'FontSize', 20);
xlabel(' EEG DAta Samples (time)', 'FontSize', 20);
ylabel('Words Relevancy (for current section)', 'FontSize', 20);
grid on
axis([1 length(words) min(conf_struct.words_disc_powers) max(conf_struct.words_disc_powers)+0.5]);

temp = words2 ==0;
words2(temp) = NaN;
plot(words2);
hold off
