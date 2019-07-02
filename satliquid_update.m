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