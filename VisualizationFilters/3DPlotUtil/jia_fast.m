clear all
close all
clc

% load files
load Jia
load mheadnew

% preallocate varaibles
colors1 = zeros(190,3);
colors2 = zeros(190,3);
colors3 = zeros(190,3);
scores1 = zeros(1,190);
scores2 = zeros(1,190);
scores3 = zeros(1,190);

% Extract and adapt channel locations
chan1 = LAB_electrodes_on_scalp(FTS{1,1}.loc);
chan2 = LAB_electrodes_on_scalp(FTS{1,2}.loc);
chan3 = LAB_electrodes_on_scalp(FTS{1,3}.loc);

% Extract and sort scores values, create colors array
scores1(:) = FTS{1,1}.Score(:,1);
scores2(:) = FTS{1,2}.Score(:,1);
scores3(:) = FTS{1,3}.Score(:,1);

% Inverse values to get the opposite of the Autum colormap colors
scores1 = 1-scores1;
scores2 = 1-scores2;
scores3 = 1-scores3;

scores1 = sort(scores1);
scores2 = sort(scores2);
scores3 = sort(scores3);
scolor = colormap(autumn(length(FTS{1,1}.Score)));
close

% % New score extraction and color assigment
% scores1(:) = FTS{1,1}.Score(:,1);
% temp = (scores1 <=0.5);
% colors1(temp,3) = 1;
% scores1(temp) = 0.18;
% temp = (scores1 >0.5);
% scores1(temp) = 0.9;
% colors1(temp,1) = 1;
% 
% scores2(:) = FTS{1,2}.Score(:,1);
% temp = (scores2<=0.5);
% scores2(temp) = 0.18;
% colors2(temp,3) = 1;
% temp = (scores2 >0.5);
% scores2(temp) = 0.9;
% colors2(temp,1) = 1;
% 
% scores3(:) = FTS{1,3}.Score(:,1);
% temp = (scores3<=0.5);
% colors3(temp,3) = 1;
% scores3(temp) = 0.18;
% temp = (scores3 >0.5);
% scores3(temp) = 0.9;
% colors3(temp,1) = 1;


for i=1:length(FTS{1,1}.Score);
    
    % Read current value
    temp1 = FTS{1,1}.Score(i,1);
    temp2 = FTS{1,2}.Score(i,1);
    temp3 = FTS{1,3}.Score(i,1);
    
    % Inverse values to get the opposite of the Autum colormap colors
    temp1 = 1-temp1;
    temp2 = 1-temp2;
    temp3 = 1-temp3;
    
    
    % Find ordenated position
    temp1 = floor(sum((scores1 == temp1) .* (1:length(FTS{1,1}.Score))...
        /sum((scores1 == temp1))));
    
    temp2 = floor(sum((scores2 == temp2) .* (1:length(FTS{1,2}.Score))...
        /sum((scores2 == temp2))));
    
    temp3 = floor(sum((scores3 == temp3) .* (1:length(FTS{1,3}.Score))...
        /sum((scores3 == temp3))));
    
    % Get color for channels
    colors1(i,1) = scolor(temp1,1);
    colors2(i,1) = scolor(temp2,1);
    colors3(i,1) = scolor(temp3,1);
    colors1(i,2) = scolor(temp1,2);
    colors2(i,2) = scolor(temp2,2);
    colors3(i,2) = scolor(temp3,2);
    colors1(i,3) = scolor(temp1,3);
    colors2(i,3) = scolor(temp2,3);
    colors3(i,3) = scolor(temp3,3);
    
end

% Plot the figures
subplot(3,2,1)
view([148 32]);
plotmesh(TRI1, POS, NORM);
hold on
scatter3(chan1(:,2), chan1(:,1), chan1(:,3)...
,24,colors1,'Linewidth',3);
%set(get(colorbar,'ylabel'),'string','Score Value','fontsize',16);
%colormap(jet);
%caxis([0 1]);
axis off

subplot(3,2,2)
view([62 26]);
plotmesh(TRI1, POS, NORM);
hold on
scatter3(chan1(:,2), chan1(:,1), chan1(:,3)...
,24,colors1,'Linewidth',3);
%set(get(colorbar,'ylabel'),'string','Score Value','fontsize',16);
%colormap(jet);
%caxis([0 1]);
axis off

subplot(3,2,3)
view([148 32]);
plotmesh(TRI1, POS, NORM);
hold on
scatter3(chan2(:,2), chan2(:,1), chan2(:,3)...
,24,colors2,'Linewidth',3);
%set(get(colorbar,'ylabel'),'string','Score Value','fontsize',16);
%colormap(jet);
%caxis([0 1]);
axis off

subplot(3,2,4)
view([62 26]);
plotmesh(TRI1, POS, NORM);
hold on
scatter3(chan2(:,2), chan2(:,1), chan2(:,3)...
,24,colors2,'Linewidth',3);
%set(get(colorbar,'ylabel'),'string','Score Value','fontsize',16);
%colormap(jet);
%caxis([0 1]);
axis off

subplot(3,2,5)
view([148 32]);
plotmesh(TRI1, POS, NORM);
hold on
scatter3(chan3(:,2), chan3(:,1), chan3(:,3)...
,24,colors3,'Linewidth',3);
%set(get(colorbar,'ylabel'),'string','Score Value','fontsize',16);
%colormap(jet);
%caxis([0 1]);
axis off

subplot(3,2,6)
view([62 26]);
plotmesh(TRI1, POS, NORM);
hold on
scatter3(chan3(:,2), chan3(:,1), chan3(:,3)...
,24,colors3,'Linewidth',3);
%set(get(colorbar,'ylabel'),'string','Score Value','fontsize',16);
%colormap(jet);
%caxis([0 1]);
axis off



