function varargout = Plant_Component_Variables(varargin)
% PLANT_COMPONENT_VARIABLES MATLAB code for Plant_Component_Variables.fig
%      PLANT_COMPONENT_VARIABLES, by itself, creates a new PLANT_COMPONENT_VARIABLES or raises the existing
%      singleton*.
%
%      H = PLANT_COMPONENT_VARIABLES returns the handle to a new PLANT_COMPONENT_VARIABLES or the handle to
%      the existing singleton*.
%
%      PLANT_COMPONENT_VARIABLES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLANT_COMPONENT_VARIABLES.M with the given input arguments.
%
%      PLANT_COMPONENT_VARIABLES('Property','Value',...) creates a new PLANT_COMPONENT_VARIABLES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Plant_Component_Variables_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Plant_Component_Variables_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Plant_Component_Variables

% Last Modified by GUIDE v2.5 12-Nov-2018 10:32:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Plant_Component_Variables_OpeningFcn, ...
                   'gui_OutputFcn',  @Plant_Component_Variables_OutputFcn, ...
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
% --- Executes just before Plant_Component_Variables is made visible.
function Plant_Component_Variables_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Plant_Component_Variables (see VARARGIN)

% Choose default command line output for Plant_Component_Variables
handles.output = hObject;
tdata = cell(20,10);
set(handles.uitable1,'Data',tdata);
salt = load('satcell.mat');
salt_temp=[salt.sattycell{1:end,2}];
salt_sf=[salt.sattycell{1:end,11}];
salt_sg=[salt.sattycell{1:end,13}];
handles.plottemp=salt_temp;
handles.plotsf=salt_sf;
handles.plotsg=salt_sg;
handles.turbeff1=1;
handles.turbeff2=1;
handles.pumpeff1=1;
handles.condeff1=1;
handles.boileff1=1;
superht = load('superheat.mat');
satvalue =load('satvals.mat');
handles.satheat = satvalue.prevysattest;
handles.superheat = superht.sat11test;
handles.ufunctions = steam_calculation_functions;
handles.cfunctions = steam_calculation_functions(1);
handles.Plant_Design_Result_handle=[];
guidata(hObject, handles);

% UIWAIT makes Plant_Component_Variables wait for user response (see UIRESUME)
% uiwait(handles.Plant_Component_Variables);
% --- Outputs from this function are returned to the command line.
function varargout = Plant_Component_Variables_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on bfbutton press in turbpbutton.
function turbpbutton_Callback(hObject, eventdata, handles)
% hObject    handle to turbpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pltt = {'HP-TURBINE-INLET-PRESURE: ','HP-TURBINE-INLET-TEMPERATURE: ',...
    'HP-TURBINE-OUTLET-PRESURE: ','HP-TURBINE-OUTLET-TEMPERATURE: '};
opt = {'','','',''};
CT = 4;
tno = (str2double(get(handles.turbtext,'String'))-1) * 4;
if tno >= 4
    for i = 5:4:tno+1
        pltt{1,i} = strcat('LP',num2str(i-CT),'-INLET-TURBINE-PRESURE: ');
        pltt{1,i+1} = strcat('LP',num2str(i-CT),'-INLET-TURBINE-TEMPERATURE: ');
        pltt{1,i+2} = strcat('LP',num2str(i-CT),'-OUTLET-TURBINE-PRESURE: ');
        pltt{1,i+3} = strcat('LP',num2str(i-CT),'-OUTLET-TURBINE-TEMPERATURE: ');
        for ii = 0:3
            opt{1,i+ii} = '';
        end
        CT= CT+3;
    end
end
name='Input for Turbine Parameters';
numlines=1;
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex'; 
answer=inputdlg(pltt,name,numlines,opt,options);
btype=get(handles.btype,'string');
if isempty(answer)
    errordlg('You didnt give me any values')
else
   [validity,counter1,no_of_rows]=handles.ufunctions.formcheck(answer,2,1);
   if btype == 'S'
       if isnan(str2double(answer{1,1}))
           validity=0;
       end
   end
   if validity
       if counter1< no_of_rows/2
           errordlg('You have some missing values')
       else
           valve={};
            [~,sy]=size(pltt);
            sz=sy/2;
            con=1;
            ct=2;
            for i = 1:sz
                if i==1
                    valve{i,1}='HP Turbine inlet';
                elseif i==2
                    valve{i,1}='HP Turbine outlet';
                elseif i>2
                    if rem(i,2)==0
                        valve{i,1}=strcat('LP Turbine-',num2str(i-ct),' outlet');
                    else
                        valve{i,1}=strcat('LP Turbine-',num2str(i-ct),' inlet');
                        ct = ct+1;
                    end
                end
                for ii = 2:3
                    valve{i,ii}=answer{con,1};
                    con=con+1;
                end
            end
            prevdata=get(handles.uitable1,'Data');
            if isempty(prevdata{1,1}) 
                datta=valve;
                handles.data1 = valve;
                % Update handles structure
                guidata(hObject, handles);
            else
                handles.data1
                [a,~] = size(handles.data1);
                [c,~] = size(valve);
                if a-c == 0
                    datta = valve;
                else
                    datta = [valve;handles.data1((a-c)+1:end,:)];
                end
                handles.data1 = datta;

                % Update handles structure
                guidata(hObject, handles);
            end
            handles.ufunctions.table_update(answer,datta,hObject,handles);
       end
   else
       errordlg('You have no saved data because of missing values \nplease fill data again')
   end
end

