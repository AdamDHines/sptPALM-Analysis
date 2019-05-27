function [Av_MSD, N2] = sptAnalysis(foldOut,analysisParameters,fullDataFile)

[CorrData, AvgMSD, D, MSD, Ds] = AverageMSDCalculator(foldOut,...
    analysisParameters.TrackMinimum-1,analysisParameters.MSDFitting,...
    analysisParameters.TimeDelta);

for n = 1:size(MSD,2)
    tempMSD= [] ; 
    tempMSD = MSD{:,n};
    sizeTemp = size(tempMSD,1);
    if sizeTemp < 8
        tempMSD([8:10],:) = NaN;
    elseif sizeTemp == 8
        tempMSD([9:10],:) = NaN;
    elseif sizeTemp == 9
        tempMSD(10,:) = NaN;
    end
    MSDFirstTen(:,n) = tempMSD([1:10],:);
end
Av_MSD = nanmean(MSDFirstTen,2);

log10_Ds=log10(Ds);
edges = -5:0.1:1;
N = histcounts(log10_Ds,edges);
%max=max(N);
sumN=sum(N);
N2=N/sumN;
edges(size(edges,2)) = [];
N2=N2';

% output the raw data if the option is selected
outputRaw = analysisParameters.OutputRaw;
if outputRaw == 1
    dirInfo = dir(fullDataFile{1});
    outputDir = dirInfo.folder;
    
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
    [~,dateName,~] = fileparts(outputDir);
    
    % output the MSD data points corresponding to each file name
    msdDataFormat = 'A%d:%s%d';
    for n = 1:size(MSD,2)
        tempMSD = []; tempMSD = MSD{:,n}';
        sizeCol = size(tempMSD,2);
        colVal = xlscol(sizeCol);
        msdDataRange = get(e.ActiveSheet,'Range',sprintf(msdDataFormat,n,colVal,n));
        msdDataRange.Value = tempMSD;
    end
       
    % sheet for diffusion coefficients
    eSheets2 = eSheets.Add([], eSheets.Item(eSheets.Count));
    eSheets2.Activate;
    eSheets2.Select;
    eSheets2.Name = "Diffusion Coefficients";
    
    % input the diffusion coefficient data
    DsDataFormat = 'A%d';
    
    for n = 1:size(Ds,1)
        DsDataRange = get(e.ActiveSheet,'Range',sprintf(DsDataFormat,n));
        DsDataRange.Value = Ds(n,:);
    end
    
    dirSpec = 'Raw Analysis Data %s';
    dirName = sprintf(dirSpec,datetime);
    dirName = strrep(dirName,':','-');
    outPutFold = fullfile(outputDir,dirName);
    mkdir(outputDir,dirName);
    
    fileSaveFormat = 'Raw Analysed Results %s';
    SaveAs(eWorkbook,fullfile(outPutFold,sprintf(fileSaveFormat,dateName)));
    Quit(e);
    delete(e);
end    