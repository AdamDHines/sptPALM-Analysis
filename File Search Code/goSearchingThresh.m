function [fullDataFile, aFold] = goSearchingThresh(sFold)

% check for the existence of 405 + 561nm recordings in sub-folders
for n=1:size(sFold,1)
    tempDir = [];
    tempDir = dir(fullfile(sFold(n).folder,'\',sFold(n).name));
    for m=1:size(tempDir,1)
        if strfind(tempDir(m).name,'.czi') > 0
            dataFound(m,n) = 1;
        else
            dataFound(m,n) = 0;
        end
    end
    sumFound = sum(dataFound(:,n));
    if sumFound > 0
        useFold(n,:) = 1;
    else
        useFold(n,:) = 0;
    end
end

% eliminate datasets that didn't have 405 and 561 nm recordings
aFold = sFold(find(useFold),:);

% output data file names
for n=1:size(aFold,1)
    tempDir = [];
    tempDir = fullfile(aFold(n).folder,'\',aFold(n).name);
    tempDirFiles = dir(tempDir);
    dataSelect = [];
    for m=1:size(tempDirFiles,1)
        if strfind(tempDirFiles(m).name,'.czi') > 0
            dataSelect(m,:) = 1;
        else
            dataSelect(m,:) = 0;
        end
    end
    dataRow = [];
    dataRow = find(dataSelect);
    if size(dataRow,1) > 1
        continue
    else
        fullDataFile{n,:} = fullfile(tempDirFiles(dataRow).folder,'\',tempDirFiles(dataRow).name);
    end
end
fullDataFile(~cellfun('isempty',fullDataFile)); % eliminate empty arrays