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

function varargout = dataPrep(varargin)
% DATAPREP MATLAB code for dataPrep.fig
%      DATAPREP, by itself, creates a new DATAPREP or raises the existing
%      singleton*.
%
%      H = DATAPREP returns the handle to a new DATAPREP or the handle to
%      the existing singleton*.
%
%      DATAPREP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATAPREP.M with the given input arguments.
%
%      DATAPREP('Property','Value',...) creates a new DATAPREP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dataPrep_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dataPrep_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dataPrep

% Last Modified by GUIDE v2.5 19-Mar-2019 13:50:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dataPrep_OpeningFcn, ...
                   'gui_OutputFcn',  @dataPrep_OutputFcn, ...
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


% --- Executes just before dataPrep is made visible.
function dataPrep_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dataPrep (see VARARGIN)

% Choose default command line output for dataPrep
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dataPrep wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dataPrep_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in FileDir.
function FileDir_Callback(hObject, eventdata, handles)
% hObject    handle to FileDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileDir = uigetdir();
handles.fileDir = fileDir;
    guidata(hObject, handles);


% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% restate the selected file directory
fileDir = handles.fileDir;
sFold = dir(fileDir);

% find specific files in subfolders
% check for the existence of 405 + 561nm recordings in sub-folders
for n=1:size(sFold,1)
    tempDir = [];
    tempDir = dir(fullfile(sFold(n).folder,'\',sFold(n).name));
    for m=1:size(tempDir,1)
        if strfind(tempDir(m).name,'.czi') > 0
            dataFound(m,n) = 1;
        else
            dataFound(m,n) = 0;
        end
    end
    sumFound = sum(dataFound(:,n));
    if sumFound > 0
        useFold(n,:) = 1;
    else
        useFold(n,:) = 0;
    end
end

% eliminate datasets that didn't have 405 and 561 nm recordings
aFold = sFold(find(useFold),:);

% output data file names
for n=1:size(aFold,1)
    tempDir = [];
    tempDir = fullfile(aFold(n).folder,'\',aFold(n).name);
    tempDirFiles = dir(tempDir);
    dataSelect = [];
    for m=1:size(tempDirFiles,1)
        if strfind(tempDirFiles(m).name,'405') > 0 & strfind(tempDirFiles(m).name,'.czi') > 0
            dataSelect(m,:) = 1;
        else
            dataSelect(m,:) = 0;
        end
    end
    dataRow = [];
    dataRow = find(dataSelect);
    if size(dataRow,1) > 1
        continue
    else
        fullDataFile{n,:} = fullfile(tempDirFiles(dataRow).folder,'\',tempDirFiles(dataRow).name);
    end
end
fullDataFile(~cellfun('isempty',fullDataFile)); % eliminate empty arrays

% initialise Fiji
javaaddpath 'MIJI\mij.jar';
javaaddpath 'MIJI\ij-1.51n.jar';
addpath 'FIJI\Fiji.app\scripts';
Miji(true);
