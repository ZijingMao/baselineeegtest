function [ dis2chan ] = cal_distance( fromChan, toChan )

    xF = fromChan.X;
    yF = fromChan.Y;
    zF = fromChan.Z;
    
    xT = toChan.X;
    yT = toChan.Y;
    zT = toChan.Z;
    
    % calculate the distance
    dis2chan = sqrt((xF-xT)^2+(yF-yT)^2+(zF-zT)^2);

end

