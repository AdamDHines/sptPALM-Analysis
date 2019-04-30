function [newTracks,foldOut] = prepTracks(tracks,i,outPutFold,fullDataFile)

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
eActivesheetRange = get(e.Activesheet,'Range',sprintf('A1:D%g',size(newTracks,1)));
eActivesheetRange.Value = newTracks;
[~,name,~] = fileparts(fullDataFile{i,:});
formatFile = 'Track coordinates %s';
foldOut = fullfile(outPutFold,sprintf(formatFile,name));
SaveAs(eWorkbook,foldOut);
Quit(e);
delete(e);
