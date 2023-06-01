% MIT License

% Copyright (c) 2018 Adam Hines

% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:

% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.

% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

function [fullDataFile, aFold] = goSearching(sFold)

% check for the existence of 405 + 561nm recordings in sub-folders
for n=1:size(sFold,1)
    tempDir = [];
    tempDir = dir(fullfile(sFold(n).folder,'\',sFold(n).name));
    for m=1:size(tempDir,1)
        if strfind(tempDir(m).name,'.tif') > 0
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
        if strfind(tempDirFiles(m).name,'.tif') > 0
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
