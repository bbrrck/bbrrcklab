function xyz = quat2euler(q)
  options.method = 'cols';
  R = quat2rotm(q, options);
  xyz = rotm2euler(R);
end