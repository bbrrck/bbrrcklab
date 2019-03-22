function xyz = rotm2euler(R)
% MAT3_TO_EULER
% Extract Euler angles (x,y,z) from a 3x3 rotation matrix.

% from Geogram's <exploragram/hexdom/frame.h> :
%   if (std::abs(std::abs(r(2, 0)) - 1) > 1e-5) {
%       res[1] = -asin(r(2, 0));
%       res[0] = atan2(r(2, 1), r(2, 2));
%       res[2] = atan2(r(1, 0), r(0, 0));
%   } else {
%       res[2] = 0;
%       if (std::abs(r(2, 0) + 1) < 1e-5) {
%           res[1] = M_PI / 2.;
%           res[0] = atan2(r(0, 1), r(0, 2));
%       } else {
%           res[1] = -M_PI / 2.;
%           res[0] = atan2(-r(0, 1), -r(0, 2));
%       }
%   }

  xyz = [0 0 0];
  if abs( abs(R(3, 1)) - 1) > 1e-5
    xyz(2) = -asin( R(3, 1));
    xyz(1) = atan2( R(3, 2), R(3, 3));
    xyz(3) = atan2( R(2, 1), R(1, 1));
  else
    xyz(3) = 0;
    if abs(R(3,1) + 1) < 1e-5
      xyz(2) = pi / 2;
      xyz(1) = atan2( R(1, 2), R(1, 3));
    else
      xyz(2) = -pi / 2;
      xyz(1) = atan2(-R(1, 2), -R(1, 3));
    end
  end

end

