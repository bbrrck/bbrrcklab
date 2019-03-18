function X = normr(X)
    l = sqrt(sum(X.^2,2));
    mask = l>0;
    X(mask,:) = X(mask,:) ./ l(mask);
end