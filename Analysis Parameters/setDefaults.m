function varargout = setDefaults(varargin)
% SETDEFAULTS MATLAB code for setDefaults.fig
%      SETDEFAULTS, by itself, creates a new SETDEFAULTS or raises the existing
%      singleton*.
%
%      H = SETDEFAULTS returns the handle to a new SETDEFAULTS or the handle to
%      the existing singleton*.
%
%      SETDEFAULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETDEFAULTS.M with the given input arguments.
%
%      SETDEFAULTS('Property','Value',...) creates a new SETDEFAULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before setDefaults_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to setDefaults_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help setDefaults

% Last Modified by GUIDE v2.5 16-Jan-2019 15:44:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @setDefaults_OpeningFcn, ...
                   'gui_OutputFcn',  @setDefaults_OutputFcn, ...
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


% --- Executes just before setDefaults is made visible.
function setDefaults_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to setDefaults (see VARARGIN)

% Choose default command line output for setDefaults
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes setDefaults wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = setDefaults_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
