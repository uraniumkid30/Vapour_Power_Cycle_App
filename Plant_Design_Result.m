function varargout = Plant_Design_Result(varargin)
% PLANT_DESIGN_RESULT MATLAB code for Plant_Design_Result.fig
%      PLANT_DESIGN_RESULT, by itself, creates a new PLANT_DESIGN_RESULT or raises the existing
%      singleton*.
%
%      H = PLANT_DESIGN_RESULT returns the handle to a new PLANT_DESIGN_RESULT or the handle to
%      the existing singleton*.
%
%      PLANT_DESIGN_RESULT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLANT_DESIGN_RESULT.M with the given input arguments.
%
%      PLANT_DESIGN_RESULT('Property','Value',...) creates a new PLANT_DESIGN_RESULT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Plant_Design_Result_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Plant_Design_Result_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Plant_Design_Result

% Last Modified by GUIDE v2.5 31-Oct-2018 12:42:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plant_Design_Result_OpeningFcn, ...
                   'gui_OutputFcn',  @Plant_Design_Result_OutputFcn, ...
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
% --- Executes just before Plant_Design_Result is made visible.
function Plant_Design_Result_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Plant_Design_Result (see VARARGIN)

% Choose default command line output for Plant_Design_Result
handles.output = hObject;
ha = axes('units','normalized', ...
            'position',[0 0 1 1]);
% Move the background axes to the bottom
uistack(ha,'bottom');
% Load in a background image and display it using the correct colors
% The image used below, is in the Image Processing Toolbox.  If you do not have %access to
I=imread('bgg4.png');
hi = imagesc(I);
colormap gray
% Turn the handlevisibility off so that we don't inadvertently plot into the axes again
% Also, make the axes invisible
set(ha,'handlevisibility','off', ...
            'visible','off')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Plant_Design_Result wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Plant_Design_Result_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in switchchartbutton.
function switchchartbutton_Callback(hObject, eventdata, handles)
% hObject    handle to switchchartbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in closebutton.
function closebutton_Callback(hObject, eventdata, handles)
% hObject    handle to closebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.Plant_Layout_data2.Plant_Component_Variables);  % close GUI-2 
handles.login = login;
delete(get(hObject,'parent'))


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%delete(hObject);
warndlg('Please click Close Application button','!! Warning !!')