% --- Executes on button press in condpbutton.
function condpbutton_Callback(hObject, eventdata, handles)
% hObject    handle to condpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt={'INLET-PRESURE: ','INLET-TEMPERATURE: ',...
    'OUTLET-PRESURE: ','OUT-TEMPERATURE: '};
name='Input for Condenser Parameters';
numlines=1;
defaultanswer={'','','','',};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
fd = msgbox(sprintf('This is an Isobaric Process, \nInlet and Outlet Pressures should be the same'));
uiwait(fd,3)
delete(fd)
answer=inputdlg(prompt,name,numlines,defaultanswer,options);
if isempty(answer)
    errordlg('You didnt give me any values')
else   
   [validity,counter1,no_of_rows]=handles.ufunctions.formcheck(answer,2,1);
   if validity
       if counter1< no_of_rows/2
           errordlg('You have some missing values')
       else
           valuex = {'CONDENSER inlet',answer{1,1},answer{2,1};
             'CONDENSER outlet',answer{3,1},answer{4,1}};
           prevdata=get(handles.uitable1,'Data');
           captiond=handles.caption;
           captiond.turbpbutton
           isempty(prevdata{1,1})
           if ~captiond.turbpbutton
               errordlg('PLEASE FILL PREVIOUS DATA')
           else
               handles.data1
               [a,~] = size(handles.data1);% size of all d data so far
               [c,~] = size(valuex); % size of justthis dats
               for i = 1:a
                   cc=handles.data1{i,1};
                   cd=valuex{1,1};
                   if  strcmp(cc,cd)
                      % if i can find an occurence of valuex
                      xx=i;
                      if xx+c+1>numel(handles.data1{:,1})
                          % if there are just two main data
                           datta = [handles.data1(1:xx-1,:);valuex];
                      else
                          % if there are more table data
                           datta = [handles.data1(1:xx-1,:);valuex;handles.data1(xx+c+1:end,:)];
                      end
                      break
                   else
                      datta = [handles.data1;valuex];
                   end
                end    
                handles.data1 = datta;
                % Update handles structure
                guidata(hObject, handles);
            end
            handles.ufunctions.table_update(answer,datta,hObject,handles,captiond,'condenser')
       end
   else
       errordlg('You have no saved data because of missing values \nplease fill data again')
   end
end


% --- Executes on button press in boilpbutton.
function boilpbutton_Callback(hObject, eventdata, handles)
% hObject    handle to boilpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pltt2 = {'EVAPORATOR-INLET-PRESURE: ','EVAPORATOR-INLET-TEMPERATURE: ',...
    'EVAPORATOR-OUTLET-PRESURE: ','EVAPORATOR-OUTLET-TEMPERATURE: '};
opt2 = {'','','',''};
CT = 4;
tno =2+ (str2double(get(handles.boilertext,'String')) * 2);
if tno > 2
    for i = 5:2:tno+1
        pltt2{1,i} = strcat('SUPERHEAT-', num2str(i-CT),'-PRESURE: ');
        pltt2{1,i+1} = strcat('SUPERHEAT-', num2str(i-CT),'-TEMPERATURE: ');
        for ii = 0:1
            opt2{1,i+ii} = '';
        end
        if rem(i,2)==1
            CT= CT+1;
        end
    end
end
name='Input for BOILER Parameters';
numlines=1;
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex'; 
fd = msgbox(sprintf('This is an Isobaric Process, \nInlet and Outlet Pressures should be the same'));
uiwait(fd,2)
delete(fd)
answer=inputdlg(pltt2,name,numlines,opt2,options);
if isempty(answer)
    errordlg('You didnt give me any values')
else
   [validity,counter1,no_of_rows]=handles.ufunctions.formcheck(answer,2,1);
   if validity
       if counter1< no_of_rows/2
           errordlg('You have some missing values')
       else
           valve={};
           [~,sy]=size(pltt2);
           sz=sy/2;
           con=1;
           ct=2;
           for i = 1:sz
               if i==1
                   valve{i,1}='Evaporator inlet';
               elseif i==2
                   valve{i,1}='Evaporator outlet';
               elseif i>2
                   valve{i,1}=strcat('Superheater-', num2str(i-ct));
                   ct = ct+1;
               end
               for ii = 2:3
                   valve{i,ii}=answer{con,1};
                   con=con+1;
               end

           end
           captiond=handles.caption;
           if ~captiond.pumpbutton
               errordlg('PLEASE FILL PREVIOUS DATA')
           else
               handles.data1
               [a,~] = size(handles.data1);% size of all d data so far
               [c,~] = size(valve); % size of justthis dats
               for i = 1:a
                   cc=handles.data1{i,1};
                   cd=valve{1,1};
                   if  strcmp(cc,cd)
                       % if i can find an occurence of valuex
                       xx=i;
                       if xx+c+1>numel(handles.data1{:,1})
                           % if there are just two main data
                           datta = [handles.data1(1:xx-1,:);valve];
                       else
                           % if there are more table data
                           datta = [handles.data1(1:xx-1,:);valve;handles.data1(xx+c+1:end,:)];
                       end
                       break
                   else
                       datta = [handles.data1;valve];
                   end
               end    
               handles.data1 = datta;
               % Update handles structure
               guidata(hObject, handles);
           end
           handles.ufunctions.table_update(answer,datta,hObject,handles,captiond,'boiler')
      end
   else
       errordlg('You have no saved data because of missing values \nplease fill data again')
   end
   
end


