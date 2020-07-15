function [newTracks,foldOut] = prepTracks(tracks,i,outPutFold,fullDataFile)

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
newTracks = [];
for n = 1:size(tracks,1)
    tempTracks = []; tempTracks = tracks{n,:};
    tempTracks([1:size(tempTracks,1)],1) = n;
    timeSeries = []; timeSeries = (0:0.032:0.032*(size(tempTracks,1)-1))';
    tempTracks(:,4) = timeSeries;
    if size(newTracks,1) == 0
        newTracks = tempTracks;
    else
        newTracks = [newTracks;tempTracks];
    end
end

% export data as .csv
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
