function aFold = getFoldersBatch(bFold)

% eliminate data files
bFold([1:2],:) = [];
for n = 1:size(bFold,1)
    if bFold(n).isdir == 1
        keepRow(n,:) = 1;
    else
        keepRow(n,:) = 0;
    end
end

keepRow = logical(keepRow);
aFold = bFold(keepRow,:);