load('fold0ct2ws.mat');
[B, FitInfo] = lassoglm(train_x,train_y,'normal',  'CV', 2);
save('lassoParam.mat', 'B', 'FitInfo');
% lassoPlot(B,FitInfo);