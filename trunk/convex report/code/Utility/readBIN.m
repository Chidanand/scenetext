function out = readBIN(f_data, f_label, len)
    fdata = fopen(f_data);   
    data = fread(fdata);
    data = data(17:end);
    
    flabel = fopen(f_label); 
    label = fread(flabel);
    label = label(9:end);
    
    for k = 1 : len
        I = data((k-1)*28^2+1: k*28^2);
        I = reshape(I, 28, 28)';
        l = label(k);
        out(k).I = I;
        out(k).label = l;
    end
end