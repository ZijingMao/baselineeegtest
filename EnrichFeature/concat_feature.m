function concat_feature(subIdx, type1, type2)

x_train = [];y_train = [];x_test = [];y_test = [];

train_x = [];train_y = [];test_x = [];test_y = [];
load(['RSVP_X2_S' num2str(subIdx, '%02i') '_' type1 '_CH64.mat']);
x_train = cat(3, x_train, train_x);
x_test = cat(3, x_test, test_x);

train_x = [];train_y = [];test_x = [];test_y = [];
load(['RSVP_X2_S' num2str(subIdx, '%02i') '_' type2 '_CH64.mat']);
x_train = cat(3, x_train, train_x);
x_test = cat(3, x_test, test_x);

train_x = x_train;test_x = x_test;

save(['RSVP_X2_S' num2str(subIdx, '%02i') '_' type1 type2 '_CH64.mat'],...
    'train_x', 'test_x', 'train_y', 'test_y', '-v7.3');

end