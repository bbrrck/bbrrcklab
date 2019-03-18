figure(gcf); clf; hold on; grid off; axis equal; 
% axis off;

A = [0 0];
u = [1 1];
v = [1 -1];
B = A + 0.5*(u+v);

% Bezier control points
V = zeros(4,2);
V(1,:) = A;
V(2,:) = A + u ./ 3;
V(3,:) = B - v ./ 3;
V(4,:) = B;

[X,Y,E] = HermiteCubic( A, B, u, v );
plot( X, Y, 'r-');
plot( V(:,1), V(:,2), 'r:' );

L = BezierLength( V, 1e-5 );
rL = 1 / L ;

A(1) = A(1) + 0.05;
u = u * rL; 
v = v * rL;
B = A + 0.5*(u+v);

V = zeros(4,2);
V(1,:) = A;
V(2,:) = A + u ./ 3;
V(3,:) = B - v ./ 3;
V(4,:) = B;

[X,Y,E] = HermiteCubic( A, B, u, v );
plot( X, Y, 'b-');
plot( V(:,1), V(:,2), 'b:' );

disp( sprintf( '\n\tred curve length = %f\n', L ) )
