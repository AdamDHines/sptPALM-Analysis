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

function [Av_MSD,N2] = multCondSPTPALM(folder_name,a,b)
%% sptPALM Analysis Script - Semi-Automated TrackMate Workflow
%%Written by Adam Hines 2018, adam.hines@uq.edu.au Queensland Brain
%%Institute, The University of Queensland, Queensland Australia

%%% SCRIPT REQUIREMENTS %%%

% COMPUTER REQUIREMENTS - TrackMate uses an extensive amount of memory 
% usage, as such the analysis script cannot be run on an udnerpowered 
% comptuer - i.e. anything less than 120gb of memory will cause a java heap 
% error and the script will not run.
% 
% FILE FORMAT -  MUST be a .tif, this is to allow for automated loading into
% the ImageJ-MATLAB instance. Convert any files into .tif before loading
% the script.
%
% FILE NAMING -  the file name is an important component of the script, you
% want to set the file names consistently so MATLAB can appropriately
% select and load the desired files. In this version of the script MATLAB
% looks for '405' and '.tif' to be in the name of the file, e.g. 'B1R1 
% 16000 Frames 405 561nm HILO.tif', however this can be adjusted to
% whatever your needs are.
%
% To edit, open goSearching.m and edit the strings in line 32 to suit your
% needs. It is highly recommended that this is kept consistent otherwise
% you will run into errors.
%
% INITIAL FOLDER - the initial folder is where the dialogue box opens to
% ask which files you want to analyse, change lines 40 and 44 of this
% script to your default directory.
%
% DATA ORGANISATION - the script works by analysing 'experimental days',
% that is a parent folder and subsequent subfolders of data. An example of
% this would be the parent folder of '20180911' and subfolders 'Recording
% 1', 'Recording 2', 'Recording 3', etc containing the actual files to be 
% analysed. To do a single day analysis, you will want to select the parent
% folder and the script will search through the subfolders for analysis
% files. For batch processing of multiple days, select the parent folder of
% the parent folder. E.g. '\Experimental condition 1\20180911\Recording 1'.
% To do the batch processing, you'll select 'Experimental condition 1' and
% it will analyse all experimental dates contained within the folder.
%
% THRESHOLD VALUES - unfortunately, there is no automated threshold
% function available for the spot detection of particles. As such, you will
% need to manually open TrackMate and the imagefile and self determine the
% threshold value for each individual recording. The data MUST be stored as
% a 1xn vector in a .mat file called 'lutThresh.mat' and must contain all
% the threshold values per experimental day, saved within the experimental
% days folder. E.g. lutThresh = [150,120,140,160,120] for an experimental
% day with 5 recordings, each value corresponding to its respective
% recording.

%% Initialisation script

% ask if analysing a single-day or multi-day experiments
eNum = 2;

%% Folder and file searching

% Get file data, check if data exists
if eNum == 1
    
pFold = uigetdir('S:\Swinderen\Adam\Sx1amEos2 Fly Brain'); % get parent folder containing data
sFold = dir(pFold); sFold([1:2],:) = []; % output subfolders
lutFile = fullfile(sFold(1).folder,'\lutThresh.mat');

else
    
    sFold = dir(folder_name{a,:}); sFold([1:2],:) = [];
    
    % get the lutfiles for each folder
    for n = 1:size(sFold,1)
        lutFileAll{n,:} = fullfile(sFold(n).folder,sFold(n).name,'lutThresh.mat');
    end
    
    % treat each subfolder as a new dir
    for n = 1:size(sFold,1)
        
        tempDir = sFold(n).isdir; % check if the subfolders are directories
        
        if tempDir == 1
            flgDir(n,:) = tempDir;
        else
            flgDir(n,:) = 0
        end
        
    end
    rowVal = find(flgDir); % utilise these rows of sFold to find files
end

if eNum == 1
    [fullDataFile, aFold] = goSearching(sFold); % check for existence of data, and output file names
