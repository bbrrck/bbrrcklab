function L = BezierLength( ControlPolygon, epsilon )

    n = size(ControlPolygon, 1) - 1;
    dim = size(ControlPolygon, 2);

    Lp = sum(sqrt(sum(abs( ControlPolygon(2:end,:) - ControlPolygon(1:end-1,:) ).^2,2)));
    Lc = norm( ControlPolygon(end,:) - ControlPolygon(1,:) );
    
    if Lp - Lc < epsilon,
        L = (2*Lc + (n-1)*Lp) / (n + 1);
    
    else
        
        [CLeft,CRight] = BezierSubdivide( ControlPolygon, 0.5 );
        
        L = BezierLength( CLeft, epsilon/2 ) + BezierLength( CRight, epsilon/2 );
    
    end

end

