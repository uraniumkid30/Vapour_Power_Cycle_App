function func = steam_calculation_functions(varargin)
    if ~isempty(varargin)
        func.pressure_interpolator = @pressure_interpolator;
        func.getSaturatedValues = @getSaturatedValues;
        func.getSuperheatedValues = @getSuperheatedValues;
        func.satliquid_update = @satliquid_update;
        func.superr = @superr;
        func.saton = @saton;
        func.arranger = @arranger;
        func.test = @test;
    else
        func.contains = @contains;
        func.formcheck = @formcheck;
        func.table_update = @table_update;
    end
end

function c=contains(cell_data,code,match_len)
    [a,b]=size(cell_data);
    c=zeros(a,b);
    for i =1:a
        c(i,1)=strncmp(cell_data{i,1},code,match_len);
    end
end

function [validity,counter1,no_of_rows] = formcheck( answer,divisor,main )
    [no_of_rows,~]=size(answer);
    counter1=0;
    store=zeros(1,no_of_rows/divisor);
    counter2=1;
    for i=1:no_of_rows
       if ~isempty(answer{i,1}) 
           counter1=counter1+1;
       end
       if rem(i,2)~=0
           store(1,counter2)=str2double(answer{i,1});
           counter2=counter2+1;
       end
    end
    if main
        for kj = store
            if isnan(double(kj))
                errordlg('You have some non numerical values')
                validity=0;
                break
            end
            validity=1;
        end
    end
 
end

 function table_update(answer,datta,hObject,handles,varargin)
    [no_of_rows,~]=size(answer);
    counter1=0;
    for i=1:no_of_rows
       if ~isempty(answer{i,1}) 
           counter1=counter1+1;
       end
    end
    if counter1==no_of_rows
        if isempty(varargin)
            captiond.turbpbutton = logical(1);
            handles.caption = captiond;
        else
            switch varargin{2}
            case 'condenser'
                varargin{1}.condpbutton = logical(1);
            case  'pump'
                varargin{1}.pumpbutton = logical(1);
            case  'boiler'
                varargin{1}.boilpbutton = logical(1);
            case  'heater'
                varargin{1}.boilpbutton = logical(1);
            end
            handles.caption = varargin{1};
        end
        guidata(hObject, handles);
    else
        if isempty(varargin)
            captiond.turbpbutton = logical(0);
            handles.caption = captiond;
        else
            switch varargin{2}
            case 'condenser'
                varargin{1}.condpbutton = logical(1);
            case  'pump'
                varargin{1}.pumpbutton = logical(1);
            case  'boiler'
                varargin{1}.boilpbutton = logical(1);
            case  'heater'
                varargin{1}.boilpbutton = logical(1);
            end
            handles.caption = varargin{1};
        end
        guidata(hObject, handles);
    end
    set(handles.uitable1,'Data',datta);
 end

function [break_point,ratio,pressure_id]=pressure_interpolator(no_of_row_data,pressure_col_data,pressure_input)
    % this does interpolation for pressure values

    counter_update=1;
    for ii = 1:no_of_row_data
        ac=pressure_col_data(ii,1);
        pressure_id=0;
        if ac.pressure>=pressure_input
            if ii ~=1
                % this makes sure that the calculations below can hold
                num=pressure_input-(pressure_col_data(ii-1,1).pressure);
                den=ac.pressure-(pressure_col_data(ii-1,1).pressure);
                if ac.pressure-pressure_input>0.000001
                    ratio = num/den;
                else
                    ratio=0;
                end
                break_point=counter_update;
                pressure_id=1;
                break
            else
                pressure_id=0;
            end    
        end
        counter_update=counter_update+1;
    end
end

