s = 20;
d = 3;
patches = readBPT('data/bpt/teapotCGA.bpt',d); % data from http://www.holmes3d.net/graphics/teapot/

LightPos = [1 1 1];
l=light;
l.Position=LightPos;

cmap = [
    repmat([0 0 0],1000,1)
    repmat([1 1 1],1000,1)
];
cmap(cmap<0)=0;
cmap(cmap>1)=1;
cmap = repmat(cmap,1,1);
colormap(cmap);

colormap(parula);
cla; a=gca; a.Clipping = 'off';

for patch = patches
    du = patch.deg(1);
    dv = patch.deg(2);
    net = reshape(patch.verts,du+1,dv+1,d);
    t = linspace(0,1,s);
    [u,v] = meshgrid(t,t);
    
    V = casteljau_surf(du,dv,0,0,u,v,net,d);
    [F,V] = surf2patch(...
        V(:,:,1),...
        V(:,:,2),...
        V(:,:,3) ...
    );
    F = [
        F(:,[1 2 3]);
        F(:,[3 4 1]);
    ];
    N = per_vertex_normals(V,F);

%     X = casteljau_surf(du-1,dv-1,1,1,u,v,net,d);
%     Y = casteljau_surf(du-1,dv,1,0,u,v,net,d);
%     [~,X] = surf2patch(...
%         X(:,:,1),...
%         X(:,:,2),...
%         X(:,:,3) ...
%     );
%     [~,Y] = surf2patch(...
%         Y(:,:,1),...
%         Y(:,:,2),...
%         Y(:,:,3) ...
%     );
%     
%     X = normr(X);
%     Y = normr(Y);
%     Z = cross(X,Y);
%     Z = normr(Z);
%     options.Scale = 0.1;
%     options.Color = 'r';
%     plot_vectors(V,X,options);
%     options.Color = 'g';
%     plot_vectors(V,Y,options);
%     options.Color = 'b';
%     plot_vectors(V,Z,options);
%     options.Color = 'k';
%     plot_vectors(V,N,options);
        
    tsurf(F,V,'FaceVertexCData',.5*N+.5);
    shading interp;
    hold on;
end