% --- Executes on button press in pumpbutton.
function pumpbutton_Callback(hObject, eventdata, handles)
% hObject    handle to pumpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pltt = {'CONDENSERPUMP-INLET-PRESURE: ','CONDENSERPUMP-INLET-TEMPERATURE: ',...
    'CONDENSERPUMP-OUTLET-PRESURE: ','CONDENSERPUMP-OUTLET-TEMPERATURE: '};
opt = {'','','',''};
CT = 4;
tno = (str2double(get(handles.pumptext1,'String'))-1) * 4;
if tno >= 4
    
    for i = 5:4:tno+1
        if tno+1==5
            pltt{1,i} = strcat('FEEDPUMP',num2str(i-CT),'-INLET-TURBINE-PRESURE: ');
            pltt{1,i+1} = strcat('FEEDPUMP',num2str(i-CT),'-INLET-TURBINE-TEMPERATURE: ');
            pltt{1,i+2} = strcat('FEEDPUMP',num2str(i-CT),'-OUTLET-TURBINE-PRESURE: ');
            pltt{1,i+3} = strcat('FEEDPUMP',num2str(i-CT),'-OUTLET-TURBINE-TEMPERATURE: ');
        else
            if i==tno+1
                pltt{1,i} = strcat('HP FEEDPUMP',num2str(i-CT),'-INLET-TURBINE-PRESURE: ');
                pltt{1,i+1} = strcat('HP FEEDPUMP',num2str(i-CT),'-INLET-TURBINE-TEMPERATURE: ');
                pltt{1,i+2} = strcat('HP FEEDPUMP',num2str(i-CT),'-OUTLET-TURBINE-PRESURE: ');
                pltt{1,i+3} = strcat('HP FEEDPUMP',num2str(i-CT),'-OUTLET-TURBINE-TEMPERATURE: ');
            else
                pltt{1,i} = strcat('LP FEEDPUMP',num2str(i-CT),'-INLET-TURBINE-PRESURE: ');
                pltt{1,i+1} = strcat('LP FEEDPUMP',num2str(i-CT),'-INLET-TURBINE-TEMPERATURE: ');
                pltt{1,i+2} = strcat('LP FEEDPUMP',num2str(i-CT),'-OUTLET-TURBINE-PRESURE: ');
                pltt{1,i+3} = strcat('LP FEEDPUMP',num2str(i-CT),'-OUTLET-TURBINE-TEMPERATURE: ');
            end
        end
        for ii = 0:3
            opt{1,i+ii} = '';
        end
        CT= CT+3;
    end
end
name='Input for PUMP Parameters';
numlines=1;
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=inputdlg(pltt,name,numlines,opt,options);
if isempty(answer)
    errordlg('You didnt give me any values')
else
   [validity,counter1,no_of_rows]=handles.ufunctions.formcheck(answer,2,1);
   if validity
       if counter1< no_of_rows/2
           errordlg('You have some missing values')
       else
           valve={};
           [~,sy]=size(pltt);
           sz=sy/2;
           con=1;
           ct=2;
           for i = 1:sz
               if i==1
                   valve{i,1}='Condenser Pump inlet';
               elseif i==2
                   valve{i,1}='Condenser Pump outlet';
               elseif i>2
                   if rem(i,2)==0
                       valve{i,1}=strcat('Feed Pump-' ,num2str(i-ct),' outlet');
                   else
                       valve{i,1}=strcat('Feed Pump-', num2str(i-ct),' inlet');
                       ct=ct+1;
                   end     
               end
               for ii = 2:3
                   valve{i,ii}=answer{con,1};
                   con=con+1;
               end
           end
           captiond=handles.caption;
           if ~captiond.condpbutton
               errordlg('PLEASE FILL PREVIOUS DATA')
           else
               handles.data1
               [a,~] = size(handles.data1);% size of all d data so far
               [c,~] = size(valve); % size of justthis dats
               for i = 1:a
                   cc=handles.data1{i,1};
                   cd=valve{1,1};
                   if  strcmp(cc,cd)
                       % if i can find an occurence of valuex
                       xx=i;
                       if xx+c+1>numel(handles.data1{:,1})
                           % if there are just two main data
                           datta = [handles.data1(1:xx-1,:);valve];
                       else
                           % if there are more table data
                           datta = [handles.data1(1:xx-1,:);valve;handles.data1(xx+c+1:end,:)];
                       end
                       break
                   else
                       datta = [handles.data1;valve];
                   end
               end    
               handles.data1 = datta;
               % Update handles structure
               guidata(hObject, handles);
           end
           handles.ufunctions.table_update(answer,datta,hObject,handles,captiond,'pump')
      end
   else
       errordlg('You have no saved data because of missing values \nplease fill data again')
   end
end

% --- Executes on button press in heaterbutton.
function heaterbutton_Callback(hObject, eventdata, handles)
% hObject    handle to heaterbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pltt = {'FEEDHEATER-1 PRESURE RATING: ','FEEDHEATER-1 TEMPERATURE RATING: ',...
    'FEEDHEATER-1 MASS TAPPED: '};
