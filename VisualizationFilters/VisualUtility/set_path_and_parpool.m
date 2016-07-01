function [data_root_folder, sctipts_folder] = ...
    set_path_and_parpool(parallel_flag, exe_folder)
% SET_PATH_AND_PARPOOL adds project folders and subfolders to the path and
% if indicated, start the pool of workers.

% Check for EEGLAB on current Path, add it if missing
if exist('eeglab.m', 'file')  ~= 2
    % Add EEGLAB to path since it was not found
    cd ..
    cd('External Software\EEGLAB\eeglab13_4_4b');
    eeglab;
    close
    cd([exe_folder '\Scripts']);
end

% Check for project folders on Path, add them if missing
if ( exist('Files', 'dir') ~= 7        || ...
        exist('Functions', 'dir') ~= 7    || ...
        exist('EEG Data', 'dir') ~= 7     || ...
        exist('Files', 'dir') ~= 7     || ...
        exist('Results', 'dir') ~= 7     || ...
        exist('External Software', 'dir') ~= 7     || ...
        exist('Scripts', 'dir') ~= 7 )
    
    
    
    % Add folders to path selectively, based on the operating system
    if ispc || isosX
        folder_char = '/';
    elseif isunix && islinux
        folder_char = '\';
    end
    
    cd ..
    addpath(genpath([pwd, folder_char, 'Files']));
    addpath(genpath([pwd, folder_char, 'Functions']));
    addpath(genpath([pwd, folder_char, 'Scripts']));
    addpath(genpath([pwd, folder_char, 'External Software', ...
        folder_char, 'LSL MATLAB Viewer']));
    cd([exe_folder '\Scripts']);
    clc
end

% Define folder locations as variables
sctipts_folder = pwd;
cd ..
data_root_folder = [pwd, 'Recordings'];
cd(sctipts_folder);

% Activate the pool of MATLAB worers if the flag is active (==1)
if parallel_flag
    try
        parpool
    catch
    end
end

clc
end

