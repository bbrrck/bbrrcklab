function q = vec2vec_quat(v1,v2)

% https://stackoverflow.com/questions/1171849/finding-quaternion-representing-the-rotation-from-one-vector-to-another
% q = [w x y z]

d = dot(v1, v2);
if d > 0.999999
  q = [+1 0 0 0];
  return
end
  
if d < -0.999999
  q = [-1 0 0 0];
  return
end

q = zeros(1,4);
q(1) = d + sqrt(norm(v1)^2*norm(v2)^2); % q.w
q(2:4) = cross(v1,v2);                  % q.xyz
q = q / norm(q);                        % normalize

end
