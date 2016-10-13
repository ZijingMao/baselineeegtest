%% bagging
a = [];
a(1,:) = aucBag_freq;
a(2,:) = aucBag_raw;
a(3,:) = aucBag_norm;
a(4,:) = aucBag_freq_raw;
a(5,:) = aucBag_freq_norm;
a(6,:) = aucBag_P3000;
a(7,:) = aucBag_P3000_RAW;
a(8,:) = aucBag_P3000_NORM;
a(9,:) = aucBag_P3001;
a(10,:) = aucBag_P3001_RAW;
a(11,:) = aucBag_P3001_NORM;
a(12,:) = aucBag_P30015;
a(13,:) = aucBag_P30015_RAW;
a(14,:) = aucBag_P30015_NORM;
a(15,:) = aucBag_PSD;
a(16,:) = aucBag_PSD_RAW;
a(17,:) = aucBag_PSD_NORM;
a = a';
mu = mean(a);
sigma = std(a);
a1 = a;

%% BLDA
a = [];
a(1,:) = aucBLDA_freq;
a(2,:) = aucBLDA_raw;
a(3,:) = aucBLDA_norm;
a(4,:) = aucBLDA_freq_raw;
a(5,:) = aucBLDA_freq_norm;
a(6,:) = aucBLDA_P3000;
a(7,:) = aucBLDA_P3000_RAW;
a(8,:) = aucBLDA_P3000_NORM;
a(9,:) = aucBLDA_P3001;
a(10,:) = aucBLDA_P3001_RAW;
a(11,:) = aucBLDA_P3001_NORM;
a(12,:) = aucBLDA_P30015;
a(13,:) = aucBLDA_P30015_RAW;
a(14,:) = aucBLDA_P30015_NORM;
a(15,:) = aucBLDA_PSD;
a(16,:) = aucBLDA_PSD_RAW;
a(17,:) = aucBLDA_PSD_NORM;
a = a';
mu = mean(a);
sigma = std(a);
a2 = a;

%% anova1 test on frequency components
b = a2(:, [9, 12, 1]);
p = anova1(b);  % 0.0013

%% ttest on PSD vs freq
[h,p]=ttest(a1(:,15), a2(:,1));

%% ttest on P300 vs Raw
[h,p]=ttest(a2(:,6), a2(:,2));
[h,p]=ttest(a2(:,3), a2(:,2));

%% test on Freq+R vs Raw
[h,p]=ttest(a2(:,4), a2(:,2));

%% test on blda and bagging
b1 = reshape(a1, [10*17, 1]);
b2 = reshape(a2, [10*17, 1]);
b3 = [b1 b2];
[p,tb1]=anova2(b3, 10);
