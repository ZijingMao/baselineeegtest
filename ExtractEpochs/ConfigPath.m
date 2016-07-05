
%% config the path
configs.config_path = mfilename('fullpath');

[pathstr,~,~] = fileparts(configs.config_path);
if isempty(pathstr)
    error('please press F5, not F9 to execute the script');
end
cd(pathstr); cd ..;  % come to the parent folder of the configuration
configs.workp_path = pwd;
addpath(genpath(pwd));


%% set experiments (change your folder here)
DefineMultipleExperimentName;
configs.exp_names = expName;

configs = config_epoch_extract(configs);

