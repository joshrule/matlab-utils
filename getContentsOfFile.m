function s = getContentsOfFile(f)
    if exist(f,'file')
        s = load(f);
    else
        s = struct();
        save(f,'-v7.3','-struct','s');
    end
end