opt = {'','',''};
CT = 2;
tno = (str2double(get(handles.heatertext,'String'))-1) * 3;
if tno >=3
    for i = 4:3:tno+1
        if tno+1==4
            pltt{1,i} = strcat('FEEDHEATER-',num2str(i-CT),' PRESURE RATING: ');
            pltt{1,i+1} = strcat('FEEDHEATER -',num2str(i-CT),' TEMPERATURE RATING: ');
            pltt{1,i+2} = strcat('FEEDHEATER -',num2str(i-CT),' MASS TAPPED: ');
        else
            if i==tno+1
                pltt{1,i} = strcat('HP FEEDHEATER-',num2str(i-CT),' PRESURE RATING: ');
                pltt{1,i+1} = strcat('HP FEEDHEATER -',num2str(i-CT),' TEMPERATURE RATING: ');
                pltt{1,i+2} = strcat('HP FEEDHEATER -',num2str(i-CT),' MASS TAPPED: ');
            else
                pltt{1,i} = strcat('LP FEEDHEATER-',num2str(i-CT),' PRESURE RATING: ');
                pltt{1,i+1} = strcat('LP FEEDHEATER -',num2str(i-CT),' TEMPERATURE RATING: ');
                pltt{1,i+2} = strcat('LP FEEDHEATER -',num2str(i-CT),' MASS TAPPED: ');
            end
        end
        
        for ii = 0:2
            opt{1,i+ii} = '';
        end
        CT= CT+2;
    end
end
name='Input for FEEDHEATER Parameters';
numlines=1;
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=inputdlg(pltt,name,numlines,opt,options);
if isempty(answer)
    errordlg('You didnt give me any values')
else
   [~,counter1,no_of_rows]=handles.ufunctions.formcheck(answer,2,0);
   validity=1;
   if validity
       if counter1< no_of_rows/3
           errordlg('You have some missing values')
       else
           valve={};
           [~,sy]=size(pltt);
           sz=sy/3;
           ct=2;
           con=1;
           for i = 1:sz
               valve{i,1}=strcat('Feedheater-', num2str(i));

               for ii = 2:6
                   if ii==2 || ii == 3
                       valve{i,ii}=answer{con,1};
                       con=con+1;
                   end
                   if ii == 6
                       con=con+1;
                   end
               end
           end
           captiond=handles.caption;
           if ~captiond.boilpbutton
               errordlg('PLEASE FILL PREVIOUS DATA')
           else
               handles.data1
               [a,~] = size(handles.data1);% size of all d data so far
               [c,~] = size(valve); % size of justthis dats
               for i = 1:a
                   cc=handles.data1{i,1};
                   cd=valve{1,1};
                    if  strcmp(cc,cd)
                       % if i can find an occurence of valuex
                       xx=i;
                       if xx+c+1>numel(handles.data1{:,1})
                           % if there are just two main data
                           datta = [handles.data1(1:xx-1,:);valve];
                       else
                           % if there are more table data
                           datta = [handles.data1(1:xx-1,:);valve;handles.data1(xx+c+1:end,:)];
                       end
                       break
                   else
                       datta = [handles.data1;valve];
                   end
               end    
               handles.data1 = datta;
               % Update handles structure
               guidata(hObject, handles);
           end
           handles.ufunctions.table_update(answer,datta,hObject,handles,captiond,'heater')
      end
   else
       errordlg('You have no saved data because of missing values \nplease fill data again')
   end
end

    
% --- Executes on button press in closee.
function closee_Callback(hObject, eventdata, handles)
% hObject    handle to closee (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see
% GUIDATA)dsteam2,comp_details
delete(handles.Plant_Layout_data2.dsteam2);  % close GUI-2 
delete(get(hObject,'parent')); % close GUI-3 


% --- Executes when user attempts to close Plant_Component_Variables.
function Plant_Component_Variables_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Plant_Component_Variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
%delete(hObject);
if isempty(handles.Plant_Design_Result_handle)
    handles.login = login;
    delete(hObject);
else
    warndlg('Please click Close Application button on Plant result figure','!! Warning !!')
end

function updatebutton_Callback(hObject, eventdata, handles)
% hObject    handle to updatebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
satheat = handles.satheat;
superheat = handles.superheat;
tdata=handles.data1;
[row_size,~] = size(tdata);
fpump_constant =7;
if row_size<1 % change to 8
    errordlg('Please Fill Relevant Data')
