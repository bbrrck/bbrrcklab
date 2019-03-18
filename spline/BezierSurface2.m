% Patch degree
u = 6;
v = u;
% Control net
N = zeros(u+1,v+1,3);
[X,Y] = meshgrid(linspace(-u/2,u/2,u+1),linspace(-v/2,v/2,v+1));
Z = zeros(u+1);
Z(4,4) = 10;
N(:,:,1) = X;
N(:,:,2) = Y;
N(:,:,3) = Z;
% Parameter grid
samples = 20;
t = linspace(0,1,samples);
[U,V] = meshgrid(t,t);
% Compute surface points
ptime = tic;
S = casteljau_surf(u,v,0,0,U,V,N,3);

figure(gcf); cla; hold on; axis equal; axis on; grid on;
surf(S(:,:,1),S(:,:,2),S(:,:,3),'FaceColor',[1.0 0.6 0],'EdgeColor','none');
% surf(N(:,:,1),N(:,:,2),N(:,:,3),'FaceColor','None');
camlight;
material([0.8 0.2 0.5 10])
