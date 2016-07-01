load('/home/zijing.mao/BaselineAnalysis/Source/chanlocs.mat');
chanlocs = chanlocs64;
kernelSize = 3;
stride = 1;

%% draw the figure for scalp
k = 0;
figure_data = figure;
for i = 1:length(chanlocs)
    r = bitget(k,1)/1.2+0.1;
    g = bitget(k,2)/1.2+0.1;
    b = bitget(k,3)/1.2+0.1;
    scatter(chanlocs(i).X,chanlocs(i).Y,40,'MarkerEdgeColor',[r g b],...
        'MarkerFaceColor',[r g b],'LineWidth',1.5);
    % pause(2);
    hold on;
    if mod(i, 8) == 0
        k = k+1;
    end
end

%% gen the animation
clc;
figure_data = figure;
a = 60;
nextPointer = stride+1;
for in = 1:floor(length(chanlocs)/2)-1
    prevPointer = nextPointer-stride+1;
    nextPointer = prevPointer+kernelSize-1;
    
    markerE = [1, 0, 0];
    markerF = [0.8, 0, 0];
    
    hold on;
    for i = 1:length(chanlocs)
        r = 0.5; g = 0.5; b = 0.5;
        scatter(chanlocs(i).X,chanlocs(i).Y,a,'MarkerEdgeColor',[r g b],...
            'MarkerFaceColor',[r g b],'LineWidth',0.5);
        if mod(i, 8) == 0
            k = k+1;
        end
    end
    hold on;
    for indexPointers = prevPointer:nextPointer
        scatter(chanlocs(indexPointers).X,chanlocs(indexPointers).Y, ...
                a, 'MarkerEdgeColor', markerE, 'MarkerFaceColor', markerF,...
                'LineWidth',0.5);
    end
    drawnow;
    pause(2);
    
    F(in) = getframe(gcf);   
    hold off;
end

filename = 'ScalpShowSlidingWindow.avi';
v = VideoWriter(filename,'Uncompressed AVI');
v.FrameRate = 3;
open(v);
writeVideo(v,F);
close(v);
