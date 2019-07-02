function varargout = Plant_Layout(varargin)
%Plant_Layout MATLAB code file for Plant_Layout.fig
%      Plant_Layout, by itself, creates a new Plant_Layout or raises the existing
%      singleton*.
%
%      H = Plant_Layout returns the handle to a new Plant_Layout or the handle to
%      the existing singleton*.
%
%      Plant_Layout('Property','Value',...) creates a new Plant_Layout using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to Plant_Layout_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      Plant_Layout('CALLBACK') and Plant_Layout('CALLBACK',hObject,...) call the
%      local function named CALLBACK in Plant_Layout.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Plant_Layout

% Last Modified by GUIDE v2.5 24-Jun-2019 15:21:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plant_Layout_OpeningFcn, ...
                   'gui_OutputFcn',  @Plant_Layout_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before Plant_Layout is made visible.
function Plant_Layout_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for Plant_Layout
    handles.output = hObject;
    set(handles.type_of_feedheater,'String',['OPEN|CLOSE'])
    handles.steameng = cell(7,1);
    handles.Plant_Component_Variables_handle = [];
    % Update handles structure
    superheat_mdata=load('supcell.mat');
    handles.superheat_data=superheat_mdata.supercell;
    saturated_mdata=load('satcell.mat');
    handles.saturated_data=saturated_mdata.sattycell;
    tdata = cell(40,10);
    set(handles.uitable1,'Data',tdata);
    guidata(hObject, handles);

% UIWAIT makes Plant_Layout wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Plant_Layout_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in boiler_comp.
function boiler_comp_Callback(hObject, eventdata, handles)
% hObject    handle to boiler_comp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns boiler_comp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from boiler_comp

        

% --- Executes during object creation, after setting all properties.
function boiler_comp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boiler_comp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function no_of_turbines_Callback(hObject, eventdata, handles)
% hObject    handle to no_of_turbines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of no_of_turbines as text
%        str2double(get(hObject,'String')) returns contents of no_of_turbines as a double


input1 = str2double(get(handles.no_of_turbines,'String'));
handles.input1=input1;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function no_of_turbines_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no_of_turbines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in evaluatebutton.
function evaluatebutton_Callback(hObject, eventdata, handles)
% hObject    handle to evaluatebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
no_of_turbinesv = str2double(get(handles.no_of_turbines,'String'));
type_of_feedheaterv = get(handles.type_of_feedheater,'String');
no_of_feedheatersv = str2double(get(handles.no_of_feedheaters,'String'));
no_of_feedheater_pumpv = str2double(get(handles.no_of_feedheater_pump,'String'));
handles.steameng{2,1}=no_of_turbinesv;
handles.steameng{3,1}=type_of_feedheaterv;
handles.steameng{4,1}=no_of_feedheatersv;
handles.steameng{5,1}=no_of_feedheater_pumpv;
handles.steameng{6,1}=no_of_turbinesv - 1;
handles.steameng{1,1};
cat=get(handles.reheat_button,'visible');
key=0;
if str2double(handles.steameng{7,1})>0 && str2double(handles.steameng{7,1})~= handles.steameng{6,1} 
    errordlg('Error in Turbine and Superheat Parameters')
elseif strcmp(cat,'off') && no_of_turbinesv > 1 && no_of_feedheatersv == 0
    errordlg('Error in Turbine and Feedheater Parameters')
elseif strcmp(cat,'off') && no_of_turbinesv - 1 ~= no_of_feedheatersv
    errordlg('Error in Turbine and Feedheater Parameters')
elseif no_of_feedheatersv ~= no_of_feedheater_pumpv
    errordlg('Error in Feedheater and Feedpump Parameters')
else
    if str2double(handles.steameng{7,1})>0
        set(handles.feedpara,'visible','off')
        handles.steameng{4,1}=0;
        handles.steameng{5,1}=0;
    end
    if isempty(handles.Plant_Component_Variables_handle)
        handles.Plant_Component_Variables_handle = Plant_Component_Variables;
        Plant_Component_Variables_data = guidata(handles.Plant_Component_Variables_handle);
        
        Plant_Component_Variables_data.Plant_Layout_data1 = get(hObject,'parent');
        Plant_Component_Variables_data.Plant_Layout_data2 = guidata(get(hObject,'parent'));
        %saving the data
        guidata(handles.Plant_Component_Variables_handle,Plant_Component_Variables_data)
        guidata(get(hObject,'parent'),handles)
        key = 1;
    end
    Plant_Component_Variables_data = guidata(handles.Plant_Component_Variables_handle);
    set(Plant_Component_Variables_data.boilertext, 'string', num2str(handles.steameng{7,1}));
    btype=get(handles.reheat_button,'visible');
    if strcmp(btype,'off')
        set(Plant_Component_Variables_data.btype, 'string', 'E');
    else
        set(Plant_Component_Variables_data.btype, 'string', 'S');
    end
    if handles.steameng{2,1}~=0
        set(Plant_Component_Variables_data.turbtext, 'string', num2str(handles.input1));
    else
        set(Plant_Component_Variables_data.turbtext, 'string', num2str(1));
    end

    if  handles.steameng{4,1}~=0
        set(Plant_Component_Variables_data.heatertext, 'string', num2str(handles.input2));
        set(Plant_Component_Variables_data.heaterbutton,'visible','on')
        set(Plant_Component_Variables_data.heatertext,'visible','on')
        set(Plant_Component_Variables_data.text9,'visible','on')
    else
        set(Plant_Component_Variables_data.heatertext, 'string', num2str(0))
        set(Plant_Component_Variables_data.heaterbutton,'visible','off')
        set(Plant_Component_Variables_data.heatertext,'visible','off')
        set(Plant_Component_Variables_data.text9,'visible','off')
    end
    if handles.steameng{5,1}~=0
        set(Plant_Component_Variables_data.pumptext1, 'string', num2str(handles.input3 + 1));
        disp('i exist3')
    else
        set(Plant_Component_Variables_data.pumptext1, 'string', num2str(1));
    end
    
