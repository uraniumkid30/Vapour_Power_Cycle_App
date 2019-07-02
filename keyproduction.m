function keys=keyproduction()
numerals = 0:9;
letters = {'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'};
idx = randperm(numel(numerals)); % randomly permutate the size
idx2 = randperm(numel(letters{1,1}));
idx3 = randperm(numel(letters{1,2}));
word='';
for i = num2str(numerals(idx(1:10)))
    word=strcat(word,i);
end
k=strcat(word,letters{1,1}(idx2(1:19)),letters{1,2}(idx3(1:19)));
idx4 = randperm(numel(k));
keys = k(idx4(1:48));

    

