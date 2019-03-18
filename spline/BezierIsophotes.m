%% Bezier surface, rendered with isophotes

% B�zier control net from [Farin 2002, p.249]
X = [
    0   2   4
    0   2   4
    0   2   4
];

Y = [
    0   0   0
    2   2   2
    4   4   4
];

Z = [
    0   0   0
    0   0   2
    0   4   4
];

degU = size(X,1)-1;
degV = size(X,2)-1;

% light direction, for isophotes
L = [-1 -1 -1];
L = L / norm( L );


% fast, with distorted isophotes
SAMPLES_U = 25;
SAMPLES_V = 25;

% % tradeout between speed and precision
% SAMPLES_U = 100;
% SAMPLES_V = 100;

% % slow
% SAMPLES_U = 250;
% SAMPLES_V = 250;


Points      = zeros( SAMPLES_U, SAMPLES_V, 3 );
IsoPhotes   = zeros( SAMPLES_U, SAMPLES_V );

u = linspace(0,1,SAMPLES_U);
v = linspace(0,1,SAMPLES_V);

% compute values in knot using Casteljau
KnotsU = 1:SAMPLES_U;
KnotsV = 1:SAMPLES_V;

for i = KnotsU,
    for j = KnotsV,
    
        Points(i,j,:) = CasteljauSurf( degU, degV, 0, 0, u(i), v(j), X, Y, Z );
        
        derU = CasteljauSurf( degU-1, degV, 1, 0, u(i), v(j), X, Y, Z ) - CasteljauSurf( degU-1, degV, 0, 0, u(i), v(j), X, Y, Z );
        derV = CasteljauSurf( degU, degV-1, 0, 1, u(i), v(j), X, Y, Z ) - CasteljauSurf( degU, degV-1, 0, 0, u(i), v(j), X, Y, Z );
    
        normal = cross( derU, derV );
        normal = normal / norm( normal );
        IsoPhotes(i,j) = dot( L, normal );
        
    end
end


%% value normalization not necessary, Matlab's colormap handles it
% IsoPhMin = min(min(IsoPh));
% IsoPhMax = max(max(IsoPh));
% 
% IsoPhRange = abs( IsoPhMax - IsoPhMin);
% IsoPhRangeR = 1/IsoPhRange;
% IsoPh    = (IsoPh - IsoPhMin) .* IsoPhRangeR;

ISOPHOTE_DENSITY = 5;
MAP_SIZE = 50;

Map = [
        1 - sin( linspace( 0, pi/2, MAP_SIZE ) ).^10 % try cos, it's fun!
        1 - sin( linspace( 0, pi/2, MAP_SIZE ) ).^25 % try cos, it's fun!
%         linspace(0,1,MAP_SIZE).^0.75
%         linspace(0,1,MAP_SIZE).^0.75
%         sin( linspace( 0, pi/2, MAP_SIZE ) ) % try cos, it's fun!
        ones( 1, MAP_SIZE )
    ]';
Map = [ Map; flipud(Map) ];
Map = repmat( Map, ISOPHOTE_DENSITY, 1); 


figure(gcf);
clf; hold on; axis equal; axis off;
colormap(Map)
surf( Points(:,:,1), Points(:,:,2), Points(:,:,3), IsoPhotes, 'LineStyle', 'none', 'FaceColor', 'interp' );
camlight headlight
% camlight left
% camlight right
lighting gouraud