else
    sup_pressure=superheat(:,1);% superheat pressures
    sat_pressure=satheat(:,1);% saturated pressures
    btype=get(handles.btype,'string');
    for i = 1:row_size
        if i==1 || i==2
            %pressure temp check
            p1=str2double(tdata{i,2});
            t1=str2double(tdata{i,3});
            if btype == 'S'
                if i==1
                    if ~isnan(t1)&& ~isnan(p1)
                        dhata1=handles.cfunctions.arranger(tdata,sup_pressure,i,superheat,sat_pressure,satheat,handles,btype);
                    else
                        errordlg('sorry i have problems with your values')
                        break
                    end
                else
                    if ~isnan(p1)
                        dhata1=handles.cfunctions.arranger(tdata,sup_pressure,i,superheat,sat_pressure,satheat,handles,btype);
                        turbine_efficiency=handles.turbeff1;
                        mp=(dhata1{i-1,4}-dhata1{i,4})*turbine_efficiency;
                        dhata1{i,4}=dhata1{i-1,4}-mp;
                    else
                        errordlg('sorry i have problems with your values')
                        break
                    end
                end
                
            else
                if ~isnan(p1)
                    dhata1=handles.cfunctions.arranger(tdata,sup_pressure,i,superheat,sat_pressure,satheat,handles,btype);
                    if i ~=1
                        turbine_efficiency=handles.turbeff1;
                        mp=dhata1{i-1,4}-dhata1{i,4}*turbine_efficiency;
                        dhata1{i,4}=dhata1{i-1,4}-mp;
                    end
                else
                    errordlg('sorry i have problems with your values')
                    break
                end
            end
            tdata=dhata1; %come back later
        else
            lpturb=handles.ufunctions.contains(tdata(:,1),'LP',2);
            if lpturb(i,1)
                p2=str2double(tdata{i,2});
                t2=str2double(tdata{i,3});
                if ~isnan(p2)
                    dhata2=handles.cfunctions.arranger(tdata,sup_pressure,i,superheat,sat_pressure,satheat,handles,btype);
                    if rem(i,2) == 0
                        turbine_efficiency=handles.turbeff2;
                        mp=(dhata1{i-1,4}-dhata1{i,4})*turbine_efficiency;
                        dhata1{i,4}=dhata1{i-1,4}-mp;
                    end
                    tdata=dhata2;
                else
                    errordlg('sorry i have problems with your values')
                    break
                end
            end
            no_of_lp_turbines = sum(lpturb);
            condy = handles.ufunctions.contains(tdata(:,1),'CONDENSER',9);
            if condy(i,1)
                dhata3=handles.cfunctions.satliquid_update(i,tdata,sat_pressure,satheat);%satliq(i,tdata,sat_pressure,satheat);
                if isempty(dhata3)
                    errordlg('sorry i have problems with your values')
                    break
                else
                    cut = i;
                    tdata=dhata3;
                end
                
            end
            % remaining update for pump and feed heaters
            phump = handles.ufunctions.contains(tdata(:,1),'Condenser Pump',14);
            if phump(i,1)
                if rem(i,2)~=0
                    pl=str2double(tdata{(no_of_lp_turbines+2),2});
                    ghat =str2double(get(handles.heatertext,'string'));
                    if ghat ~=0
                        ph=str2double(tdata{(no_of_lp_turbines+1),2});
                    else
                        ph=str2double(tdata{1,2});
                    end
                    fheater_option='';
                    newsat = handles.cfunctions.saton(tdata,sat_pressure,satheat,i,fheater_option,handles);
                    if isempty(newsat)
                        errordlg('sorry i have problems with your values')
                        break
                    else
                       [siz,~]=size(newsat);
                        for kl=1:siz
                            if newsat{kl,1}==pl
                                disp('heyyyy')
                                hl=newsat{kl,3};
                                vf=newsat{kl,5};
                                sf=newsat{kl,4};
                                ttt=newsat{kl,2};
                            end
                            if newsat{kl,1}==ph
                                hlh=newsat{kl,3};
                                vfh=newsat{kl,5};
                                sfh=newsat{kl,4};
                                ttth=newsat{kl,2}; 
                            end
                        end 
                    end
                    
                    for ii=2:5
                        tdata{i,ii}=tdata{(no_of_lp_turbines+4),ii};
                    end
                    tdata=tdata;
                else
                    tdata{i,2}=ph;
                    tdata{i,3}=ttth;
                    tdata{i,4}=((ph-pl)*vf*100)+hl;
                    pump_efficiency=handles.pumpeff1;
                    mp=(tdata{i,4}-tdata{i-1,4})/pump_efficiency;
                    tdata{i,4}=mp+tdata{i-1,4};
                    tdata{i,5}=sf;
                end
                
                tdata=tdata;
            end
            feedh_pump = handles.ufunctions.contains(tdata(:,1),'Feed Pump',9);
            
            if feedh_pump(i,1)
                i
                tdata
                if rem(i,2)~=0
                    pl=str2double(tdata{(i-(fpump_constant)),2});
                    ph=str2double(tdata{(i-(fpump_constant+1)),2});
                    fheater_option='fh';
                    newsat = handles.cfunctions.saton(tdata,sat_pressure,satheat,row_size,fheater_option,handles);
                    %newsat
                    if isempty(newsat)
                        errordlg('sorry i have problems with your values')
                        break
                    else
                        [siz,~]=size(newsat);
                        for kl=1:siz
                            if newsat{kl,1}==pl
                                hl=newsat{kl,3};
                                vf=newsat{kl,5};
                                sf=newsat{kl,4};
                                ttt=newsat{kl,2};

                            end
                            if newsat{kl,1}==ph
                                hlh=newsat{kl,3};
                                vfh=newsat{kl,5};
                                sfh=newsat{kl,4};
                                ttth=newsat{kl,2};

                            end
                        end
                        disp('inlets of feedpumps')
                        t='';
                        saturated_data=handles.cfunctions.getSaturatedValues(pl,t,satheat,sat_pressure);
                        tdata{i,2}=pl;
                        tdata{i,3}=saturated_data(1,6);
                        tdata{i,4}=hl;
                        tdata{i,5}=sf;
                        fpump_constant=fpump_constant+2;
                    end
                    tdata=tdata;
                    
                else
                   
                    tdata{i,2}=ph;
                    tdata{i,3}=ttth;
                    tdata{i,4}=((ph-pl)*vf*100)+hl;
                    tdata{i,5}=sf;
                    fpump_constant=fpump_constant+2;
                end
                
            end
            
            %updating parameters
            evap = handles.ufunctions.contains(tdata(:,1),'Evapo',5);
            if evap(i,1)
                if rem(i,2)==0
                    for ii=2:5
                        tdata{i,ii}=tdata{1,ii};
                    end
                else
                    tdata{i,2}=tdata{1,2};
                    feedh_pump = handles.ufunctions.contains(tdata(:,1),'Feed Pump',9);
                    if sum(feedh_pump)== 0
                        for p =2:5
                            tdata{i,p}=tdata{6+no_of_lp_turbines,p};
                        end
                    else
                        for p =2:5
                            tdata{i,p}=tdata{6+no_of_lp_turbines+sum(feedh_pump),p};
                        end
                    end
                end
                go = str2double(get(handles.heatertext,'string'));
                if sum(superht)~=0
                    set(handles.resultbutton9,'visible','off')
                elseif go ~=0
                    set(handles.resultbutton9,'visible','off')
                else
                    set(handles.resultbutton9,'visible','on')
                end
            end
            %no_of_lp_turbines = sum(lpturb);
            superht = handles.ufunctions.contains(tdata(:,1),'Super',5);
            if superht(i,1)
                for jj = 3:2:no_of_lp_turbines+1
                    for ii=2:5
                        tdata{i,ii}=tdata{jj,ii};
                    end
                end
                set(handles.resultbutton9,'visible','on')
            end
            
            heaterz = handles.ufunctions.contains(tdata(:,1),'Feedheater',10);
            if heaterz(i,1)
               set(handles.resultbutton9,'visible','on')
            end
        end
    end