function saturated_data=getSaturatedValues(p,t,satheat_data,sat_pressure_data)
    % gets temperature or pressure values, and returns the saturated values for these guys
    % interpolation on these values are done if necessary
    row_size = height(sat_pressure_data);
    if strcmp(p,'')
        tsat=t;
        if ~isnan(tsat)
            counter_index=1;
            for ii = 1:row_size
                ac=satheat_data(ii,:);
                key=0;
                if ac.T>=tsat
                    if ii ~=1
                        num1=tsat-(satheat_data(ii-1,:).T);
                        den1=ac.T-(satheat_data(ii-1,:).T);
                        if ac.T-tsat>0.000001
                            ratio = num1/den1;
                        else
                            ratio=0;
                        end
                        break_mark=counter_index;
                        key=1;
                        break
                    else
                        key = 0;
                    end
                end
                counter_index=counter_index+1;
            end
        else
            key=0;
        end
    else
        psat=p;
        if ~isnan(psat)
            [break_mark,ratio,key]=pressure_interpolator(row_size,sat_pressure_data,psat);
        else
            key=0;
        end
    end
    
    if key
        row1=satheat_data((break_mark-1),:);
        row2=satheat_data((break_mark),:);
        if ratio~=0
            hfh=row2{1,'Hf'};
            hfl=row1{1,'Hf'};
            hf1=(ratio*(hfh-hfl))+hfl;
            hgh=row2{1,'Hg'};
            hgl=row1{1,'Hg'};
            hg1=(ratio*(hgh-hgl))+hgl;
            sfh=row2{1,'Sf'};
            sfl=row1{1,'Sf'};
            sf1=(ratio*(sfh-sfl))+sfl;
            sgh=row2{1,'Sg'};
            sgl=row1{1,'Sg'};
            sg1=(ratio*(sgh-sgl))+sgl;
            vfh=row2{1,'Vf'};
            vfl=row1{1,'Vf'};
            vf1=(ratio*(vfh-vfl))+vfl;
            if strcmp(p,'')
                th=row2{1,'pressure'};
                tl=row1{1,'pressure'};
                ttemp=(ratio*(th-tl))+tl;
            else
                th=row2{1,'T'};
                tl=row1{1,'T'};
                ttemp=(ratio*(th-tl))+tl;
            end
            saturated_data=[hf1,hg1,sf1,sg1,vf1,ttemp];
        else
            hf1=row2{1,'Hf'};
            sf1=row2{1,'Sf'};
            hg1=row2{1,'Hg'};
            sg1=row2{1,'Sg'};
            vf1=row2{1,'Vf'};
            if strcmp(p,'')
                ttemp=row2{1,'pressure'};
            else
                ttemp=row2{1,'T'};
            end
            
            saturated_data=[hf1,hg1,sf1,sg1,vf1,ttemp];
        end
    else
        if strcmp(t,'')
            errordlg('sorry i donot have values for that pressure, choose a nicer pressure')
        else
            errordlg('sorry i donot have values for that temperature, choose a nicer temperature')
        end
        saturated_data='';
    end
end

function superheated_data = getSuperheatedValues(p1,t1,pressure_col_data,superheat_table)
    no_of_row_data=height(pressure_col_data);
    [break_mark,rat,key]=pressure_interpolator(no_of_row_data,pressure_col_data,p1);
    if ~isnan(t1)&& ~isnan(p1)
        key=1;
    else
        key=0;
    end
    if key
        t1_str=strcat('s',num2str(t1)); %s100
        row1=superheat_table((break_mark)-2,:); %low h value in table form
        row2=superheat_table((break_mark)-1,:); %low h value in table form
        row3=superheat_table((break_mark)+2,:); %high h value in table form
        row4=superheat_table((break_mark)+3,:); %high s value in table form
        edited_column_head=strrep(superheat_table.Properties.VariableNames,'s','');
        % replaces all occurences of 's' in superheat.Properties.VariableNames with ''
        temp_col_heads = str2double(edited_column_head(1,3:end)); % cols from s100 -- s..
        if rat==0
            if sum(ismember(temp_col_heads,t1))
                h1=row3{1,t1_str};
                s1=row4{1,t1_str};
            else
                cg=2;
                for g =temp_col_heads
                    if g>=t1
                        num2 =(t1)-temp_col_heads(1,cg-2);
                        den2 = g-temp_col_heads(1,cg-2);
                        ratio=num2/den2;
                        break
                    end
                    cg=cg+1;
                end
                hh=row3{1,strcat('s',num2str(g))};
                hlow=row3{1,strcat('s',num2str(temp_col_heads(1,cg-2)))};
                h1=(ratio*(hh-hlow))+hlow;
                sh=row4{1,strcat('s',num2str(g))};
                slow=row4{1,strcat('s',num2str(temp_col_heads(1,cg-2)))};
                s1=(ratio*(sh-slow))+slow;                          
            end
        else
            t1_str=strcat('s',num2str(t1));
            h1=(rat*(row3{1,t1_str}-row1{1,t1_str}))+row1{1,t1_str};
            s1=(rat*(row4{1,t1_str}-row2{1,t1_str}))+row2{1,t1_str};
    
        end
        superheated_data = [h1,s1];
    else
        superheated_data = '';
    end
