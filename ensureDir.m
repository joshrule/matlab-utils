function success = ensureDir(dirName)
% Author: Santosh Divvala
% Revised: saurabh.me@gmail.com (Saurabh Singh).
% Revised: rsj28@georgetown.edu (Josh Rule).
%
% Conditionally create a directory and return its path
%
% dirName: string, the absolute path of the directory
%
% success: string, the absolute path of the directory, empty on failure
    if exist(dirName, 'dir') || mkdir(dirName)
        success = dirName;
    else
        success = '';
    end
end
