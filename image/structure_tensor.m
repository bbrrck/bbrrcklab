function [Constraints,Weights,Visualise] = structure_tensor(I,B,X,Y)
% [V2,L2,w2] = StructureTensor(I,B)
% Compute minor eigenvectors/eigenvalues of the structure tensor.
% input
%   I  : greyscale image
%   B  : selected pixels (optional)
% output
%   V2 : minor eigenvectors
%   L2 : minor eigenvalues
%   w2 : associated weights

    switch nargin
        case 0
            [I,B,X,Y] = read_image('circles-cross.png',1);
        case 4
            % all good
        otherwise
            error('Wrong number of params')
    end
    
    P = [X Y];
    
    % helper function : normalized bilateral filter
    sigma_r = 23;
    sigma_s = 13;
    sigma = [sigma_s sigma_r];
    w = 1;
    
    normalized_bfilter = @(A) ...
        min(A(:)) + (max(A(:))-min(A(:))) .* bfilter2((A-min(A(:)))./(max(A(:))-min(A(:))),w,sigma);

    %% derivatives
    % [Kyprianidis & Kang 2011]
    % http://wwriteww.kyprianidis.com/p/eg2011/jkyprian-eg2011.pdf
    p1 = 0.183;
    Dx = 0.5*[
            p1  0    -p1
        1-2*p1  0 2*p1-1
            p1  0    -p1
    ];
    Dy = Dx';

    % derivatives
    fx = conv2(I,Dx,'same');
    fy = conv2(I,Dy,'same');

    % structure tensor S = [E F; F G]
    E = fx .* fx;
    F = fx .* fy;
    G = fy .* fy;
    
    % bilateral filtering    
    E = normalized_bfilter(E);
    F = normalized_bfilter(F);
    G = normalized_bfilter(G);   

    % convert to vectors
    E = E(:);
    F = F(:);
    G = G(:);
    H = sqrt((E-G).^2 + 4*F.^2);

    % eigenvalues
    L1 = (E + G + H) ./ 2;
    L2 = (E + G - H) ./ 2;
    
    % eigenvectors
    V1 = normr([F, L1-E]);
    V2 = normr([L1-E, -F]);
    
    % correct for numerical inaccuracies
    L1( L1 < 0 ) = 0;
    L2( L2 < 0 ) = 0;
    
    % extract
    L1 = L1(B);
    L2 = L2(B);
    V1 = V1(B,:);
    V2 = V2(B,:);
    
    %% Output
    Constraints = normr(V2);
    
    %% confidence weight : ratio of eigenvalues
    Weights = 1 - L2 ./ L1;
    % confidence threshold
    s = 0.66;
    % included points
    i = Weights > s;
    % excluded points
    e = ~i;
    % for visualisation
%     wV1 = repmat(Weights,1,2) .* V1;
%     wV2 = repmat(Weights,1,2) .* V2;
    wV1 = repmat(L2./L1,1,2) .* V1;
    wV2 = V2;
    % trim
    Weights(e) = 0;
    
    % stats
    fprintf('\texclude %d points (small confidence)\n',sum(~i));
        
    % plot - high confidence
    Visualise = struct;
    Visualise(1).pts = repmat(P(i,:),4,1);
    Visualise(1).vec = [
        +wV1(i,:)
        -wV1(i,:)
        +wV2(i,:)
        -wV2(i,:)
        ];
    Visualise(1).str = '>';

    % plot - low confidence
    Visualise(2).pts = repmat(P(e,:),4,1);
    Visualise(2).vec = [
        +wV1(e,:)
        -wV1(e,:)
        +wV2(e,:)
        -wV2(e,:)
        ];
    Visualise(2).str = '<';