end

function dhata=satliquid_update(counter_index,tdata,sat_pressure,satheat)
    psat=str2double(tdata(counter_index,2));
    t=''
    saturated_data=getSaturatedValues(psat,t,satheat,sat_pressure);
    if saturated_data
        if rem(counter_index,2)~=0
            tdata{counter_index,2}=tdata{counter_index-1,2};
            tdata{counter_index,3}=tdata{counter_index-1,3};
            tdata{counter_index,4}=tdata{counter_index-1,4};
            tdata{counter_index,5}=tdata{counter_index-1,5};
        else
            tdata{counter_index,2}=tdata{counter_index-2,2};
            tdata{counter_index,3}=saturated_data(6);
            tdata{counter_index,4}=saturated_data(1);
            tdata{counter_index,5}=saturated_data(3);
        end
        dhata=tdata; 
    else
        errordlg('sorry i donot have values for that pressure, choose a nicer pressure')
        dhata='';
    end
end

function [h1,ttemp]=superr(j,sup_pressure,superheat,tdata,s2,ts2,satheat,sat_pressure)
    p1=str2double(tdata{j,2});
    kk=height(sup_pressure);
    [an2,rat,lg]=pressure_interpolator(kk,sup_pressure,p1);
    if ~isnan(p1)
        lg=1;
    else
        lg=0;
    end
    if lg
        row1=superheat((an2)-2,:);
        row2=superheat((an2)-1,:);
        row5=superheat((an2)-4,:);
        row6=superheat((an2),:);
        t='';
        saturated_data=getSaturatedValues(p1,t,satheat,sat_pressure);
        row3=superheat((an2)+2,:);
        row4=superheat((an2)+3,:);
        z=strrep(superheat.Properties.VariableNames,'s','');
        ttcol = str2double(z(1,3:end));
        cg=3;
        if rat==0
            for rr = 12:-1:1
                tx=strcat('s',num2str(ttcol(1,rr)));
                sxx=row4{1,tx};
                hxx=row3{1,tx};
                pp=0;
                if sxx~=0
                    if sxx<=s2
                        ra=(s2-sxx)/(row4{1,strcat('s',num2str(ttcol(1,rr+1)))}-sxx);
                        if ischar(ts2)
                            ts2=str2double(ts2);
                        end
                        ttemp=((ts2-ttcol(1,rr))*ra)+ttcol(1,rr);
                        h1=((row3{1,strcat('s',num2str(ttcol(1,rr+1)))}-hxx)*ra)+hxx;
                        pp=1;
                        break
                    end
                else
                    pp=0;
                    break
                end
            end
            if ~pp
                sxx=row4{1,'sat'};
                hxx=row3{1,'sat'};
                rat=(s2-sxx)/(row4{1,'s400'}-sxx);
                ttemp= ((400-saturated_data(1,6))*rat)+saturated_data(1,6);
                h1=((row3{1,'s400'}-hxx)*rat)+hxx;
            end
        else
            errordlg('sorry i cannot perform this interpolation please choose a nicer pressure')
        end
    else
       h1=''; 
    end