else
    
    for n = 1:size(sFold,1)
        tFold = [];
        tFold = dir(fullfile(sFold(n).folder,'\',sFold(n).name));
        fullDataFold{n,:} = goSearching(tFold);
        bFold{n,:} = tFold; % for use in batch analysis
    end
    
end

%% Waitbar settings

formatSpec = 'Files analysed... %g out of %g';
formatSpec2 = 'Experimental days analysed... %g out of %g';
if eNum == 1
expNumProg = waitbar(0,sprintf(formatSpec,0,size(fullDataFile,1)),'Name','Experiemtn day progress...');
analysisProg = waitbar(0,'Looking for files...','Name','Analysis progress...');
end

%% Data processing

% Single file analysis
if eNum == 1
       
    % generate output directory for .xml results, track coordinates, and 
    % analysis data
    dirSpec = 'Signle analysis %s';
    dirName = sprintf(dirSpec,datetime);
    dirName = strrep(dirName,':','-');
    outPutFold = fullfile(aFold(1).folder,dirName);
    mkdir(aFold(1).folder,dirName);
    
    % output and run file analysis on each individual dataset
    for n = 1:size(fullDataFile,1)
        
        % output file location
        fileAnalyse = []; fileAnalyse = fullDataFile{n,:};
        
        % initialise and run TrackMate analysis, output track X/Y
        % coordinates
        waitbar(0.2,analysisProg,'Initialising and running TrackMate...');
        strName = [];
            tracks{n,:} = runTrackMate(fileAnalyse,lutFile,n,analysisProg,outPutFold);
        
        % format the raw X/Y coordinates to be utilised in the sptAnalysis
        % script
        waitbar(0.8,analysisProg,'Preparing data for analysis...')
            newTracks = []; foldOut = [];
            [newTracks,foldOut] = prepTracks(tracks{n,:},n,outPutFold,fullDataFile);
        
        % analyse and output the average MSD and diffusion coefficient
        % values, filtering out datasets with less than 1,000 tracks
        if size(unique(newTracks(:,1)),1) < 1000
            waitbar(n/size(fullDataFile,1),expNumProg,sprintf(formatSpec,n,size(fullDataFile,1)));
            continue
        else
        waitbar(0.9,analysisProg,'Analysing MSD and D.Coeff...')
            [Av_MSD(:,n), N2(:,n)] = sptAnalysis(foldOut);
        end
        
        % update waitbars to show experiment progress
        waitbar(1,analysisProg,'Done!')
        waitbar(n/size(fullDataFile,1),expNumProg,sprintf(formatSpec,n,size(fullDataFile,1)));
    end
    
        % output MSD and diffusion coefficient values into excel
        % spreadsheet
            %dataOut(Av_MSD,N2,aFold);

% Multi day analysis   
else
    
    % initialise wait bars for multi-day analysis
    h = waitbar(0,sprintf(formatSpec2,0,size(fullDataFold,1)),'Name','Batch processing...');
    analysisProg = waitbar(0,'Looking for files...','Name','Analysis progress...');
    
    % output folder details for the experimental day
    for m = 1:size(fullDataFold,1);
        
        if m > 1
        % update experiment day analysis progress bar
        waitbar((m-1)/size(fullDataFold,1),h,sprintf(formatSpec2,m-1,size(fullDataFold,1)));
        end
        
        % output folder details for the experimental day
        fullDataFile = []; fullDataFile = fullDataFold{m,:};
        
        % initialise the analysis progress bar
        if m == 1
            expNumProg = waitbar(0,sprintf(formatSpec,0,size(fullDataFile,1)),'Name','Analysing particles...');
        else
            waitbar(0,expNumProg,sprintf(formatSpec,0,size(fullDataFile,1)))
        end
        
         % generate output directory for .xml results, track coordinates, and 
        % analysis data
        dirSpec = 'Batch analysis %s';
        dirName = sprintf(dirSpec,datetime);
        dirName = strrep(dirName,':','-');
        outPutFold = []; outPutFold = fullfile(sFold(m).folder,sFold(m).name,dirName);
        mkdir(fullfile(sFold(m).folder,sFold(m).name),dirName);
               
        % once experimental folder output has been called, search for and
        % analyse individual experimental data
        for o = 1:size(fullDataFile,1)
            
            % search for experimental data in subfolders
            waitbar(0,analysisProg,'Looking for files...');
            fileAnalyse = []; fileAnalyse = fullDataFile{o,:};
            
            % load the threshold LUT.mat file
            lutFile = []; lutFile = lutFileAll{m,:};
            
            % initialise and run trackmate analysis
            waitbar(0.2,analysisProg,'Initialising and running TrackMate...');
            tracks{m,o} = runTrackMate(fileAnalyse,lutFile,o,analysisProg,outPutFold,b);
            
            % get the output folder for the batch processed file and
            % prepare the tracks for MSD and D.Coeff analysis
            waitbar(0.8,analysisProg,'Preparing data for analysis...');
            aFold = getFoldersBatch(bFold{m,:});
            newTracks = []; foldOut = [];
            [newTracks,foldOut] = prepTracks(tracks{m,o},o,outPutFold,fullDataFile);
            
            % if the number of tracks detected is less than 1,000, skip the
            % MSD and D.Coeff analysis and do not output any data, else run
            % the MSD and D.Coeff analysis
            if size(unique(newTracks(:,1)),1) < 1000
                waitbar(o/size(fullDataFile,1),expNumProg,sprintf(formatSpec,o,size(fullDataFile,1)));
                continue
            else
                waitbar(0.9,analysisProg,'Analysing MSD and D.Coeff...')
                [Av_MSD{m,o}, N2{m,o}] = sptAnalysis(foldOut);
                waitbar(1,analysisProg,'Done!')
                waitbar(o/size(fullDataFile,1),expNumProg,sprintf(formatSpec,o,size(fullDataFile,1)));                
            end
        end
        
    end
    
    % update experiment number for single day analysis
    if eNum == 1
    waitbar(n/size(fullDataFile,1),expNumProg,sprintf(formatSpec,n,size(fullDataFile,1)));
    end
end

%% Data outputting
% output the MSD and D.Coeff values for each experimental day
if eNum == 1
    save(fullfile(sFold(1).folder,'Av_MSD'),'Av_MSD');
    save(fullfile(sFold(1).folder,'N2'),'N2');
else
    %save(fullfile(sFold(1).folder,'Av_MSD'),'Av_MSD');
    %save(fullfile(sFold(1).folder,'N2'),'N2');
end

%% Script completion

% close waitbars
close(analysisProg)
if eNum == 2
close(h)
end
close(expNumProg)
