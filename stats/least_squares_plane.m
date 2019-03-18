function [centroid,normal,A,P3,P2] = ...
    least_squares_plane(Data,Normals)

    N = size(Data,1);
    centroid = mean(Data);
    C = repmat(centroid,N,1);

    % matrix for least squares,
    % rows correspond to vectors from original points to their centroid
    M = Data - C;

    % if the normal is not given
    if nargin < 2
        % singular value decomposition of M
        [~,~,V] = svd(M);

        % the normal of the plane is the right-singular vector of M, stored in the last column of V
        % normal corresponds to the smallest singular value of M
        normal = V(:,end);
        normal = normal';
    else
        normal = mean(Normals,1);
    end
    
    normal = normal / norm(normal);
    
%     % orthonormal basis of the plane
%     basis_u = [ -normal(2) normal(1) 0 ];
%     basis_u = basis_u / norm( basis_u );
%     basis_v = cross( normal, basis_u );
%     plane_Basis = [ basis_u' basis_v' ];

    % init the P3s
    P3 = zeros(N,3);

    % compute the P3s
    for i=1:N
        P3(i,:) = Data(i,:) - dot(M(i,:),normal) * normal;
    end
    
    % vectors from projected points to centroid
    X = P3 - C;

%     % Cartesian coordinates of projected points with respect to the basis (c, u, v)
%     P2 = zeros(N,2);
%     for i=1:N,
%         P2(i,:) = plane_Basis \ L(i,:)';
%     end
    
    %% other way: transformation
    bz = normal;
    bx = [ -normal(2) normal(1) 0 ];
    bx = bx / norm( bx );
    by = cross(bz,bx);
    A = [bx' by' bz'];
    P2 = (A \ X')';
    P2(:,3) = [];
    
end

