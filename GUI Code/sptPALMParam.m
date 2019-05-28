function varargout = sptPALMParam(varargin)
% SPTPALMPARAM MATLAB code for sptPALMParam.fig
%      SPTPALMPARAM, by itself, creates a new SPTPALMPARAM or raises the existing
%      singleton*.
%
%      H = SPTPALMPARAM returns the handle to a new SPTPALMPARAM or the handle to
%      the existing singleton*.
%
%      SPTPALMPARAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPTPALMPARAM.M with the given input arguments.
%
%      SPTPALMPARAM('Property','Value',...) creates a new SPTPALMPARAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sptPALMParam_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sptPALMParam_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sptPALMParam

% Last Modified by GUIDE v2.5 24-May-2019 13:46:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sptPALMParam_OpeningFcn, ...
                   'gui_OutputFcn',  @sptPALMParam_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before sptPALMParam is made visible.
function sptPALMParam_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sptPALMParam (see VARARGIN)

% Choose default command line output for sptPALMParam
handles.output = hObject;

% load the default paramaters
addpath('Analysis Parameters\Defaults');
load('defaultParameters');

% set the GUI with default values
set(handles.spotRad,'String',defaultParameters.DefaultSpotRadius);
set(handles.trackMin,'String',defaultParameters.DefaultTrackMinimum);
set(handles.trackMax,'String',defaultParameters.DefaultTrackMaximum);
set(handles.maxLink,'String',defaultParameters.DefaultMaxLinking);
set(handles.msdFitBox,'String',defaultParameters.DefaultMSDFitting);
set(handles.deltaTimeBox,'String',defaultParameters.DefaultTimeDelta);
set(handles.miCutoffBox,'String',defaultParameters.DefaultMobImmobCutoff);
set(handles.gapCloseMax,'String',defaultParameters.DefaultGapClosing);

% set final parameter values to 0
handles.spotRadius = 0;
handles.trackMinimum = 0;
handles.trackMaximum = 0;
handles.maxLinking = 0;
handles.msdFit = 0;
handles.deltaTime = 0;
handles.miCutoff = 0;
handles.fileDir = 0;
handles.gapClose = 0;
handles.gapCloseCheck = 0;

% Update handles structure
handles.defaultParameters = defaultParameters;
    guidata(hObject, handles);

% UIWAIT makes sptPALMParam wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sptPALMParam_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function fileDirT_Callback(hObject, eventdata, handles)
% hObject    handle to fileDirT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileDirT as text
%        str2double(get(hObject,'String')) returns contents of fileDirT as a double


% --- Executes during object creation, after setting all properties.
function fileDirT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileDirT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function setFileDir_Callback(hObject, eventdata, handles)
% hObject    handle to setFileDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dFileDirectory = handles.defaultParameters.DefaultFileDirectory;
if isempty(dFileDirectory) == 1
    flgSet = questdlg('Default file directory does not exist. Would you like to set one now?',...
        'Default Directory Not Set','Yes','No','Yes');
    if isequal(flgSet,'Yes')
        setDefDir = uigetdir();
        defaultParameters = handles.defaultParameters;
        defaultParameters.DefaultFileDirectory = setDefDir;
        save('Analysis Parameters\Defaults\defaultParameters.mat',defaultParameters);
        return
    else
        fileDir = uigetdir();
    
    if isequal(fileDir,0)
        set(handles.fileDirT,'String','Set file directory...');
        return
    end
    end
else
    fileDir = uigetdir(dFileDirectory);
    
    if isequal(fileDir,0)
        set(handles.fileDirT,'String','Set file directory...');
        return
    end
end
set(handles.fileDirT,'String',fileDir);
handles.fileDir = fileDir;
    guidata(hObject, handles);
    
% --- Executes on button press in setFileDirBut.
function setFileDirBut_Callback(hObject, eventdata, handles)
% hObject    handle to setFileDirBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dFileDirectory = handles.defaultParameters.DefaultFileDirectory;
if isempty(dFileDirectory) == 1
    flgSet = questdlg('Default file directory does not exist. Would you like to set one now?',...
        'Default Directory Not Set','Yes','No','Yes');
    if isequal(flgSet,'Yes')
        setDefDir = uigetdir();
        defaultParameters = handles.defaultParameters;
        defaultParameters.DefaultFileDirectory = setDefDir;
        save('Analysis Parameters\Defaults\defaultParameters.mat',defaultParameters);
        return
    else
          fileDir = uigetdir();
    
    if isequal(fileDir,0)
        set(handles.fileDirT,'String','Set file directory...');
        return
    end
    end