end

[aa,bb]=size(tdata);
for i = 1:aa
    for ii = 1:bb
        if isempty(tdata{i,ii})
            tdata{i,ii}=0;
        end
    end
end
set(handles.uitable1,'Data',tdata);
handles.finaldata=tdata;
guidata(get(hObject,'parent'),handles) 

% --- Executes on button press in resultbutton9.
function resultbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to resultbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
satheat = handles.satheat;
sat_pressure=satheat(:,1);% saturated pressures
info_message=msgbox('PLEASE WAIT WHILE WE PROCESS THE NEXT SCREEN');
uiwait(info_message,3)
delete(info_message)
if isempty(handles.Plant_Design_Result_handle)
    handles.Plant_Design_Result_handle = Plant_Design_Result;
    Plant_Design_Result_data = guidata(handles.Plant_Design_Result_handle);
    Plant_Design_Result_data.Plant_Layout_data1 = get(hObject,'parent');
    Plant_Design_Result_data.Plant_Layout_data2 = guidata(get(hObject,'parent'));
    %saving the data
    guidata(handles.Plant_Design_Result_handle,Plant_Design_Result_data)
    guidata(get(hObject,'parent'),handles)   
end

Plant_Design_Result_data = guidata(handles.Plant_Design_Result_handle);
%set up your values
total_data=handles.finaldata;
[row_size,~]=size(total_data);
for cv = 1:row_size
    condy = handles.ufunctions.contains(total_data(:,1),'CONDENSER',9);
    if condy(cv,1)
        if rem(cv,2)~=0
            houth=total_data{cv,4};
            
        else
            houtl=total_data{cv,4};
            heatout=houth-houtl;
            heatout = heatout/handles.condeff1;
        end
        fpump = handles.ufunctions.contains(total_data(:,1),'Feed Pump',9);
        low_pre_turb = handles.ufunctions.contains(total_data(:,1),'LP',2);
        heaterz =str2double(get(handles.heatertext,'string'));
        if sum(low_pre_turb)==0
            hinh=total_data{1,4};
            hinl=total_data{7,4};
            heatin = hinh-hinl;
            heatin = heatin/handles.boileff1;
            workin = total_data{6,4}-total_data{5,4};
            workout = total_data{1,4}-total_data{2,4};
        elseif sum(low_pre_turb)~=0 && sum(heaterz) == 0
            hinh=total_data{1,4};
            hinl=total_data{6+sum(fpump)+sum(low_pre_turb),4};
            heatin = hinh-hinl;
            heatin = heatin/handles.boileff1;
            workin = total_data{6+sum(low_pre_turb),4}-total_data{5+sum(low_pre_turb),4};
            wt = 0;
            for m=1:2:sum(low_pre_turb)+1
                wt = wt + total_data{m,4}-total_data{m+1,4};
            end
            workout = wt;
        elseif sum(low_pre_turb)~=0 && sum(heaterz) ~= 0
            peg=zeros(1,heaterz);
            k7=1;
            for ij = 1:sum(heaterz)
                num=(k7*total_data{((6+sum(low_pre_turb)+sum(fpump))-(((ij-1)*2)+1)),4})-(k7*total_data{((6+sum(low_pre_turb)+sum(fpump))-2*ij),4});
                den=total_data{ij*2,4}-total_data{((6+sum(low_pre_turb)+sum(fpump))-2*ij),4};
                peg(1,ij)=num/den;
                k7=1-sum(peg(1,ij));
            end
            wq=0;
            zq=1;
            lm=0;
            for m=6+sum(low_pre_turb)+sum(fpump):-2:sum(low_pre_turb)+5
                if zq>=2
                    lm=lm+peg(1,zq-1);
                    wq = wq +(1-lm)*(total_data{m,4}-total_data{m-1,4});
                else
                    wq = wq + total_data{m,4}-total_data{m-1,4};
                end
                zq=zq +1;
            end
            workin=wq;
            hinh=total_data{1,4};
            hinl=total_data{6+sum(fpump)+sum(low_pre_turb),4};
            heatin = hinh-hinl;
            heatin = heatin/handles.boileff1;
            wq2=0;
            zq2=1;
            lm2=0;
            for m=1:2:sum(low_pre_turb)+2
                if zq2>=2
                    lm2=lm2+peg(1,zq2-1);
                    wq2 = wq2 +(1-lm2)*(total_data{m,4}-total_data{m+1,4});
                else
                    wq2 = wq2 + total_data{m,4}-total_data{m+1,4};
                end
                zq2=zq2 +1;
            end
            workout = wq2;
        end 
    end
    evape = handles.ufunctions.contains(total_data(:,1),'Evapo',5);
    
    if evape(cv,1)
        if rem(cv,2)~=0
            tempx=zeros(1,cv);
            entropyy=zeros(1,cv);
            for inner_cv = 1:cv
               if ischar(total_data{inner_cv,3})
                   tempx(1,inner_cv)=str2double(total_data{inner_cv,3});
               else
                   tempx(1,inner_cv)=total_data{inner_cv,3};
                   
               end
               entropyy(1,inner_cv)=total_data{inner_cv,5};
            end
            btype=get(handles.btype,'string');
            if btype == 'S'
                t='';
                saturated_data=handles.cfunctions.getSaturatedValues(str2double(total_data{1,2}),t,satheat,sat_pressure);
                tempx(1,inner_cv+1)=saturated_data(1,6);
                entropyy(1,inner_cv+1)=saturated_data(1,3);
                tempx(1,inner_cv+2)=saturated_data(1,6);
                entropyy(1,inner_cv+2)=saturated_data(1,4);
                if ischar(total_data{inner_cv+1,3})
                   tempx(1,inner_cv+3)=str2double(total_data{inner_cv+1,3});
                else
                   tempx(1,inner_cv+3)=total_data{inner_cv+1,3};
                end
                entropyy(1,inner_cv+3)=total_data{1,5};
                ac = zeros(2,sum(low_pre_turb)/2);
                ad=1;
                for xx = 1:2:sum(low_pre_turb)
                    if ischar(total_data{2+xx,2})
                        saturated_data=handles.cfunctions.getSaturatedValues(str2double(total_data{xx+2,2}),t,satheat,sat_pressure);
                    else
                        saturated_data=handles.cfunctions.getSaturatedValues(total_data{xx+2,2},t,satheat,sat_pressure);
                    end
                    ac(1,ad)=saturated_data(1,6);
                    ac(2,ad)=saturated_data(1,4);
                    ad=ad+1;
                end
                if sum(heaterz)~= 0
                    u=1;
                    [~,y]=size(tempx);
                    uu=y;
                    ud=1;
                    tempx2=0;
                    entropyy2=0;
                    for iq = 1:sum(heaterz)
                        if iq==1
                            tempx(1,uu+1)=tempx(1,2*iq);
                            entropyy(1,uu+1)=entropyy(1,2*iq);
                            tempx(1,uu+2)=ac(1,iq);
                            entropyy(1,uu+2)=ac(2,iq);
                            tempx(1,uu+3)=tempx(1,6+sum(low_pre_turb)+sum(fpump)-u);
                            entropyy(1,uu+3)=entropyy(1,6+sum(low_pre_turb)+sum(fpump)-u);
                            uu=uu+3;
                            u=u+2;
                        else
                           tempx2(1,ud)=tempx(1,2*iq);
                           entropyy2(1,ud)=entropyy(1,2*iq);
                           tempx2(1,ud+1)=ac(1,iq);
                           entropyy2(1,ud+1)=ac(2,iq);
                           tempx2(1,ud+2)=tempx(1,6+sum(low_pre_turb)+sum(fpump)-u);
                           entropyy2(1,ud+2)=entropyy(1,6+sum(low_pre_turb)+sum(fpump)-u);
                           u=u+2;
                           ud=ud+3;
                        end
                       
                    end
                else
                    entropyy2=0;
                    tempx2=0;
                end
            else
                entropyy2=0;
                tempx2=0;
                t='';
                saturated_data=handles.cfunctions.getSaturatedValues(str2double(total_data{1,2}),t,satheat,sat_pressure);
                tempx(1,inner_cv+1)=saturated_data(1,6);
                entropyy(1,inner_cv+1)=saturated_data(1,3);
                if ischar(total_data{inner_cv,3})
                   tempx(1,inner_cv+2)=str2double(total_data{1,3});
                else
                   tempx(1,inner_cv+2)=total_data{1,3};
                end
                entropyy(1,inner_cv+2)=total_data{1,5};
            end
        end
    end
    
