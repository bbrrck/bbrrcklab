function writePOLY(filename,V,E,H)
%writePOLY
% export .poly file for Triangle.

if nargin < 4
    % generate holes
    H = round(max(V))+[10 10];
    
    if nargin < 3
        % generate edges
        E = [1:size(V,1); 2:size(V,1) 1]';
    end
end

% open file
f = fopen(filename,'w');
% positions
v = size(V,1);
fprintf(f,'%i %i %i %i\n',v,2,0,0);
fprintf(f,'  %i %f %f\n',[1:v; V']);
% edges
e = size(E,1);
fprintf(f,'%i %i\n',e,0);
fprintf(f,'  %i %i %i\n',[1:e; E']);
% generate holes
h = size(H,1);
fprintf(f,'%i\n',h);
fprintf(f,'  %i %f %f\n',[1:h; H']);
% close file
fclose(f);

end

