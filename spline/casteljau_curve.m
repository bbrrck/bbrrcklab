function P = casteljau_curve(i,k,t,V)

    dim = size(V,2);

    if any(t < 0) || any(t > 1)
        error('t must be from [0,1]');
    end
    
    t = t(:);

    if k < 0
        error('k cannot be less than 0.');
    elseif k == 0
        P = V(i+1,:);
    else
        P = ...
            repmat(1-t,1,dim) .* casteljau_curve(i,k-1,t,V) + ...
            repmat(  t,1,dim) .* casteljau_curve(i+1,k-1,t,V);
    end
    
end