else
    fileDir = uigetdir(dFileDirectory);
    
    if isequal(fileDir,0)
        set(handles.fileDirT,'String','Set file directory...');
        return
    end
end
set(handles.fileDirT,'String',fileDir);
handles.fileDir = fileDir;
    guidata(hObject, handles);
function spotRad_Callback(hObject, eventdata, handles)
% hObject    handle to spotRad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spotRad as text
%        str2double(get(hObject,'String')) returns contents of spotRad as a double
spotRadius = str2double(get(hObject,'String'));
handles.spotRadius = spotRadius;
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function spotRad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spotRad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trackMin_Callback(hObject, eventdata, handles)
% hObject    handle to trackMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trackMin as text
%        str2double(get(hObject,'String')) returns contents of trackMin as a double
trackMinimum = str2double(get(hObject,'String'));
handles.trackMinimum = trackMinimum;
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function trackMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trackMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trackMax_Callback(hObject, eventdata, handles)
% hObject    handle to trackMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trackMax as text
%        str2double(get(hObject,'String')) returns contents of trackMax as a double
trackMaximum = str2double(get(hObject,'String'));
handles.trackMaximum = trackMaximum;
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function trackMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trackMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxLink_Callback(hObject, eventdata, handles)
% hObject    handle to maxLink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxLink as text
%        str2double(get(hObject,'String')) returns contents of maxLink as a double
maxLinking = str2double(get(hObject,'String'));
handles.maxLinking = maxLinking;
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function maxLink_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxLink (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in singleAnalysisChk.
function singleAnalysisChk_Callback(hObject, eventdata, handles)
% hObject    handle to singleAnalysisChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of singleAnalysisChk
set(handles.multiAnalysisChk,'value',0);

% --- Executes on button press in multiAnalysisChk.
function multiAnalysisChk_Callback(hObject, eventdata, handles)
% hObject    handle to multiAnalysisChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of multiAnalysisChk
set(handles.singleAnalysisChk,'value',0);

% --- Executes on button press in sptPALMDef.
function sptPALMDef_Callback(hObject, eventdata, handles)
% hObject    handle to sptPALMDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

defaultParameters = handles.defaultParameters;

% set the GUI with default values
set(handles.spotRad,'String',defaultParameters.DefaultSpotRadius);
set(handles.trackMin,'String',defaultParameters.DefaultTrackMinimum);
set(handles.trackMax,'String',defaultParameters.DefaultTrackMaximum);
set(handles.maxLink,'String',defaultParameters.DefaultMaxLinking);

% set final parameter values to 0
handles.spotRadius = 0;
handles.trackMinimum = 0;
handles.trackMaximum = 0;
handles.maxLinking = 0;

function msdFitBox_Callback(hObject, eventdata, handles)
% hObject    handle to msdFitBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msdFitBox as text
%        str2double(get(hObject,'String')) returns contents of msdFitBox as a double
msdFit = str2double(get(hObject,'String'));
handles.msdFit = msdFit;
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function msdFitBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msdFitBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaTimeBox_Callback(hObject, eventdata, handles)
% hObject    handle to deltaTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaTimeBox as text
%        str2double(get(hObject,'String')) returns contents of deltaTimeBox as a double
deltaTime = str2double(get(hObject,'String'));
handles.deltaTime = deltaTime;
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function deltaTimeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function miCutoffBox_Callback(hObject, eventdata, handles)
% hObject    handle to miCutoffBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of miCutoffBox as text
%        str2double(get(hObject,'String')) returns contents of miCutoffBox as a double
miCutoff = str2double(get(hObject,'String'));
handles.miCutoff = miCutoff;
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function miCutoffBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to miCutoffBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in processDef.
function processDef_Callback(hObject, eventdata, handles)
% hObject    handle to processDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

defaultParameters = handles.defaultParameters;

% reset text boxes
set(handles.msdFitBox,'String',defaultParameters.DefaultMSDFitting);
set(handles.deltaTimeBox,'String',defaultParameters.DefaultTimeDelta);
set(handles.miCutoffBox,'String',defaultParameters.DefaultMobImmobCutoff);

% reset final values
handles.msdFit = 0;
handles.deltaTime = 0;
handles.miCutoff = 0;

% --- Executes on button press in gapCloseChk.
function gapCloseChk_Callback(hObject, eventdata, handles)
% hObject    handle to gapCloseChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gapCloseChk
gapCloseChk = str2double(get(hObject,'String'));
handles.gapCloseChk = gapCloseChk;
    guidata(hObject, handles);


function gapCloseMax_Callback(hObject, eventdata, handles)
% hObject    handle to gapCloseMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gapCloseMax as text
%        str2double(get(hObject,'String')) returns contents of gapCloseMax as a double
gapClose = str2double(get(hObject,'String'));
handles.gapClose = gapClose;
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function gapCloseMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gapCloseMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in OutputRaw.
function OutputRaw_Callback(hObject, eventdata, handles)
% hObject    handle to OutputRaw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OutputRaw
outputRaw = get(hObject,'Value');
handles.outputRaw = outputRaw;
    guidata(hObject, handles);

% SETTING THE THRESHOLD VALUES

% --- Executes on button press in SetThresholdVals.
function SetThresholdVals_Callback(hObject, eventdata, handles)
% hObject    handle to SetThresholdVals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    if handles.fileDir == 0;
        errordlg('Please select a file directory before setting threshold values.');
    else
        fileDir = handles.fileDir;
        setThresholdVals(fileDir);
    end
end

% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4

% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% update the file directory
if isequal(handles.fileDir,0)
    warndlg('Please select a file directory for analysis.');
    return
else
    fileDir = handles.fileDir;
end

% check if single or multi-day analysis (single is the default)
singleChk = get(handles.singleAnalysisChk,'value');
multiChk = get(handles.multiAnalysisChk,'value');
if isequal(singleChk,1)
    eNum = 1;
elseif isequal(multiChk,1)
    eNum = 2;
else
    warndlg('Please select single or multi-day experiment.')
    return
end

% restate the default parameters
defaultParameters = handles.defaultParameters;

% check for existence of updated parameters, set to default if non
% existent
% spot radius check
if isequal(handles.spotRadius,0)
    spotRadius = defaultParameters.DefaultSpotRadius;
else
    spotRadius = handles.spotRadius;
end
% track minimum check
if isequal(handles.trackMinimum,0)
    trackMinimum = defaultParameters.DefaultTrackMinimum;
else
    trackMinimum = handles.trackMinimum;
end
% track maximum check
if isequal(handles.trackMaximum,0)
    trackMaximum = defaultParameters.DefaultTrackMaximum;
else
    trackMaximum = handles.trackMaximum;
end
% max linking distance check
if isequal(handles.maxLinking,0)
    maxLinking = defaultParameters.DefaultMaxLinking;
else
    maxLinking = handles.maxLinking;
end
% MSD fitting check
if isequal(handles.msdFit,0)
    msdFit = defaultParameters.DefaultMSDFitting;
else
    msdFit = handles.msdFit;
end
% Time delta check
if isequal(handles.deltaTime,0)
    deltaTime = defaultParameters.DefaultTimeDelta;
else
    deltaTime = handles.deltaTime;
end
% Mob Immob cutoff check
if isequal(handles.miCutoff,0)
    miCutoff = defaultParameters.DefaultMobImmobCutoff;
else
    miCutoff = handles.miCutoff;
end
% Gap closing max check
if isequal(handles.gapClose,0)
    gapClose = defaultParameters.DefaultGapClosing;
else
    gapClose = handles.gapClose;
end
% Gap closing check
if isequal(handles.gapCloseCheck,0)
    gapCloseChk = false;
else
    gapCloseChk = true;
end
% Split file check
splitFileCheck = get(handles.radiobutton4,'value');
% Raw data check
rawdataCheck = get(handles.OutputRaw,'value');

% update analysis parameter to .mat file
analysisParameters = struct('FileDirectory',fileDir,'SpotRadius',spotRadius,...
    'TrackMinimum',trackMinimum,'TrackMaximum',trackMaximum,...
    'MaximumLink',maxLinking,'eNum',eNum,'MSDFitting',msdFit,...
    'TimeDelta',deltaTime,'MobImmobCutoff',miCutoff,'GapCloseMax',gapClose,...
    'GapCloseChk',gapCloseChk, 'SplitFile',splitFileCheck,'OutputRaw',...
    rawdataCheck);

% run the analysis script
sptPALM(analysisParameters);


% MENU ITEMS

% --------------------------------------------------------------------
function settings_Callback(hObject, eventdata, handles)
% hObject    handle to settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function setAnalysisDef_Callback(hObject, eventdata, handles)
% hObject    handle to setAnalysisDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('Analysis Parameters');
setDefaults;

% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function analysis_Callback(hObject, eventdata, handles)
% hObject    handle to analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function dataVis_Callback(hObject, eventdata, handles)
% hObject    handle to dataVis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function File_Preparation_Callback(hObject, eventdata, handles)
% hObject    handle to File_Preparation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataPrep;
