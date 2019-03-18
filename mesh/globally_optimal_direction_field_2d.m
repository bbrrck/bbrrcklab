function X = globally_optimal_direction_field_2d (V,F,Ci,Ca,Cw,s,k)
% GLOBALLY_OPTIMAL_DIRECTION_FIELD_2D computes smooth k-RoSy directional field
% by minimizing the Dirichlet energy subject to boundary constraints (alignment)
%
% Input is a planar triangle mesh and a set of constraints: per-vertex
% angles and confidence weights (e.g. from structure tensor).
%
% X = globally_optimal_direction_field_2d (V,F,Ci,Ca,Cw,s,k)
%
% Inputs :
%   V   #Vx2 matrix of vertex coordinates
%   F   #Fx3 matrix of indices of triangles
%   Ci  #Cx1 indices of constrained vertices
%   Ca  #Cx1 directions (angles) at constrained vertices
%   Cw  #Cx1 weights of constrained vertices
%   s   weight of soft alignment constraints in [0,1)
%   k   number of directions in the k-RoSy field
%
% Output :
%   X   #Vx1 vector of per-vertex complex representatives
%
% Example:
%{   
    [V,F] = readOBJfast('./data/bunny2D.obj');
    E = outline(F);
    T = V(E(:,2),:)-V(E(:,1),:);
    Ci = E(:,1);
    Ca = atan2(T(:,2),T(:,1));
    k = 4;
    X = globally_optimal_direction_field_2d(V,F,Ci,Ca,1,0.9,k);
    a = angle(X);
    s = abs(X);
    l = edge_lengths(V,F);
    options.Scale = 0.5*mean(l(:));
    cla; axis equal; axis off; hold on;
    for i=0:k-1
        ai = (a + i*2*pi) ./ k;
        plot_vectors(V(:,[1 2]),s.*[cos(ai),sin(ai)],options);
    end
%}
%
% Paper:
%   [Crane et al. 2013] “Globally optimal direction fields”
%   https://www.cs.cmu.edu/~kmcrane/Projects/GloballyOptimalDirectionFields/paper.pdf
%
%
% (2018) Tibor Stanko
%
%

    % number of vertices
    nv = size(V,1);
    
    % number of constraints
    nc = length(Ci);

    % Dirichlet energy
    % a) cotangent Laplacian
    L = cotmatrix(V,F);
    % b) uniform Laplacian
    %%A = adjacency_mtatrix(F); L=A-diag(sum(A)); clear A;
    
    % soft constraints with per-vertex weights
    S = sparse(1:nc,Ci,Cw,nc,nv);
        
    % representative vector with per-vertex weights
    R = cos(k * Ca) + 1i * sin(k * Ca);
    R = Cw .* R;

    % build the system
    A = (1-s) * (L' * L) + s * (S' * S);
    B =                    s * (S' * R);
    
    % solve
    X = A \ B;
    