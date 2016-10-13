function pred = createPredictor(mdl,data)
%CREATEPREDICTOR Return 1-step ahead predictor.
%
%   sys = createPredictor(mdl,data)
%
%   Create a 1-step ahead predictor model sys for the specified model mdl
%   and measured data. The function is used by
%   |TimeSeriedPredictionExample| and the |translatecov()| command to
%   translate the identified model covariance to the predictor.

% Copyright 2015 The MathWorks, Inc.
[~,~,pred] = predict(mdl,data,1);
