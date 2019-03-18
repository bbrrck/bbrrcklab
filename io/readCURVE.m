function [V,E] = readCURVE(filename)
    f = fopen(filename);
    nc = fscanf(f,'%d',1);
    
    V=[];
    E=[];
    e=0;
    for i=1:nc
        c = fscanf(f,'%d',3);
        np = c(1);
        p = reshape(fscanf(f,'%f',3*np),3,[])';
        V = [V; p];
        E = [E; e+(1:np-1)' e+(2:np)'];
        e = e+np;
    end
    fclose(f);
end

