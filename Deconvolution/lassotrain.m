function [B, B0, B1, FitInfo, preds] = lassotrain( train_x, train_y )
% LASSOTRAIN Summary of this function goes here
% train_x should be the last convolution layer and resized as a vector
% B0 is the coefficient for the model
% B1 is B0 + a constant coefficient

Ybool = train_y(:, 1) == 1;  % get the label of the data
rng('default');
% set NumLambda to a smaller number if want the model more sparse
[B, FitInfo] = mylasso(train_x, Ybool, 'binomial', 'NumLambda', 25, 'CV', 5);  
lassoPlot(B,FitInfo,'PlotType','CV');
indx = FitInfo.Index1SE;
B0 = B(:,indx);
nonzeros = sum(B0 ~= 0);
disp(['There are ' num2str(nonzeros) 'features that are non-zero.']);
cnst = FitInfo.Intercept(indx); % get the constant variable
B1 = [cnst;B0];
preds = glmval(B1,train_x,'logit');
hist(Ybool - preds) % plot residuals
title('Residuals from lassoglm model');

end

