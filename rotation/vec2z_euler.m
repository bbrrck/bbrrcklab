function [R,angles] = vec2z_euler(v)
% Returns a rotation (as 3x3 matrix and Euler angles XYZ) which brings v to z-axis.
  % normalize
  v = v(:) / norm(v);
  % quaternion of rotation
  q = vec2vec_quat([0 0 1]',v);
  % quaternion -> 3x3 rotation matrix
  options.method = 'cols';
  R = quat2rotm(q, options);
  % 3x3 rotation matrix -> Euler angles XYZ
  angles = rotm2euler(R);
end