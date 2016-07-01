function plotBoxAndWhisker(data, tag, range, width, numColors, colorMat)

if nargin == 2
    range = [0.6 1];
    
end

if nargin < 4
    width = 0.03;
end

if nargin < 5
    numColors = 5;
end

if nargin < 6
    colorMat = [];
end
addpath('/barleyhome/amarathe/Scripts/boxplotC');
rr = [0, 0, 0.5625];
gg = [ 0.0625,0.9, 0.9375];
bb = [ 0.9, 0.9, 0];
mm = [ 0.5, 0,  0];
qq = [ 0.1, 0.4,  0.1];
tt = [ 0.6, 0.7,  0.1];
ss = [ 0.4, 0.4,  0.4];

p = [0 0.001; 0.001 0.001; 0.001 0; 0 0];

    patch(p(:, 1),p(:, 2),  rr, 'LineWidth', 2);
    hold on;
    patch(p(:, 1),p(:, 2),  gg, 'LineWidth', 2);
    patch(p(:, 1),p(:, 2),  bb, 'LineWidth', 2);
    patch(p(:, 1),p(:, 2),  qq, 'LineWidth', 2);
    patch(p(:, 1),p(:, 2),  mm, 'LineWidth', 2)
    patch(p(:, 1),p(:, 2),  tt, 'LineWidth', 2);
    patch(p(:, 1),p(:, 2),  ss, 'LineWidth', 2);
   
patch(p(:, 1),p(:, 2),  mm, 'LineWidth', 2);


%legend('HDCA', 'XDBLDA', 'CSP', 'CTP', 'location', 'SouthWest');
colorsArray = [rr; gg; bb; qq; mm; tt; ss];
if isempty(colorMat)
    colors = colorsArray;
else
    colors = colorsArray(colorMat, :);
    numColors = length(colorMat);
end


if numColors == 0
  numColors = 7;  
end
    for i= 1:size(data, 2)
        cIndex = mod(i, numColors);
        if cIndex == 0
            cIndex = numColors;
        end
        boxplotCsub(data(:,i),0,[''],1,1,colors(cIndex, :),true,2,true,[i size(data, 2)], 1,width);
    end


xlim([0.92 1.08]);
title(tag);
ylim(range);
set(gca, 'ygrid', 'on');
xlabel('');