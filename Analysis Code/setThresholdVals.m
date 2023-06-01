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

function setThresholdVals(fileDir)

% establish if a lutThresh.m file is already in existence
% Give user the choice to overwrite existing lutThresh files
directory = dir(fileDir);
for n = 1:size(directory,1)
    flg = strcmp('lutThresh.mat',directory(n).name);
    if flg == 1
        answer = questdlg('Thresholds have already been set this dataset, would you like to overwrite?',...
            'Threshold values already set','Yes','No','No');
        if strcmp('Yes',answer) == 0
            return
        end
    end
end

% Determine the number of files available for thresholding
directory([1:2],:) = [];
for n = 1:size(directory,1)
    flg = strcmp('lutThresh.mat',directory(n).name);
    if flg == 1
        directory(n,:) = [];
    end
end
fullDataFile = goSearchingThresh(directory);
numFiles = size(fullDataFile,1);

% Generate prompt box for user to input threshold values
prompt = {'Enter the threshold values, separating numbers with a space.'};
dlgtitle = 'Input threshold values';
userAnswer = inputdlg(prompt,dlgtitle);
lutThresh = str2num(userAnswer{1});

% output the threshold values to the analysis folder
save('lutThresh.mat','lutThresh');
movefile('lutThresh.mat',fileDir);

% Let user know the threshold values were successfully set
msgbox('Threshold values succesfully set.');
