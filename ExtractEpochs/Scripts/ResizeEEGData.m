load('C:\Users\EEGLab\Downloads\RSVP_X2_S01_RAW_CH64.mat')

[ train_x ] = resizeEpochs( train_x );
train_x = single(train_x);
[ test_x ] = resizeEpochs( test_x );
test_x = single(test_x);

save('C:\Users\EEGLab\Downloads\RSVP_X2_S01_RES_CH64.mat', ...
    'train_x', 'test_x', 'train_y', 'test_y', '-v7.3');