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

function [CorrData, AvgMSD, D, MSD, Ds] = AverageMSDCalculator(strFolderName,AvgPoints,FittingPoints,IntTime)

% import Track mate file located at strFolderName

data = xlsread(strFolderName);

% Split the traces

    tt=0;
    xx=0;
    yy=0;

    Track_ID=data(:,1); %Imports ID column
    xx=data(:,2); %Imports x0 column
    yy=data(:,3); %Imports y0 column
    tt=data(:,4); %Imports time column
    
    Track_ID2=unique(Track_ID);
    
    kk=0;
    ll=1;
    Track=Track_ID2(ll);
    for jj=1:length(xx)
         if Track_ID(jj)==Track     % Check that track_ID hasn't changed
             kk=kk+1;               % Row of new XX vector 
             CorrData{ll}(kk,1)=tt(jj);     % New TT vector
             CorrData{ll}(kk,2)=xx(jj);     % New XX vector
             CorrData{ll}(kk,3)=yy(jj);     % New YY vector
         else
             kk=0;                  % Go to start of new vector
             ll=ll+1;
             Track=Track_ID2(ll);   % Find new track ID
         end
    end
    TrackID=Track_ID2;
     
% Calculate MSD for each trace    

    tt=0;
    xx=0;
    yy=0;

    for ii=1:length(CorrData)
        MSD{ii}=0;
        tt=CorrData{ii}(:,1);
        xx=CorrData{ii}(:,2);
        yy=CorrData{ii}(:,3);
        for lagt=1:length(tt) - 1
            SD=0;
            MSD{ii}(lagt)=0;
            noPoints=0;     % Number of values taken at each lag time
            for jj=1:length(xx)-lagt
                if xx(jj)~=-1 && xx(jj+lagt)~=-1
                    noPoints=noPoints+1;
                    SD=SD+(xx(jj+lagt)-xx(jj))^2+(yy(jj+lagt)-yy(jj))^2;
           
                end
            end
    
            MSD{ii}(lagt)=SD/noPoints; 
    
        end
        MSD{ii}=MSD{ii}';
    end
   
    
% Calculate the Average MSD

    ll=0;
    for ii=1:length(MSD);
        ll=ll+1;
        MSDs(ll,1:AvgPoints)=MSD{ii}(1:AvgPoints);
    end
    AvgMSD(1,:)=mean(MSDs,1);
    AvgMSD(2,:)=std(MSDs,1);
    AvgMSD(3,:)=std(MSDs,1)/sqrt(length(jj));
    AvgMSD=AvgMSD';
    
% Perform linear fitting to each MSD curve and the Average

    MSDTime=IntTime:IntTime:(IntTime*FittingPoints);
    for ii=1:length(TrackID)
        if length(MSD{ii}) >= FittingPoints
            FittingParameters(ii,:)=polyfit(MSDTime',MSD{ii}(1:FittingPoints),1);
        end
    end
    AveFittingParameters=polyfit(MSDTime',AvgMSD(1:FittingPoints,1),1);
    
 % Calculate dispersion coeeficient
  
    NonNegative=find(FittingParameters(:,1) > 0); % Finds the traces thaty have non-negative slopes
    Ds=(FittingParameters(NonNegative,1))/4;
    logDs=sort(log10(Ds));         % Log10 of the non-negative values
    SortedDs=sort(Ds);
    D=AveFittingParameters/4;

end
