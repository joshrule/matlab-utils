function wnids = listImageNetCategories(files)
% wnids = listImageNetCategories(files)
%
% pull out the WordNetID from filenames including them. Really, this just keeps
% me from having to type in the regular expression all the time.
%
% files: cell array of strings, the file names including WNIDS
%
% wnids: cell array of strings, the isolated wnids
   wnids = unique(regexp(files,'n\d+','match','once'));
end
