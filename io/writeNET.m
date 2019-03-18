function writeNET(V,N,E,filename,options)
%  WRITENET
%  Export .NET network file.
%    V : #V x 3     vertex positions
%    N : #V x 3     vertex normals
%    E : #E x 5     network topology
%             1 : v1    edge start
%             2 : v2    edge end
%             3 : c     curve index
%             4 : o     order of edge in curve
%             5 : t     curve type; boundary=1, interior=0
%
%  2016-2017 Tibor Stanko
%  tibor.stanko@gmail.com
%

% make sure data are consitent
assert( numel(V)==numel(N) );
assert( max(max(E(:,1:2))) == size(V,1) );

if nargin < 5,
    options = struct();
end

%% write to file
% open file
f = fopen(filename,'w');

% write numpoints
fprintf(f,'v %i %i',size(V,1),max(E(:,3)));
% write numnodes
if isfield(options,'nodes'),
    fprintf(f,' %i',length(options.nodes));
end
fprintf(f,'\n');

% write positions, normals
fprintf(f,' %+8.8f %+8.8f %+8.8f   %+8.8f %+8.8f %+8.8f\n',[V N]');

% write numedges
fprintf(f,'e %i\n',size(E,1));

% for each curve
for c = unique(E(:,3))',
    if E( E(:,3)==c,5) == 1,
        type = 'b';
    else
        type = 'i';
    end
    
    % extract edges
    edges = E(E(:,3)==c,:);
    sorted = [edges(:,1);edges(end,2)]';
    
    % write edges
    fprintf(f,' %s %i\n',type,length(sorted));
    fprintf(f,'  %i\n',sorted);
end

%% close the file
fclose(f);

if isfield(options,'verbose'),
    if options.verbose==1,
        disp(['Network written to ' filename]);
    end
end