end

function newsat = saton(tdata,sat_pressure,satheat,index,fheater_option,handles)
    pressure_matrix=[];
    mark=1;
    [row_size,~]=size(tdata(:,2));
    for cvar = 1:row_size
        if cvar==1
            if ischar(tdata{1,2})
                pressure_matrix(1,1)=str2double(tdata{1,2});
            else
                pressure_matrix(1,1)=tdata{1,2};
            end
        else
            if ischar(tdata{cvar,2})
                le=str2double(tdata{cvar,2});
            else
                le=tdata{cvar,2};
            end
            
            if ~ismember(pressure_matrix,le)
                if ischar(tdata{cvar,2})
                    pressure_matrix(1,mark)=str2double(tdata{cvar,2});
                else
                    pressure_matrix(1,mark)=tdata{cvar,2};
                end
                mark=mark+1;
            end
        end
    end
    if ~strcmp(fheater_option,'')
        pressure_matrix=pressure_matrix(pressure_matrix~=min(pressure_matrix));
    else
        pressure_matrix=sort(pressure_matrix);
        if strcmp(get(handles.btype,'string'),'S')&&str2double(get(handles.heatertext,'string'))==0
            pressure_matrix=[pressure_matrix(1,1),pressure_matrix(1,end)];
        else
            pressure_matrix=pressure_matrix(1,1:2);
        end
    end
    pressure_matrix=sort(pressure_matrix);
    [~,b]=size(pressure_matrix);
    newsat = {};
    for c = 1:b
        psat=pressure_matrix(1,c);
        kk=height(sat_pressure);
        [an2,rat,lg]=pressure_interpolator(kk,sat_pressure,psat);
        if ~isnan(psat)
            lg=1;
        else
            lg=0;
        end
        if lg
            row1=satheat((an2-1),:);
            row2=satheat((an2),:);
            if rat~=0
                hfh=row2{1,'Hf'};
                hfl=row1{1,'Hf'};
                sfh=row2{1,'Sf'};
                sfl=row1{1,'Sf'};
                th=row2{1,'T'};
                tl=row1{1,'T'};
                hf1=(rat*(hfh-hfl))+hfl;
                vfh=row2{1,'Vf'};
                vfl=row1{1,'Vf'};
                vf1=(rat*(vfh-vfl))+vfl;
                sf1=(rat*(sfh-sfl))+sfl;
                if strcmp(fheater_option,'')
                   
                    if c==1
                        tf1=(rat*(th-tl))+tl;
                        ttt=tf1;
                    else
                        kt=(((psat-newsat{c-1,1})*newsat{c-1,5}*100)+newsat{c-1,3})-newsat{c-1,3};
                        ttt=(kt/4.180)+newsat{c-1,2};
                    end
                else
                    if c==1
                        tf1=(rat*(th-tl))+tl;
                        ttt=tf1;
                    elseif c==b
                        kt=(((psat-newsat{c-1,1})*newsat{c-1,5}*100)+newsat{c-1,3})-newsat{c-1,3};
                        t='';
                        saturated_data=getSaturatedValues(newsat{c-1,1},t,satheat,sat_pressure);
                        ttt=(kt/4.180)+saturated_data(1,6);
                    else
                        kt=(((psat-newsat{c-1,1})*newsat{c-1,5}*100)+newsat{c-1,3})-newsat{c-1,3};
                        ttt=(kt/4.180)+newsat{c-1,2};
                    end
                    
                end
                
                h1=hf1;
                s1=sf1;
                v1=vf1;
                %ttt=tf1;
            else
                hf1=row2{1,'Hf'};
                sf1=row2{1,'Sf'};
                vf1=row2{1,'Vf'};
                tf1=row2{1,'T'};
                if strcmp(fheater_option,'')
                     
                    if c==1
                        ttt=tf1;
                    else
                        kt=(((psat-newsat{c-1,1})*newsat{c-1,5}*100)+newsat{c-1,3})-newsat{c-1,3};
                        ttt=(kt/4.180)+newsat{c-1,2};
                    end
                else
                    if c==1
                        ttt=tf1;
                    elseif c==b
                        kt=(((psat-newsat{c-1,1})*newsat{c-1,5}*100)+newsat{c-1,3})-newsat{c-1,3};
                        t='';
                        saturated_data=getSaturatedValues(newsat{c-1,1},t,satheat,sat_pressure);
                        ttt=(kt/4.180)+saturated_data(1,6);
                    else
                        kt=(((psat-newsat{c-1,1})*newsat{c-1,5}*100)+newsat{c-1,3})-newsat{c-1,3};
                        ttt=(kt/4.180)+newsat{c-1,2};
                    end
                end
                h1=hf1;
                s1=sf1;
                v1=vf1;
            end
            newsat{c,1}=psat;
            newsat{c,2}=ttt;
            newsat{c,3}=h1;
            newsat{c,4}=s1;
            newsat{c,5}=v1;
        else
            newsat='';
        end
        
    end
