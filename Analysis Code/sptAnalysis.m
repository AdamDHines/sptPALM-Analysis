function [Av_MSD, N2] = sptAnalysis(foldOut,analysisParameters)

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