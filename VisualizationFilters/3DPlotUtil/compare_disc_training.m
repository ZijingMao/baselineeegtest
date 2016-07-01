t_test_tra = zeros(160,3);

for i=1:160
    
    [~,~,~,stats] = ttest2(disc_training_A(i,:), disc_training_B(i,:));
    t_test_tra(i,1) = abs(stats.tstat); 
    
    [~,~,~,stats] = ttest2(disc_training_A(i,:), disc_training_C(i,:));
    t_test_tra(i,2) = abs(stats.tstat); 
    
    [~,~,~,stats] = ttest2(disc_training_B(i,:), disc_training_C(i,:));
    t_test_tra(i,3) = abs(stats.tstat); 
end

% Class 1 vs Class 2
Y = [t_test_tra(1:160,1), t_test_tra(1:160,2)];
figure, bar(Y);
grid on
xlabel(' Discriminant Feature (1 - 160) ', 'Fontsize', 17);
ylabel(' T-value from T-test', 'Fontsize', 17);
title('Features data comparison: Class 1 vs Class 2 (Training dataset)', 'Fontsize', 19);
h = legend('Class 1(Low Activity)', 'Class 2(High Activity)');
set(h, 'Fontsize', 16);

% Class 1 vs Class 3
Y = [t_test_tra(1:160,1), t_test_tra(1:160,3)];
figure, bar(Y);
grid on
xlabel(' Discriminant Feature (1 - 160) ', 'Fontsize', 17);
ylabel(' T-value from T-test', 'Fontsize', 17);
title('Features data comparison: Class 1 vs Class 3 (Training dataset)', 'Fontsize', 19);
h = legend('Class 1(Low Activity)', 'Class 3(Medium Activity)');
set(h, 'Fontsize', 16);

% Class 2 vs Class 3
Y = [t_test_tra(1:160,2), t_test_tra(1:160,3)];
figure, bar(Y);
grid on
xlabel(' Discriminant Feature (1 - 160) ', 'Fontsize', 17);
ylabel(' T-value from T-test', 'Fontsize', 17);
title('Features data comparison: Class 2 vs Class 3 (Training dataset)', 'Fontsize', 19);
h = legend('Class 2(High Activity)', 'Class 3(Medium Activity)');
set(h, 'Fontsize', 16);