function LAB_help
    % LAB_help: Search for all LAB_ avilable functions and related clases
    % and returns the name and a short description of each one
    % usage: directly (no input arguments)
    % By: Mauricio Merino, UTSA, 2011
    
    folder1 = pwd;  % current directory
    tlist = what(char([folder1 '/Functions_Classes']));     % list what's inside
    
    disp('               ');        % Indicator, begining
    disp('****************');
    disp('LAB Functions:');
    disp('               ');
    
    for i=1:length(tlist.m)         % Display LAB function's help
        func_name = tlist.m(i);
        func_help = help(char(func_name));
        disp(i);
        disp(func_help)
    end
            
end
    
    
    
