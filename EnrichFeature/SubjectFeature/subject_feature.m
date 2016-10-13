load('C:\Users\EEGLab\Documents\20160527_RSVP_DATASET\SUB\RSVP_X2_S01_SUB_CH64.mat');

test_xx = test_x;
train_xx = train_x;
test_yy = test_y(1:2304);
train_yy = train_y(1:19968);
test_yy = test_yy';
train_yy = train_yy';

load('C:\Users\EEGLab\Documents\20160527_RSVP_DATASET\SUB\train.mat')
load('C:\Users\EEGLab\Documents\20160527_RSVP_DATASET\SUB\test.mat')
load('C:\Users\EEGLab\Documents\20160527_RSVP_DATASET\X2RSVP64CHAN.mat');

a1 = x{1}; a2 = y{1};
b1 = x{2}; b2 = y{2};
test_y = [a2(9001:end); b2(11001:end)];
train_y = [a2(1:9000); b2(1:11000)];
test_y = test_y(1:2304);
train_y = train_y(1:19968);

y_train = [train_y+train_yy*2-4];
y_test = [test_y+test_yy*2-4];

test_xx = squeeze(test_xx);
test_xx = reshape(test_xx, [64*64, 2310]);
test_xx = test_xx';
test_xx(2305:end, :) = [];

train_xx = squeeze(train_xx);
train_xx = reshape(train_xx, [64*64, 20000]);
train_xx = train_xx';
train_xx(19969:end, :) = [];

%% 
test_y = test_y-4;
train_y = train_y-4;
for idx = 1:100:500
    test_xxx = [test_xx repmat(test_yy, [1, idx])];
    train_xxx = [train_xx repmat(train_yy, [1, idx])];
    auc1((idx-1)/100+1) 	= 	train_classifier(train_xxx, train_y, test_xxx, test_y, 'Bagging');
end
plot(auc1)

%%
motivation = {'subject 1 target', 'subject 1 nontarget', ...
				'subject 2 target', 'subject 2 nontarget',};
            
input2tsne = test_xx;
labels = y_test;
% input2tsne = reshape(vector, [motivation_size*amount_nearest, vector_size]);
% input2tsne = [mVector; input2tsne];
output2tsne = tsne(input2tsne, labels, 2, 30, 20, motivation);

%%
figure;
subplot(2, 2, 1);
imagesc(squeeze(mean(test_xx(y_test==0,:,:),1))'); title('subject 1 target'); colormap(jet);
subplot(2, 2, 2);
imagesc(squeeze(mean(test_xx(y_test==1,:,:),1))'); title('subject 1 nontarget'); colormap(jet);
subplot(2, 2, 3);
imagesc(squeeze(mean(test_xx(y_test==2,:,:),1))'); title('subject 2 target'); colormap(jet);
subplot(2, 2, 4);
imagesc(squeeze(mean(test_xx(y_test==3,:,:),1))'); title('subject 2 nontarget'); colormap(jet);

