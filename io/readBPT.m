function patches = readBPT(filename,dim)
% patches = readBTP( filename, dim )
%   
%   Quick & dirty function to read Bezier patches' control nets
%   stored in a BPT format.
%   e.g. http://www.holmes3d.net/graphics/teapot/teapotrim.bpt
%
    file = fopen(filename);
    pcount = fscanf(file,'%i',1);
    patches = struct('deg',[],'cp',[]);
    for i=1:pcount,
        deg = fscanf(file,'%i',2);
        patches(i).deg = deg;
        vcount = (deg(1)+1)*(deg(2)+1);
        V = fscanf(file,'%f',[dim,vcount]);
        patches(i).verts = V';
    end
    fclose(file); 
end