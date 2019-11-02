function thedprime = mydprime(class,truelabels,targetlabel,distractorlabel)
% originally contributed by Jacob Martin.

    if (size(truelabels,2) ~= 1) truelabels = truelabels'; end;
    if (size(class,2) ~= 1) class = class'; end;
    truepositives = length(find(class==targetlabel & truelabels==targetlabel));
    falsepositives = length(find(class==targetlabel & truelabels==distractorlabel));

    truenegatives = length(find(class==distractorlabel & truelabels==distractorlabel));
    falsenegatives = length(find(class==distractorlabel & truelabels==targetlabel));
    numpositive = truepositives + falsenegatives;
    numnegative = falsepositives + truenegatives;

    tpr = truepositives/numpositive;
    fpr = falsepositives/numnegative;

    if (tpr == 1.0)
        tpr = (numpositive + numnegative - 1) / (numpositive + numnegative); % conventional correction to avoid infinite D'
    elseif (tpr == 0.0)
        tpr = 1 / (numpositive + numnegative); % conventional correction to avoid -infinite D'
    end

    if (fpr == 1.0)
        fpr = (numpositive + numnegative - 1) / (numpositive + numnegative); % conventional correction to avoid infinite D'
    elseif (fpr == 0.0)
        fpr = 1 / (numpositive + numnegative); % conventional correction to avoid -infinite D'
    end
    thedprime  = norminv(tpr, 0, 1) - norminv(fpr, 0, 1);
end
