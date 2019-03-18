function [V,N,E] = readRAWNETWORK(filename)

if nargin < 1
  filename = '../input/raw.network/torus.raw.network';
end

fp = fopen(filename, 'r');

vflag = fscanf(fp, '%s', 1);
nv = fscanf(fp, '%d', 1);

block = reshape(fscanf(fp, '%f', 7 * nv),7,[])';
V = block(:,2:4);
N = block(:,5:7);

E = [];
while(feof(fp) == 0)
  eflag = fscanf(fp, '%s', 1);
  if ~strcmp(eflag,'e')
    break;
  end
  ne = fscanf(fp, '%d', 1);
  nE = reshape(fscanf(fp, '%d', 3 * ne),3,[])';
  nE(:,1) = [];
  E = [E; nE];
end

  