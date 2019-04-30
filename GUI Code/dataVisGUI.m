function varargout = dataVisGUI(varargin)
% DATAVISGUI MATLAB code for dataVisGUI.fig
%      DATAVISGUI, by itself, creates a new DATAVISGUI or raises the existing
%      singleton*.
%
%      H = DATAVISGUI returns the handle to a new DATAVISGUI or the handle to
%      the existing singleton*.
%
%      DATAVISGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATAVISGUI.M with the given input arguments.
%
%      DATAVISGUI('Property','Value',...) creates a new DATAVISGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dataVisGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dataVisGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dataVisGUI

% Last Modified by GUIDE v2.5 27-Nov-2018 11:33:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dataVisGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @dataVisGUI_OutputFcn, ...
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


% --- Executes just before dataVisGUI is made visible.
function dataVisGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dataVisGUI (see VARARGIN)

% Choose default command line output for dataVisGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dataVisGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dataVisGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in fileList.
function fileList_Callback(hObject, eventdata, handles)
% hObject    handle to fileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns fileList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fileList
handles.output = hObject;
exlData = handles.exlData;
index = get(handles.fileList,'value');
data = []; data = exlData{index,:};
dataMat = []; dataMat = cell2mat(data);
dataMat(:,[5:7]) = [];
[C,ia,ib] = unique(dataMat(:,1));

cla('reset');

hold all
for n = 1:size(ia,1)-1
    plot(dataMat([ia(n,:):ia(n+1,:)-1],2),dataMat([ia(n,:):ia(n+1,:)-1],3))
end
hold off

set(handles.figAxes,'YLim',[0,25.6])
set(handles.figAxes,'XLim',[0,25.6])

% --- Executes during object creation, after setting all properties.
function fileList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function fileSelect_Callback(hObject, eventdata, handles)
% hObject    handle to fileSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
foldName = uigetdir('S:\Swinderen\Adam\Sx1amEos2 Fly Brain');
foldContents = dir(foldName); foldContents([1:2],:) = [];
for n = 1:size(foldContents,1)
    tempName = []; tempName = foldContents(n).name;
    flg(n,:) = contains(tempName,'.xlsx');
end
rowKeep = find(flg); fileNames = foldContents(rowKeep,:);
handles.fileNames = fileNames; 
set(handles.fileList,'string',{fileNames.name})
exl = actxserver('excel.application');
exlWkbk = exl.Workbooks;
% load in the datasets
for n = 1:size(fileNames,1)
    exlFile = exlWkbk.Open(fullfile(foldName,fileNames(n).name));
    exlSheet1 = exlFile.Sheets.Item('Sheet1');
    robj = exlSheet1.Columns.End(4);
    numrows = robj.row;
    dat_range = ['A1:G' num2str(numrows)];
    rngObj = exlSheet1.Range(dat_range);
    exlData{n,:} = rngObj.Value;
end
handles.exlData = exlData;
exlWkbk.Close; exl.Quit;
    guidata(hObject,handles);
    
