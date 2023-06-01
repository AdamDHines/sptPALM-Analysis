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

function [newTracks,foldOut] = prepTracks(tracks,i,outPutFold,fullDataFile,drift)

% Function prepTracks takes the raw .xml tracks files, sorts for unique
% series, and exports track coordinates into a .csv file. This file is used
% in caluclation of the mean squared displacement and diffusion
% coefficients.
% ----------------
% FUNCTION INPUTS
%
% tracks - Tracks imported from .xml file from runTrackMate analysis.
%
% i - Identifies the filename for outputting track coordinates into .csv.
%
% outPutFolder - Outputs the track coordinates into the unique folder
% generated from the analysis.
%
% fullDataFile - Contains all the file names, necessary for outputting
% unique .csv files.
% 
% ----------------
% FUNCTION OUTPUTS
% 
% newTracks - Shows number of tracks, used in the <1,000 exclusion rule for
% calculating mean squaured displacement and diffusion coefficients.
%
% foldOut - Output file name, used in importing data for the mean squared
% displacement and diffusion coefficient calculations.
%
% Adam Hines - a.david.hines@gmail.com (2019)

% prepare the track data into a .csv format for analysis using
% averageMSDCalculator
% run drift correction
% prep tracks for .xryt for NASTIC analysis
newTracks = []; nasticTracks = [];
for n = 1:size(tracks,1)
    tempTracks = []; tempTracks = tracks{n,:};
    driftIndCorrect = []; driftIndCorrect = tempTracks(:,1)+1;
    driftInd = []; driftInd = drift(driftIndCorrect,:);
    % correct x & y coordinates
    tempTracks(:,2) = tempTracks(:,2)-driftInd(:,1);
    tempTracks(:,3) = tempTracks(:,3)-(driftInd(:,2)*-1);
    timePlace = []; timePlace = 0.03*tempTracks(:,1);
    tempTracks([1:size(tempTracks,1)],1) = n;
    timeSeries = []; timeSeries = (0:0.030:0.030*(size(tempTracks,1)-1))';
    tempTracks(:,4) = timeSeries;
    if size(newTracks,1) == 0
        newTracks = tempTracks;
    else
        newTracks = [newTracks;tempTracks];
    end
    tempNASTIC = []; tempNASTIC = tempTracks; tempNASTIC(:,4) = timePlace;
    nasticTracks = [nasticTracks ; tempNASTIC];
end

% export data as .csv for MSD and Diff Coeff analysis
e = actxserver('Excel.Application');
eWorkbook = e.Workbooks.Add;
eSheets = e.ActiveWorkbook.Sheets;
eSheet1 = eSheets.get('Item',1);
eSheet1.Activate;
eActivesheetRange = get(e.Activesheet,'Range',...
                                      sprintf('A1:D%g',size(newTracks,1)));
eActivesheetRange.Value = newTracks;
[~,name,~] = fileparts(fullDataFile{i,:});
formatFile = 'Track coordinates %s';
foldOut = fullfile(outPutFold,sprintf(formatFile,name));
SaveAs(eWorkbook,foldOut);
Quit(e);
delete(e);

% export data as .xryt for NASTIC analysis
dlmwrite(fullfile(outPutFold,strcat(name,'.trxyt')),nasticTracks,'delimiter',' ');
