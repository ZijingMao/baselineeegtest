function new_locs = LAB_electrodes_on_scalp_hd(channel_locs)
% LAB_electrodes_on_scalp receives channel locations from a matrix or a
% struct and extract the X,Y,Z location for electrodes, then load a 3D head
% model reference from the EEGLAB's files (mheadnew.mat) and create new
% channel locations on the scalp of the 3D model (it could be a fairy
% reference). The result is a n x 3 new matrix with the channel locations.
%
% Usage:
% new_loc = LAB_electrodes_on_scalp(channel_loc_matrix); % a n x 3 matrix
% new_loc = LAB_electrodes_on_scalp(my_struct{a,b}.loc); % locs in a struct
% new_loc = LAB_electrodes_on_scalp(my_cell.loc);        % a cell or an object
% By: Mauricio Merino, UTSA, 2011




% Preallocate variables
POS = zeros(1,10);
load mhead_hd.mat
[headpnumber,~] = size(POS);
diff_XYZ = zeros(headpnumber,3);
diff_average = zeros(1,headpnumber);
number_of_channels = length(channel_locs);
new_locs = zeros(number_of_channels,3);

% Extract channel locations
for i=1:number_of_channels
    
    new_locs(i,1) = -channel_locs(1,i).X;
    new_locs(i,2) = channel_locs(1,i).Y;
    new_locs(i,3) = channel_locs(1,i).Z;
    
end

% Adapt channel locations to the 3D head size and get color
% Calculate lenght's per dimension
channel_lenght_X = max(new_locs(:,1)) - min(new_locs(:,1));
channel_lenght_Y = max(new_locs(:,2)) - min(new_locs(:,2));
channel_lenght_Z = max(new_locs(:,3)) - min(new_locs(:,3));

% The size for the head model is different, calculate lenghts
head_lenght_Y = max(POS(:,2)) - min(POS(:,2));    % set the head
head_lenght_X = max(POS(:,1)) - min(POS(:,1));
head_lenght_Z = max(POS(:,3)) - min(POS(:,3)) - 1.5;

% How many times Head model size is bigger than channel locations
head_ratio_X = head_lenght_X/channel_lenght_X;
head_ratio_Y = head_lenght_Y/channel_lenght_Y;
head_ratio_Z = head_lenght_Z/channel_lenght_Z;

% Using the rate, approximate head model to channel's location size
new_locs(:,1) = new_locs(:,1).*head_ratio_X;
new_locs(:,2) = new_locs(:,2).*head_ratio_Y;
new_locs(:,3) = new_locs(:,3).*head_ratio_Z;

idxHeadList = zeros(1, number_of_channels);

% Go through channels again to compare with heads' points
for i=1:number_of_channels
    
    % Calculate X,Y,Z distances from current channel to all head points
    for j=1:headpnumber
        diff_XYZ(j,1) = abs(new_locs(i,1) - POS(j,2));
        diff_XYZ(j,2) = abs(new_locs(i,2) - POS(j,1));
        diff_XYZ(j,3) = abs(new_locs(i,3) - POS(j,3));
        diff_average(j) = (diff_XYZ(j,1) + diff_XYZ(j,2) + diff_XYZ(j,3))/3;
    end
    
    % Get the closest xyz point based on distances and change channel loc
    % close_point = sum((1:headpnumber).*(diff_average == min(diff_average)));
    % close_point = find(diff_average == min(diff_average));
    [~, close_point_list] = sort(diff_average);
    idx = 1;
    close_point = close_point_list(idx);
    if close_point > headpnumber
        error('The index out side the data');
    end
    while any(idxHeadList == close_point)
        close_point = close_point_list(idx);
        idx = idx + 1;
    end
    idxHeadList(i) = close_point;
    
    new_locs(i,1) = POS(close_point,2);
    new_locs(i,2) = POS(close_point,1);
    new_locs(i,3) = POS(close_point,3);
end
end