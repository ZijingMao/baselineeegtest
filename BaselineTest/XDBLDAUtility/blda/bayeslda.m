function b = bayeslda(verbose)
%% Warning: if this function is used then you must cite at least this paper:
% U. Hoffmann, J. Vesin, K. Diserens, and T. Ebrahimi, An efficient P300-based brain-computer interface for disabled subjects,
% Journal of Neuroscience Methods, vol. 167, no. 1, pp. 115–125, 2008.

%% (initial source ->)
% constructor for class bayeslda
% Bayesian Linear Discriminant Analysis
%
% METHODS:
%       train    - learns a linear discriminant from training examples
%       classify - classfies new examples
%    getevidence - returns the log evidence for the learned discriminant
%
% Author: Ulrich Hoffmann - EPFL, 2006
% Copyright: Ulrich Hoffmann - EPFL


%% set verbose flag 
if nargin == 1
    b.verbose = verbose;    % if set train gives verbose output
else
    b.verbose = 0;
end


%% define attributes of object
b.evidence = 0;             % log evidence 
b.beta = 0;                 % inverse variance of noise 
b.alpha = 0;                % inverse variance of prior 
b.w  = [];                  % weight vector (mean of posterior)
b.p  = [];                  % precision matrix of posterior


%% initialize class
% b = class(b,'bayeslda');