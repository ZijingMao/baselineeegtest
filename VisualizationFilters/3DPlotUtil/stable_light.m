function stable_light

load mheadnew

for k=1:9
       
   % Plot the first head, Delta brain waves
   subplot('Position',[0.01 0.45 0.19 0.50]);
   view([-204 12]);
   plotmesh(TRI1, POS, NORM);
   
   % Plot the second head, Theta brain waves
   subplot('Position',[0.205 0.45 0.19  0.50]);
   view([-204 12]);
   plotmesh(TRI1, POS, NORM);
  
   % Plot the third head, Alpha brain waves
   subplot('Position',[0.4 0.45 0.19  0.50]);
   view([-204 12]);
   plotmesh(TRI1, POS, NORM);
  
   % Plot the fourth head, Beta brain waves
   subplot('Position',[0.595 0.45 0.19 0.50]);
   view([-204 12]);
   plotmesh(TRI1, POS, NORM);
    
   % Plot the fifth head, Gamma brain waves 
   subplot('Position',[0.79 0.45 0.19 0.50]);
   view([-204 12]);
   plotmesh(TRI1, POS, NORM);
                 
%    % Second heads, in 2D versions
%    % Plot the first head, Delta brain waves
%    subplot('Position',[0.01 0.02 0.19 0.35]);
%    plotmesh(TRI1, POS, NORM);
%    
%    % Plot the second head, Theta brain waves
%    subplot('Position',[0.205 0.02 0.19  0.35]);
%    plotmesh(TRI1, POS, NORM);
%   
%    % Plot the third head, Alpha brain waves
%    subplot('Position',[0.4 0.02 0.19  0.35]);
%    plotmesh(TRI1, POS, NORM);
%   
%    % Plot the fourth head, Beta brain waves
%    subplot('Position',[0.595 0.022 0.19 0.35]);
%    plotmesh(TRI1, POS, NORM);
%     
%    % Plot the fifth head, Gamma brain waves 
%    subplot('Position',[0.79 0.022 0.19 0.35]);
%    plotmesh(TRI1, POS, NORM);
   
end


end