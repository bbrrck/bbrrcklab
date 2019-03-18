function network = readNET(filename)

if nargin < 1,
    filename = 'data/torus.net';
end
f = fopen(filename);

% get first line
tline = fgetl(f);
parts = strsplit(tline);

if ~strcmp(parts(1),'v')
    error('Unexpected symbol: %s (expected v)',parts(1));
end

% number of vertices
v = str2double( parts(2) );

% number of nodes
n = str2double( parts(3) );

% generate nodes
nodes = 1:n;

% get positions and normals
VN = fscanf(f,'%f',6*v);
VN = reshape(VN,6,v);
VN = VN';
V = VN(:,1:3);
N = VN(:,4:6);

etag = fscanf(f,'%s',1);
if ~strcmp(etag,'e')
    error('Unexpected symbol: %s (expected e)',etag);
end
e = fscanf(f,'%i',1);
E = zeros(e,5);
c = 0; % curve count
epos = 0;
while ~feof(f)
    type = fscanf(f,'%s',1);
    if strcmp(type,'b')
        bd = 1;
    else
        bd = 0;
    end
    ee = fscanf(f,'%i',1)-1; % TODO : IF PROBLEMS, REMOVE THE -1
    if ee
        c = c+1;
        idx = epos+(1:ee);
        sorted = fscanf(f,'%i',ee+1);
        E(idx,1) = sorted(1:ee);
        E(idx,2) = sorted(2:ee+1);
        E(idx,3) = c;
        E(idx,4) = 1:ee;
        E(idx,5) = bd;
        epos=epos+ee;
    else
        break;
    end
end
fclose(f);

% fprintf('gnodes=[\n');
% fprintf(' %2d %2d %2d %2d %2d \n',nodes);
% fprintf(']\n');

network.V = V;
network.N = N;
network.E = E;
network.nodes = nodes;

end
