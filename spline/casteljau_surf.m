function S = casteljau_surf(k,l,i,j,u,v,Net,dim)
% S = Casteljau(k,l,i,j,u,v,Net,dim)
%
%   Compute the point V_{i,j}^{k,l} from the De Casteljau's algorithm
%   for parameter values (u,v).
%
%   V_{0,0}^{degU,degV} is a point one the surface.
%
    if k==0 && l==0
        S = repmat(Net(i+1,j+1,:),size(u)); % size(u)==size(v)
        return;
    elseif k > 0
        uu = repmat(u,1,1,dim);
        A = casteljau_surf(k-1,l,i  ,j,u,v,Net,dim);
        B = casteljau_surf(k-1,l,i+1,j,u,v,Net,dim);
        S = (1-uu).*A + uu.*B;
        return;
    else
        vv = repmat(v,1,1,dim);
        A = casteljau_surf(k,l-1,i,j  ,u,v,Net,dim);
        B = casteljau_surf(k,l-1,i,j+1,u,v,Net,dim);
        S = (1-vv).*A + vv.*B;
        return;
    end
end