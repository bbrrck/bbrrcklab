%%% 
%%%  TS 2015
%%% 
%%% 
function varargout = HermiteCubic( A, B, u, v, H )
%% Hermite Cubic Curve f(t)

    if nargin < 5,

        % sample the unit interval
        t = linspace(0,1,100);

        % Hermite polynomials
        H00 =  2*t.^3 - 3*t.^2 + 1;
        H01 =    t.^3 - 2*t.^2 + t;
        H10 =    t.^3 -   t.^2;
        H11 = -2*t.^3 + 3*t.^2;

        H = [H00; H01; H10; H11];

    end
    
    E = HermiteEnergy(A, B, u, v);

    % compute coordinates [X,Y,Z]
    X = A(1) * H(1,:) + u(1) * H(2,:) + v(1) * H(3,:) + B(1) * H(4,:);
    Y = A(2) * H(1,:) + u(2) * H(2,:) + v(2) * H(3,:) + B(2) * H(4,:);
    
    if nargout == 4,
        Z = A(3) * H(1,:) + u(3) * H(2,:) + v(3) * H(3,:) + B(3) * H(4,:);
        
        varargout{1} = X;
        varargout{2} = Y;
        varargout{3} = Z;
        varargout{4} = E;
    else
        varargout{1} = X;
        varargout{2} = Y;
        varargout{3} = E;
    end
    
end