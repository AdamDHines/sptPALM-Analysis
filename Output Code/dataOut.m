function dataOut(Av_MSD,N2,folderOut,analysisParameters,fullDataFile)

% format data for outputting


e = actxserver('Excel.Application');
eWorkbook = e.Workbooks.Add;
eSheets = e.ActiveWorkbook.Sheets;

% sheet for MSD values
eSheet1 = eSheets.get('Item',1);
eSheet1.Activate;
fileNameFormat = 'A%d:A%d';
cellFormat = 'A%d'; % to format the columns to the size of the text
eSheet1.Select;
eSheet1.Name = "MSD"; % format the name of the sheet
[~,dateName,~] = fileparts(folderOut);
eDateNameRange = get(e.Activesheet,'Range','A1');
eDateNameRange.Value = dateName;
e.Range('A1').Select;
e.Selection.Font.UnderLine = 2;

% set the timing values
timeSeries = analysisParameters.TimeDelta:analysisParameters.TimeDelta:...
    analysisParameters.TimeDelta*10;
timeSeriesRange = get(e.Activesheet,'Range','B1:K1');
timeSeriesRange.Value = timeSeries;

% output the file names to the excel sheet
for n = 1:size(fullDataFile,1)
    fileName = [];
    [~,fileName,~] = fileparts(fullDataFile{n,:});
    eFileNameSheetRange = get(e.Activesheet,'Range',sprintf(fileNameFormat,n+2,n+2));
    eFileNameSheetRange.Value = fileName;
    e.Range(sprintf(cellFormat,n+2)).Select; % select columns for formatting
    e.Selection.Columns.AutoFit; % autofit the text width
end

% output the MSD data points corresponding to each file name
Av_MSDhor = Av_MSD';
msdDataFormat = 'B%d:K%d';
for n = 1:size(Av_MSDhor,1)
    msdDataRange = get(e.ActiveSheet,'Range',sprintf(msdDataFormat,n+2,n+2));
    msdDataRange.Value = Av_MSDhor(n,:);
end

% calculate the area under the curve


% sheet for diffusion coefficients
eSheets2 = eSheets.Add([], eSheets.Item(eSheets.Count));
eSheets2.Activate;
eSheets2.Select;
eSheets2.Name = "Diffusion Coefficients";
eDateNameRange = get(e.Activesheet,'Range','A1');
eDateNameRange.Value = dateName;
e.Range('A1').Select;
e.Selection.Font.UnderLine = 2;

% output the file names to the excel sheet
for n = 1:size(fullDataFile,1)
    fileName = [];
    [~,fileName,~] = fileparts(fullDataFile{n,:});
    eFileNameSheetRange = get(e.Activesheet,'Range',sprintf(fileNameFormat,n+2,n+2));
    eFileNameSheetRange.Value = fileName;
    e.Range(sprintf(cellFormat,n+2)).Select; % select columns for formatting
    e.Selection.Columns.AutoFit; % autofit the text width
end

% log diffusion bins
diffusionBins = -5:0.1:1;
diffusionBinRange = get(e.ActiveSheet,'Range','B1:BJ1');
diffusionBinRange.Value = diffusionBins;

% input the diffusion coefficient data
N2hor = N2';
n2DataFormat = 'B%d:BJ%d';
for n = 1:size(N2hor,1)
    n2DataRange = get(e.ActiveSheet,'Range',sprintf(n2DataFormat,n+2,n+2));
    n2DataRange.Value = N2hor(n,:);
end

% final sheet for analysis parameters
eSheets3 = eSheets.Add([], eSheets.Item(eSheets.Count));
eSheets3.Activate;
eSheets3.Select;
eSheets3.Name = "Analysis Parameters";
eDateNameRange = get(e.Activesheet,'Range','A1');
eDateNameRange.Value = dateName;
e.Range('A1').Select;
e.Selection.Font.UnderLine = 2;
e.Selection.Columns.AutoFit;

% set analysis parameters headings
paramFormat = 'A%d';
paramValueRangeForm = 'B%d';
paramValueFormat = '%s';
fieldNames = fieldnames(analysisParameters);
for n = 1:size(fieldNames,1)
    eFileNameSheetRange = get(e.Activesheet,'Range',sprintf(paramFormat,n+2));
    eFileNameSheetRange.Value = fieldNames{n,:};
    paramValueRange = get(e.Activesheet,'Range',sprintf(paramValueRangeForm,n+2));
    paramValueRange.Value = analysisParameters.(sprintf(paramValueFormat,fieldNames{n,:}));
end

fileSaveFormat = 'Analysed %s';
SaveAs(eWorkbook,fullfile(folderOut,sprintf(fileSaveFormat,dateName)));
Quit(e);
delete(e);