end

function dhata = arranger(tdata,sup_pressure,i,superheat,sat_pressure,satheat,handles,bt)
    lpturb=contains(tdata(:,1),'LP',2);
    if bt == 'S'
        %revise start
        p1=str2double(tdata{i,2});
        t1=str2double(tdata{i,3})
        if rem(i,2)~=0
            ghat =str2double(get(handles.heatertext,'string'));
            if ghat==0 || (ghat~=0 && i==1)
                superheated_data = getSuperheatedValues(p1,t1,sup_pressure,superheat);
                if superheated_data
                    tdata{i,4}=superheated_data(1);
                    tdata{i,5}=superheated_data(2);
                else
                    tdata{i,4}= 'bad';
                    tdata{i,5}='bad';
                end
                
            else
                tdata{i,3}=tdata{i-1,3};
                tdata{i,4}=tdata{i-1,4};
                tdata{i,5}=tdata{i-1,5};
            end
            
        else
            s2=tdata{i-1,5};
            ts2=0;
            ts2=tdata{i-1,3}
            t1='';
            saturated_data=getSaturatedValues(p1,t1,satheat,sat_pressure);
            xfrac = (s2-saturated_data(3))/(saturated_data(4)-saturated_data(3));
            if xfrac <1
                h1 = saturated_data(1) + ( (saturated_data(2) - saturated_data(1)) * xfrac);
                ttemp = saturated_data(6);
            elseif xfrac-1<0.002
                h1 = saturated_data(2);
                ttemp = saturated_data(6);
            else
                [h1,ttemp]=superr(i,sup_pressure,superheat,tdata,s2,ts2,satheat,sat_pressure);
            end
            
            tdata{i,3}=ttemp;
            tdata{i,4}=h1;
            tdata{i,5}=s2;
            dhata=tdata;
        end
    else
        if i ==1
            p1=str2double(tdata{i,2});
            t1=str2double(tdata{i,3});
            saturated_data=getSaturatedValues(p1,t1,satheat,sat_pressure);
            h1 = saturated_data(2);
            s1 = saturated_data(4);
        else
            p1=str2double(tdata{i,2});
            t='';
            s2=tdata{i-1,5};
            saturated_data=getSaturatedValues(p1,t,satheat,sat_pressure)
            xfrac = (s2-saturated_data(3))/(saturated_data(4)-saturated_data(3));
            h1 = saturated_data(1) + ( (saturated_data(2) - saturated_data(1)) * xfrac);
            s1=s2;
            
        end
        tdata{i,3}=saturated_data(6);
        tdata{i,4}=h1;
        tdata{i,5}=s1;
    end
    
    dhata=tdata;
end

function te = test(a,b)
    te = a+b
end