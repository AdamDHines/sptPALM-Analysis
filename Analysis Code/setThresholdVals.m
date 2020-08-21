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