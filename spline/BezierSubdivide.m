function [L, R] = BezierSubdivide( ControlPolygon, t )

    deg = size(ControlPolygon, 1) - 1;
    dim = size(ControlPolygon, 2);

    L = zeros(deg+1,dim);
    for i=0:deg,
        L(i+1,:) = Casteljau1d(0,i,t,ControlPolygon);
    end

    R = zeros(deg+1,dim);
    for i=0:deg,
        R(i+1,:) = Casteljau1d(i,deg-i,t,ControlPolygon);
    end


end

