function [tracks,spotCountTotal] = runTrackMate(fullDataFile,lutFile,i,g,...
                                          outPutFold,analysisParameters)

% Function runTrackMate takes analysis parameters and image file and feeds
% it through a Miji version of TrackMate. Analysis parameters are mapped
% using Java code. By default, subpixel localisation and median filtering
% is on permanately.
% ----------------
% FUNCTION INPUTS
%
% fullDataFile - Contains image file name and location for loading.
%
% lutFile - Location of the threshold value .m file.
%
% i - Identifier for the threshold value to be used in analysed,
% corresponding to the loop iteration of analysis.
%
% g - Waitbar handle to update analysis progress.
%
% outPutFold - Output location for tracks and spots file.
%
% analysisParameters - Predefined analysis settings for TrackMate.
% ----------------
% FUNCTION OUTPUTS
%
% tracks - Exported tracks from completed analysis, imported from .xml
% file.
%
% strName - Name of the file that was analysed.
%
% Adam Hines - a.david.hines@gmail.com (2019)

% load LUTs
load(lutFile);

% unpack parameters
spotRadius = analysisParameters.SpotRadius;
trackMinimum = analysisParameters.TrackMinimum;
trackMaximum = analysisParameters.TrackMaximum;
maxLink = analysisParameters.MaximumLink;
gapCloseMax = analysisParameters.GapCloseMax;
gapCloseChk = analysisParameters.GapCloseChk;

% add java paths and script folder
javaaddpath 'MIJI\mij.jar';
javaaddpath 'MIJI\ij-1.51n.jar';
addpath 'FIJI\Fiji.app\scripts';
Miji(false);

% Get currently selected image
% imp = ij.IJ.openImage('http://fiji.sc/samples/FakeTracks.tif')
waitbar(0.4,g,'Opening image file...');
imp = ij.ImagePlus(fullDataFile);
      
%----------------------------
% Create the model object now
%----------------------------   
% Some of the parameters we configure below need to have
% a reference to the model at creation. So we create an
% empty model now.
model = fiji.plugin.trackmate.Model();    
% Send all messages to ImageJ log window.
%model.setLogger(fiji.plugin.trackmate.Logger.IJ_LOGGER); 
% convert space units to micron
model.setPhysicalUnits('micron','sec');
%------------------------
% Prepare settings object
%------------------------      
settings = fiji.plugin.trackmate.Settings();
settings.setFrom(imp)
       
% Configure detector - We use a java map
settings.detectorFactory = ...
                      fiji.plugin.trackmate.detection.LogDetectorFactory();
map = java.util.HashMap();
map.put('DO_SUBPIXEL_LOCALIZATION', true);
map.put('RADIUS', spotRadius);
map.put('TARGET_CHANNEL', 1);
map.put('THRESHOLD', lutThresh(:,i));
map.put('DO_MEDIAN_FILTERING', true);
settings.detectorSettings = map;
         
% Configure tracker
settings.trackerFactory  = ...
        fiji.plugin.trackmate.tracking.sparselap.SparseLAPTrackerFactory();
settings.trackerSettings = ...
        fiji.plugin.trackmate.tracking.LAPUtils.getDefaultLAPSettingsMap();
settings.trackerSettings.put('LINKING_MAX_DISTANCE', maxLink);
settings.trackerSettings.put('GAP_CLOSING_MAX_DISTANCE', gapCloseMax);
settings.trackerSettings.put('SPLITTING_MAX_DISTANCE', 0);
settings.trackerSettings.put('MERGING_MAX_DISTANCE', 0);
settings.trackerSettings.put('ALLOW_GAP_CLOSING', gapCloseChk);
settings.trackerSettings.put('ALLOW_TRACK_SPLITTING', false);
settings.trackerSettings.put('ALLOW_TRACK_MERGING', false);
    
% Configure track analyzers - Later on we want to filter out tracks 
% based on their displacement, so we need to state that we want 
% track displacement to be calculated. By default, out of the GUI, 
% not features are calculated. 
    
% The displacement feature is provided by the TrackDurationAnalyzer.
settings.addTrackAnalyzer...
             (fiji.plugin.trackmate.features.track.TrackDurationAnalyzer())
settings.addTrackAnalyzer...
             (fiji.plugin.trackmate.features.track.TrackLocationAnalyzer())
settings.addTrackAnalyzer...
                (fiji.plugin.trackmate.features.track.TrackIndexAnalyzer())  
settings.addTrackAnalyzer...
            (fiji.plugin.trackmate.features.track.TrackBranchingAnalyzer())

% Configure track filters
filter1 = fiji.plugin.trackmate.features.FeatureFilter...
                                   ('NUMBER_SPOTS',trackMinimum+0.1, true);
filter2 = fiji.plugin.trackmate.features.FeatureFilter...
                                     ('NUMBER_SPOTS', trackMaximum, false);
settings.addTrackFilter(filter1);
settings.addTrackFilter(filter2);
    
    
%-------------------
% Instantiate plugin
%-------------------
    
trackmate = fiji.plugin.trackmate.TrackMate(model, settings);
       
%--------
% Process
%--------
waitbar(0.5,g,'Spot detection and track linking...')    
ok = trackmate.checkInput();
if ~ok
    display(trackmate.getErrorMessage())
end
 
ok = trackmate.process();
if ~ok
    display(trackmate.getErrorMessage())
end
waitbar(0.6,g,'Exporting tracks as XML file...') 
% export and load track data
[~,name,~] = fileparts(fullDataFile);
strName = fullfile(outPutFold,name);
fileOut = strcat(strName,'.xml');
file = java.io.File(fileOut);
fiji.plugin.trackmate.action.ExportTracksToXML.export...
                                            (model, settings, file);
waitbar(0.7,g,'Importing track coordinates...') 
tracks = importTrackMateTracks(file);

% get the spot count for the recordings
spotCol = model.getSpots();
stackSize = imp.getImageStackSize() - 1;
for n = 0:stackSize;
    spotCount(n+1,:) = spotCol.getNSpots(n,1);
end

spotCountTotal = sum(spotCount);
        
MIJ.exit;