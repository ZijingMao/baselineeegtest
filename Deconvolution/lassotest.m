function [preds] = lassotest( test_x, test_y, B1 )
%LASSOTEST Summary of this function goes here

Ybool = test_y(:, 1) == 1;  % get the label of the data
preds = glmval(B1,test_x,'logit');
hist(Ybool - preds) % plot residuals
title('Residuals from lassoglm model');

end

