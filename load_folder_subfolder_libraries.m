function load_folder_subfolder_libraries

% Use genpath in conjunction with addpath to add the current folder 
% and its subfolders to the search path.
currentFolder = pwd;
% folderName = fullfile(matlabroot,'toolbox','images','colorspaces');
p = genpath(currentFolder);
addpath(p);