clear all
close all
clc

% Test Script for load the 3D brain model, and plot it correclty in MATLAB
load mheadnew                       % points and vertices of 3D head model
load brain_model                    % contais the Point locations and Vertices


% Plot the brain points
figure, plot3((Brain3Dp(:,1)*25),(Brain3Dp(:,3)*25),(Brain3Dp(:,2)*25)-13,'red','LineWidth',1);

% Plot an aproximation of the brain Surface
figure
trisurf(Brain3Dv, Brain3Dp(:,1)*25, Brain3Dp(:,2)*25, Brain3Dp(:,3)*25);
view(3);

% Plot toghether the head model (just points) and the brain inside (points)
figure, plot3((Brain3Dp(:,1)*25),(Brain3Dp(:,3)*25),(Brain3Dp(:,2)*25)-13,'red','LineWidth',1);
hold on
grid on
plot3(POS(:,1),POS(:,2),POS(:,3),'.');
hold off

% Plot toghether the head model (just points) and the brain inside (points)
figure, plot3((Brain3Dp(:,1)*25),(Brain3Dp(:,3)*25),(Brain3Dp(:,2)*25)-13,'red','LineWidth',1);
hold on
grid on
plot3(POS(:,1),POS(:,2),POS(:,3),'.');
hold on
trisurf(Brain3Dv, (Brain3Dp(:,1)*25),(Brain3Dp(:,3)*25),(Brain3Dp(:,2)*25)-13);
hold off

% Plot the head surface (polygons)
figure, trisurf(TRI1, POS(:,1), POS(:,2), POS(:,3)); view(2);                       
%tr = TriRep(Brain3Dv, Brain3Dp(:,1), Brain3Dp(:,2), Brain3Dp(:,3));

