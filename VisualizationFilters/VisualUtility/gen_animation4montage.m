function [F] = gen_animation4montage(chanlocs, montageIdx)

%% gen the animation
clc;
montageLength = length(montageIdx);
figure;
a = 60;
for in = 1:montageLength
    
    currMontage = montageIdx(in, :);
    
    hold on;
    for i = 1:montageLength
        r = 0.5; g = 0.5; b = 0.5;
        scatter(chanlocs(i).X,chanlocs(i).Y,a,'MarkerEdgeColor',[r g b],...
            'MarkerFaceColor',[r g b],'LineWidth',0.5);
    end
    hold on;
    markerE = [0, 1, 0];
    markerF = [0, 0.8, 0];
    currIdxPointers = currMontage(1);
    scatter(chanlocs(currIdxPointers).X,chanlocs(currIdxPointers).Y, ...
        a, 'MarkerEdgeColor', markerE, 'MarkerFaceColor', markerF,...
        'LineWidth',0.5);
    hold on
    markerE = [1, 0, 0];
    markerF = [0.8, 0, 0];
    for indexPointers = 2:length(currMontage)
        currIdxPointers = currMontage(indexPointers);
        scatter(chanlocs(currIdxPointers).X,chanlocs(currIdxPointers).Y, ...
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

end