function [threshold accuracy] = findThreshold(p, label)

% Copyright (C) 2004 Lucas Parra (ROC function)
% modified to output threshold and accuracy by A. Marathe - 8/2012
% modified for unsorted input by J.Touryan - 10/2012
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA


% Sort scores & labels, high to low
[~,indx]=sort(-p);

% Binary labels {0, 1}
label = label>0;
Np=sum(label==1);
Nn=sum(label==0);

% Initialze AUC variables
Az=0;                       % Area Under the Curve
N=Np+Nn;                    % Total Number 
tp=zeros(N+1,1);            % True Positive
fp=zeros(N+1,1);            % False Positive
d = zeros(N, 1);            % Distance to Origin

% Calculate fractions and distance at each threshold
for i=1:N
  
  tp(i+1)=tp(i)+label(indx(i))/Np;
  fp(i+1)=fp(i)+(~label(indx(i)))/Nn;
  Az = Az + (~label(indx(i)))*tp(i+1)/Nn;
  d(i) = sqrt((1-tp(i))^2 + (0-fp(i))^2);
  
end
adj_tpr = tp - fp;
% Min distance = best threshold
[~, threshIndex] = min(d);
threshold = p(indx(threshIndex));

% [~, threshIndex] = max(adj_tpr);
% threshold = p(indx(threshIndex));

accuracy = Az;










