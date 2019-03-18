function E = HermiteEnergy( A, B, u, v )
% compute the approximation of strain energy E of the curve: integral_(from 0 to 1) norm(f''(t)) dt
%   where f''(t) = a * t + b
%   and a, b are the following vectors:

  a =  6*( 2*(A - B) +   u + v);
  b = -2*( 3*(A - B) + 2*u + v);

  E = 0.3333 * (norm( a )).^2 + dot( a, b ) + (norm( b )).^2;

end