end
workdone = workout-workin;
workratio = workdone/workout;
efficiency=(workdone/heatin)*100;
set(Plant_Design_Result_data.heatsuptext, 'string', num2str(heatin));
set(Plant_Design_Result_data.heatrejtxt, 'string', num2str(heatout));
set(Plant_Design_Result_data.wintxt, 'string', num2str(workin));
set(Plant_Design_Result_data.wouttxt, 'string', num2str(workout));
set(Plant_Design_Result_data.wratiotxt, 'string', num2str(workratio));
set(Plant_Design_Result_data.wdonetxt, 'string', num2str(workdone));
set(Plant_Design_Result_data.efftxt, 'string', num2str(efficiency));
plot(Plant_Design_Result_data.axes2,handles.plotsf,handles.plottemp,'Linewidth',4)
hold(Plant_Design_Result_data.axes2,'on')
xlabel(Plant_Design_Result_data.axes2,'Enthropy')
ylabel(Plant_Design_Result_data.axes2,'Temperature')
plot(Plant_Design_Result_data.axes2,handles.plotsg,handles.plottemp,'Linewidth',4)
hold(Plant_Design_Result_data.axes2,'on')
[~,ent_height] = size(entropyy);
for f = 1:ent_height
    plot(Plant_Design_Result_data.axes2,entropyy(1,f),tempx(1,f),'k.','MarkerSize',15)
    hold(Plant_Design_Result_data.axes2,'on')
end
plot(Plant_Design_Result_data.axes2,entropyy,tempx,'c','Linewidth',1.5)
if tempx2
    hold(Plant_Design_Result_data.axes2,'on')
    plot(Plant_Design_Result_data.axes2,entropyy2,tempx2,'c','Linewidth',1.5)
