model7 = [0.728887	0.76809	0.765721	0.796404	0.761117
0.6789	0.709372	0.67584	0.73198	0.695426
0.664161	0.652192	0.598417	0.692946	0.670112
0.799502	0.874889	0.885771	0.891235	0.871848
0.644844	0.665457	0.556981	0.686259	0.657874
0.708898	0.720276	0.703901	0.744711	0.71262
0.720874	0.749068	0.735246	0.756781	0.73019
0.593132	0.603143	0.586459	0.608257	0.599775
0.688622	0.764254	0.768823	0.772567	0.741954
0.67429	0.712854	0.684172	0.73188	0.691168
];

model5 = [0.72964474	0.768833132	0.766113227	0.797059478	0.761288187
0.672235	0.698701	0.707459	0.7417	0.70133
0.634314	0.629441	0.610143	0.680006	0.643835
0.788323	0.864621	0.877499	0.883328	0.872299
0.639992	0.665683	0.623824	0.698357	0.641687
0.709581	0.718775	0.711852	0.744718	0.715238
0.718969	0.73237	0.729517	0.754711	0.736746
0.586604	0.601737	0.590108	0.598806	0.592697
0.68898	0.751249	0.764005	0.765303	0.744152
0.669236	0.701067	0.691193	0.721563	0.681823
];

%% freq+r vs raw
mu7 = mean(model7);
diff = mu7(2) - mu7(4);
[h,p]=ttest(model7(:,2), model7(:,4));

%% GSLT vs BLDA
mu7 = mean(model7);
diff = mu7(2) - a2(:,4);
[h,p]=ttest(model7(:,4), a2(:,4));

%% freq+r vs raw
diff = mu7(3) - mu7(5);
[h,p]=ttest(model7(:,3), model7(:,5));  % p= 0.205

%%
diff = mu7(2) - mu7(3);
[h,p]=ttest(model7(:,2), model7(:,3));  % p= 0.043

%% two DL algorithms
m7 = reshape(model7, [10*5, 1]);
m5 = reshape(model5, [10*5, 1]);
b3 = [m5 m7];
[p,tb1]=anova2(b3, 10);

%% plot the second figure
DLPATH = ['C:\Users\EEGLab\Documents\20160527_RSVP_DATASET\Result\X2RSVP\'];
RLTPATH = ['C:\Users\EEGLab\Dropbox\UTSA Research\Collaboration' ...
    '\EEGRoomPC\Reports\CSA_Result'];

folderIdxs = [7];   % model pool

total_sub = 10; % total fold
    
best1_vals_all = zeros(total_sub, 3, 50);

for subID = 1:total_sub
    
    result_folders = {['RSVP_X2_S' num2str(subID, '%02i') '_NORM_CH64'], ...
    ['RSVP_X2_S' num2str(subID, '%02i') '_RAW_CH64'], ...
    ['RSVP_X2_S' num2str(subID, '%02i') '_RAWFREQ_CH64'], ...
    ['RSVP_X2_S' num2str(subID, '%02i') '_NORMFREQ_CH64'], ...
    ['RSVP_X2_S' num2str(subID, '%02i') '_FREQ_CH64']};
    
    for idx = 1:length(folderIdxs);
        folderIdx = folderIdxs(idx);
        
        rlt_fld_idx = 3;    % choose the best model
        [ testAUCAll, trainAUCAll, validAUCAll, testAUCMax, testAUCIdx, ...
            currMaxIdx, setFilesList] = get_one_fold_result...
            ( DLPATH, result_folders{rlt_fld_idx}, folderIdx );

        [i,j]=find(validAUCAll == max(max(validAUCAll)));
        best1_vals(1, :) = trainAUCAll(i,:);
        best1_vals(2, :) = validAUCAll(i,:);
        best1_vals(3, :) = testAUCAll(i,:);
        best1_vals_all(subID, :, :) = best1_vals(:, 1:50);
    end
    
end

mu = squeeze(mean(best1_vals_all));
sigma = squeeze(std(best1_vals_all));

%% plot the color range map
upperline = mu + sigma; upperline = upperline';
buttomline = mu - sigma; buttomline = buttomline';
middleline = mu';
steps = 100:100:5000;
% plot(steps, upperline);
% hold on
% plot(steps, buttomline);

figure1 = figure;
% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% plot the line
plot(steps, middleline(:, 1)', 'b','LineWidth',4, 'DisplayName','Train');
hold on;
% plot the line
plot(steps, middleline(:, 2)', 'g','LineWidth',4, 'DisplayName','Valid');
hold on;
% plot the line
plot(steps, middleline(:, 3)', 'r','LineWidth',4, 'DisplayName','Test');
hold on;
legend1 = legend(axes1,'show');
set(legend1,'Location','southeast');

% plot the range (train)
X = [steps fliplr(steps)];
Y = [buttomline(:,1)' fliplr(upperline(:,1)')];
h = fill(X,Y,'b');
set(h,'facealpha',.2,'linestyle', 'none');
hold on;
% plot the range (valid)
X = [steps fliplr(steps)];
Y = [buttomline(:,2)' fliplr(upperline(:,2)')];
h = fill(X,Y,'g');
set(h,'facealpha',.2,'linestyle', 'none');
hold on;
% plot the range (test)
X = [steps fliplr(steps)];
Y = [buttomline(:,3)' fliplr(upperline(:,3)')];
h = fill(X,Y,'r');
set(h,'facealpha',.2,'linestyle', 'none');
hold on;

% Create xlabel
xlabel('Training Iterations');
% Create title
title({'Performance for GSLT Model on X2 Expertise RSVP'});
% Create ylabel
ylabel('Performance (AUC)');
box(axes1,'on');
% Set the remaining axes properties
xlim(axes1,[0 5100]);
ylim(axes1,[0.5 1.05]);
set(axes1,'FontSize',20,'XGrid','on','XTick',[0 1000 2000 3000 4000 5000],...
    'YGrid','on');
