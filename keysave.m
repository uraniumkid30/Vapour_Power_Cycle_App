function keyss=keysave(l)
keyss={};
for i=1:l
    keys=keyproduction();
    if rem(i,10000)==0
        fprintf('i have completed %d keys \n',i)
    end
    keyss{i,1}=keys;
end