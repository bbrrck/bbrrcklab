function [W,gaussian] = distance_weights(BW,varargin)
% DISTANCE_WEIGHTS compute per-pixel Gaussian weights based on the Euclidean 
% distance from the nearest black pixel.
   
    p = inputParser;
    validScalar = @(x) isnumeric(x) && isscalar(x);
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    
    addRequired(p,'BW',@islogical);
    addOptional(p,'clamp',0,validScalar);
    addOptional(p,'sigma',1,validScalarPosNum);
    
    parse(p,BW,varargin{:});
    
    normalize = @(x) (x-min(x(:))) ./ (max(x(:)) - min(x(:)));
    gaussian = @(x,s) exp(-0.5*(x./s).^2);

    % distance transform
    D = bwdist(~BW);
    
    % clamp
    if p.Results.clamp > 0
        D = min(D,p.Results.clamp);
    end
    
    % gaussian of normalized distance
    W = gaussian(normalize(D),p.Results.sigma);