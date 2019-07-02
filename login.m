function varargout = login(varargin)
% LOGIN MATLAB code for login.fig
%      LOGIN, by itself, creates a new LOGIN or raises the existing
%      singleton*.
%
%      H = LOGIN returns the handle to a new LOGIN or the handle to
%      the existing singleton*.
%
%      LOGIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOGIN.M with the given input arguments.
%
%      LOGIN('Property','Value',...) creates a new LOGIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before login_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to login_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help login

% Last Modified by GUIDE v2.5 09-Aug-2018 13:06:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @login_OpeningFcn, ...
                   'gui_OutputFcn',  @login_OutputFcn, ...
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


% --- Executes just before login is made visible.
function login_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;
    % This creates the 'background' axes
    ha = axes('units','normalized', ...
            'position',[0 0 1 1]);
    % Move the background axes to the bottom
    uistack(ha,'bottom');
    % Load in a background image and display it using the correct colors

    I=imread('login1.png');
    hi = imagesc(I);
    colormap gray
    % Turn the handlevisibility off so that we don't inadvertently plot into the axes again
    % Also, make the axes invisible
    set(ha,'handlevisibility','off', ...
            'visible','off')
    userr = load('userprofile.mat');
    userr = userr.user;
    handles.userr=userr;
    handles.usernamee='';
    handles.Plant_Layout_handle=[];
    guidata(hObject, handles);

% UIWAIT makes login wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = login_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function username_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of username as text
%        str2double(get(hObject,'String')) returns contents of username as a double
    handles.usernamee=get(hObject,'String');
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function username_CreateFcn(hObject, eventdata, handles)
% hObject    handle to username (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in register.
function register_Callback(hObject, eventdata, handles)
    % this registers a user so access can be granted
    prompt={'First Name: ','Last Name: ',...
        'Email ','Username: ','Password: ',...
        'Confirm Password: ',};
    defaultanswer={'','','','','','',};
    flds = ['First Name Field','Last Name Field','Email Field',...
            'Password Field','confirm Password Field'];
    name='User Registration Panel';
    numlines=1;

    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
 
    answer=inputdlg(prompt,name,numlines,defaultanswer,options);
    lastname=answer{2,1};
    email=answer{3,1};
    usernamea=answer{4,1};
    password=answer{5,1};
    password2=answer{6,1};

    if isempty(answer)
        errordlg('You didnt succeed in registering')
    else
        [a1,~] = size(answer);
        for i = 1:a1
            if isempty(answer{i,1})
                errordlg('you have some missing ')
                pp=0;
                break
            else
                pp=1;
            end
        end
        if pp
            if isfield(handles.userr,usernamea)
                errordlg('That username already exists')
            elseif ~strcmp(password,password2)
                errordlg('Password mismatch')
            else
                hh=msgbox('PLEASE WAIT WHILE WE REGISTER YOU');
                user=handles.userr;
                user = setfield(user,usernamea,password);
                save 'userprofile.mat' user
                handles.userr = user;
                guidata(hObject, handles);
                uiwait(hh,3)
                delete(hh)
                msgbox(sprintf('SUCCESSFUL REGISTRATION \n PLEASE LOGIN'))
            end
        end
    end
% --- Executes on button press in login.
function login_Callback(hObject, eventdata, handles)

   if isempty(handles.usernamee)
        errordlg('Please input a user name')
    else
        if isfield(handles.userr,handles.usernamee)
            p=getfield(handles.userr,handles.usernamee);
            if strcmp(p,handles.pword)
                
                if isempty(handles.Plant_Layout_handle)
                    hh=msgbox('SUCCESSFUL LOGIN');
                    uiwait(hh,3)
                    delete(hh)
                    handles.Plant_Layout_handle=Plant_Layout;
                    Plant_Layout_data = guidata(handles.Plant_Layout_handle);
                    % Plant_Layout_data is a struct data
                    %Plant_Layout_data
                    Plant_Layout_data.login_handle = get(hObject,'parent');
                    guidata(handles.Plant_Layout_handle,Plant_Layout_data);
                    guidata(get(hObject,'parent'),handles);
                    set(Plant_Layout_data.dispname,'string',['Welcome',' ',handles.usernamee]);
                    delete(get(hObject, 'parent'));
                end
            else
                errordlg('Password Missmatch')
            end
        else
            errordlg('That user name doesnt exist')
        end
    end 





function pword_Callback(hObject, eventdata, handles)
% hObject    handle to pword (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pword as text
%        str2double(get(hObject,'String')) returns contents of pword as a double
    handles.pword=get(hObject,'String');
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pword_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pword (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
