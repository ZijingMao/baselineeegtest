% Version 4, updated help will be added later
clear
close all
clc

% Add EEGlab and needed file\folders to the path
cd ../..
addpath(genpath([pwd '/Source']));
addpath(genpath([pwd '/VisualizationFilters']));

exe_folder = [pwd '\VisualizationFilters'];  % Specific recording folder to use
cd(exe_folder);

use_parfor = false;                      % active or not parallel for loops
[dataset_folder, script_folder] = set_path_and_parpool(use_parfor, exe_folder);

%% plot 6 scalp

scalp_feat = 2.^([1:6]+2);

for idx = 1:6
    vis_scalp_filter( scalp_feat(idx) );
    close all;
end

