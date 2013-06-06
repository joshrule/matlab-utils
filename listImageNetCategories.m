function categories = listImageNetCategories(imgDir)
   files = dir([imgDir 'n*']);
   categories = unique(regexp({files.name}','n\d+','match','once'));
end