end
if key
    guidata(hObject, handles);
    delete(Plant_Layout)
end
% --- Executes on selection change in type_of_feedheater.
function type_of_feedheater_Callback(hObject, eventdata, handles)
% hObject    handle to type_of_feedheater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns type_of_feedheater contents as cell array
%        contents{get(hObject,'Value')} returns selected item from type_of_feedheater


% --- Executes during object creation, after setting all properties.
function type_of_feedheater_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type_of_feedheater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function no_of_feedheaters_Callback(hObject, eventdata, handles)
% hObject    handle to no_of_feedheaters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of no_of_feedheaters as text
%        str2double(get(hObject,'String')) returns contents of no_of_feedheaters as a double
input2 = str2double(get(handles.no_of_feedheaters,'String'));
handles.input2=input2;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function no_of_feedheaters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no_of_feedheaters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function no_of_feedheater_pump_Callback(hObject, eventdata, handles)
% hObject    handle to no_of_feedheater_pump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of no_of_feedheater_pump as text
%        str2double(get(hObject,'String')) returns contents of no_of_feedheater_pump as a double
input3 = str2double(get(handles.no_of_feedheater_pump,'String'));
handles.input3=input3;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function no_of_feedheater_pump_CreateFcn(hObject, eventdata, handles)
% hObject    handle to no_of_feedheater_pump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in feedheater_selection.
function feedheater_selection_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in feedheater_selection 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
case 'yesop'
set(handles.feedpara,'visible','on')
case 'noop'
set(handles.feedpara,'visible','off')
end
%@(hObject,eventdata)Plant_Layout('btgrp1_CreateFcn',hObject,eventdata,guidata(hObject))


% --- Executes when user attempts to close dsteam2.
function dsteam2_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to dsteam2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isempty(handles.Plant_Component_Variables_handle)
    handles.login = login;
    delete(hObject);
else
    %warndlg('Please click Close Application button on Plant component variable figure','!! Warning !!')
    delete(hObject);
end


% --- Executes on button press in reheat_button.
function reheat_button_Callback(hObject, eventdata, handles)
% hObject    handle to reheat_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    prompt={'Number of ReHeat: '};
    name='Input for Boiler Parameters';
    numlines=1;
    defaultanswer={'',''};
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
    answer=inputdlg(prompt,name,numlines,defaultanswer,options);
    handles.steameng{7,1}=answer{1,1};
    if str2double(handles.steameng{7,1})>0
        set(handles.yesop,'enable','off')
        set(handles.noop,'enable','off')
    else
        set(handles.yesop,'enable','on')
        set(handles.noop,'enable','on')
    end
    guidata(hObject, handles);


% --- Executes on button press in saturatedbutton.
function saturatedbutton_Callback(hObject, eventdata, handles)
% hObject    handle to saturatedbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tablett,'string','SATURATED')
set(handles.uitable1,'ColumnName',{'P-BARS','T-?C','Vf-M^3','Vg-M^3',...
    'Uf-KJ/KG','Ufg-KJ/KG','Ug-KJ/KG','Hf-KJ/KG',...
'Hfg-KJ/KG','Hg-KJ/KG','Sf-KJ/KG','Sfg-KJ/KG','Sg-KJ/KG'})
[xx,~]=size(handles.saturated_data);
for i= 1:xx
    xa{i,1}=i;
end
%xa={''};
set(handles.uitable1,'RowName',xa)
set(handles.uitable1,'Data',handles.saturated_data);


% --- Executes on button press in superheatedbutton.
function superheatedbutton_Callback(hObject, eventdata, handles)
% hObject    handle to superheatedbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tablett,'string','SUPERHEATED')
set(handles.uitable1,'ColumnName',{'P-BARS','SATURATED','S100?C','S150?C'...
    'S200?C','S250?C','S300?C','S400?C','S500?C','S600?C','S700?C','S800?C'...
    'S900?C','S1000?C'})
[xx,~]=size(handles.superheat_data);
xy = (xx-1)/4;
xz = {'Volume','Int-Energy','Enthalpy','Enthropy'};
xa={};
for i = 1:4:xx-1
    for ii = 0:3
        xa{1,i+ii}=xz{1,ii+1};
    end
end
set(handles.uitable1,'RowName',xa)
set(handles.uitable1,'Data',handles.superheat_data);



% --- Executes when selected object is changed in btgp2.
function btgp2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in btgp2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
case 'saturatedop'
set(handles.reheat_button,'visible','off')
set(handles.yesop,'enable','off')
set(handles.noop,'enable','off')
case 'superheatop'
set(handles.reheat_button,'visible','on')
set(handles.yesop,'enable','on')
set(handles.noop,'enable','on')
end