end
set(get(Plant_Design_Result_data.axes2,'title'),'string','Temperature vs Entropy diagram')
%set(Plant_Design_Result_data.axes2,'xtick',[],'ytick',[])
legend(Plant_Design_Result_data.axes2,{'y = Temperature','x = Entropy'},'location','northwest')
set(handles.Plant_Design_Result_handle,'toolbar','figure')
%set(handles.Plant_Design_Result_handle,'menubar','figure')
hold(Plant_Design_Result_data.axes2,'off')
guidata(hObject, handles);

% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tdata = cell(4,6);
set(handles.uitable1,'Data',tdata);
set(handles.resultbutton9,'visible','off')
handles.data1=tdata;
guidata(hObject, handles);

% --- Executes on button press in pumpbutton.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pumpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in checkbutton.
function checkbutton_Callback(hObject, eventdata, handles)
% hObject    handle to checkbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pltt = {'PRESSURE: ','TEMPERATURE: '};
opt = {'',''};
name='Input for Turbine Parameters';
numlines=1;
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex'; 
answer=inputdlg(pltt,name,numlines,opt,options);
superht = handles.superheat;
satvalue =handles.satheat;
satheat = satvalue.prevysattest;
superheat = superht.sat11test;
sup_pressure=superheat(:,1);% superheat pressures
sat_pressure=satheat(:,1);% saturated pressures
sat_temperature =satheat(:,2);% saturated temperatures
if isempty(answer)
    errordlg('You didnt give me any values')
elseif strcmp(answer{1,1},'') && strcmp(answer{2,1},'')
    errordlg('You didnt give me any values')
elseif strcmp(answer{2,1},'')
    saturated_data=handles.cfunctions.getSaturatedValues(str2double(answer{1,1}),answer{2,1},satheat,sat_pressure);
    if isempty(saturated_data)
        errordlg('sorry i have problems with your values')
    else
        msgbox(sprintf('SATURATED VALUES\nHF %.2f KJ/KG\nHG %.2f KJ/KG\nSF %.2f KJ/KG\nSG %.2f KJ/KG\nVF %.5f M^3\nTEMP %.2f ^C\n',saturated_data))
    end
    
elseif strcmp(answer{1,1},'')
    saturated_data=handles.cfunctions.getSaturatedValues(answer{1,1},str2double(answer{2,1}),satheat,sat_temperature);
    if isempty(saturated_data)
        errordlg('sorry i have problems with your values')
    else
        msgbox(sprintf('SATURATED VALUES\nHF %.2f KJ/KG\nHG %.2f KJ/KG\nSF %.2f KJ/KG\nSG %.2f KJ/KG\nVF %.5f M^3\nPRESSURE %.2f bar\n',saturated_data))
    end
else
    superheated_data=handles.cfunctions.getSuperheatedValues(str2double(answer{1,1}),str2double(answer{2,1}),sup_pressure,superheat);
    if isempty(superheated_data)
        errordlg('sorry i have problems with your values')
    else
        msgbox(sprintf('SUPERHEAT VALUES\nEnthalp H %.2f KJ/KG\nEnthropy S %.2f  KJ/KG\nTemperature %d ^c\nPressure %d bar\n',...
        superheated_data,str2double(answer{2,1}),str2double(answer{1,1})))
    end
    
end



function turbeff1_Callback(hObject, eventdata, handles)
% hObject    handle to turbeff1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of turbeff1 as text
%        str2double(get(hObject,'String')) returns contents of turbeff1 as a double

vall = str2double(get(hObject,'String'));
if vall>1
    
    errordlg('sorry this value cannot be more than 1 its range is [0.0001 - 1]')
    handles.turbeff1=1;
else
    handles.turbeff1=vall;
end
handles.turbeff1
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function turbeff1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to turbeff1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pumpeff1_Callback(hObject, eventdata, handles)
% hObject    handle to pumpeff1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pumpeff1 as text
%        str2double(get(hObject,'String')) returns contents of pumpeff1 as a double
vall = str2double(get(hObject,'String'));
if vall>1
    handles.pumpeff1=1;
    errordlg('sorry this value cannot be more than 1 its range is [0.0001 - 1]')
else
    handles.pumpeff1=vall;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pumpeff1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pumpeff1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function turbeff2_Callback(hObject, eventdata, handles)
% hObject    handle to turbeff2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of turbeff2 as text
%        str2double(get(hObject,'String')) returns contents of turbeff2 as a double
vall = str2double(get(hObject,'String'));
if vall>1
    handles.turbeff2=1;
    errordlg('sorry this value cannot be more than 1 its range is [0.0001 - 1]')
else
    handles.turbeff2=vall;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function turbeff2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to turbeff2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function condeff1_Callback(hObject, eventdata, handles)
% hObject    handle to condeff1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of condeff1 as text
%        str2double(get(hObject,'String')) returns contents of condeff1 as a double
vall = str2double(get(hObject,'String'));
if vall>1
    handles.condeff1=1;
    errordlg('sorry this value cannot be more than 1 its range is [0.0001 - 1]')
else
    handles.condeff1=vall;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function condeff1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to condeff1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function boileff1_Callback(hObject, eventdata, handles)
% hObject    handle to boileff1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of boileff1 as text
%        str2double(get(hObject,'String')) returns contents of boileff1 as a double
vall = str2double(get(hObject,'String'));
if vall>1
    handles.boileff1=1;
    errordlg('sorry this value cannot be more than 1 its range is [0.0001 - 1]')
else
    handles.boileff1=vall;
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function boileff1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to boileff1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
