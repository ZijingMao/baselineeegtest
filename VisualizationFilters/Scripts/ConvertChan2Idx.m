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

%% load data
load('ChanMapper.mat');

feat_size_list = 2 .^ [3:8];

%% feat 1
idx_feat = 1;
    
feat_size = feat_size_list(idx_feat);

mapperChan5KernelName = ['Mapper' num2str(feat_size) 'Chan5Kernel'];
mapperChan5Kernel = eval(mapperChan5KernelName);

chanCellName = ['Chan' num2str(feat_size)];
chanCell = eval(chanCellName);

[ Idx8Chan5Kernel ] = convert_chan2idx( mapperChan5Kernel, chanCell );

%% feat 2
idx_feat = 2;
    
feat_size = feat_size_list(idx_feat);

mapperChan5KernelName = ['Mapper' num2str(feat_size) 'Chan5Kernel'];
mapperChan5Kernel = eval(mapperChan5KernelName);

chanCellName = ['Chan' num2str(feat_size)];
chanCell = eval(chanCellName);

[ Idx16Chan5Kernel ] = convert_chan2idx( mapperChan5Kernel, chanCell );

%% feat 3
idx_feat = 3;
    
feat_size = feat_size_list(idx_feat);

mapperChan5KernelName = ['Mapper' num2str(feat_size) 'Chan5Kernel'];
mapperChan5Kernel = eval(mapperChan5KernelName);

chanCellName = ['Chan' num2str(feat_size)];
chanCell = eval(chanCellName);

[ Idx32Chan5Kernel ] = convert_chan2idx( mapperChan5Kernel, chanCell );

%% feat 4
idx_feat = 4;
    
feat_size = feat_size_list(idx_feat);

mapperChan5KernelName = ['Mapper' num2str(feat_size) 'Chan5Kernel'];
mapperChan5Kernel = eval(mapperChan5KernelName);

chanCellName = ['Chan' num2str(feat_size)];
chanCell = eval(chanCellName);

[ Idx64Chan5Kernel ] = convert_chan2idx( mapperChan5Kernel, chanCell );

%% feat 5
idx_feat = 5;
    
feat_size = feat_size_list(idx_feat);

mapperChan5KernelName = ['Mapper' num2str(feat_size) 'Chan5Kernel'];
mapperChan5Kernel = eval(mapperChan5KernelName);

chanCellName = ['Chan' num2str(feat_size)];
chanCell = eval(chanCellName);

[ Idx128Chan5Kernel ] = convert_chan2idx( mapperChan5Kernel, chanCell );

%% feat 6
idx_feat = 6;
    
feat_size = feat_size_list(idx_feat);

mapperChan5KernelName = ['Mapper' num2str(feat_size) 'Chan5Kernel'];
mapperChan5Kernel = eval(mapperChan5KernelName);

chanCellName = ['Chan' num2str(feat_size)];
chanCell = eval(chanCellName);

[ Idx256Chan5Kernel ] = convert_chan2idx( mapperChan5Kernel, chanCell );
