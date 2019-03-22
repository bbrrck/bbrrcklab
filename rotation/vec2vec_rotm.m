function R = vec2vec_rotm(v1,v2)
  q = vec2vec_quat(v1,v2);
  options.method = 'cols';
  R = quat2rotm(q, options);
end

