function [n,Q,D,d,l] = least_squares_line(P)
% linear regression

  % C : centroid
  centroid = mean(P);
  % shifted data
  M = P-centroid;
  % normal of the line is the right singular vector of M
  [~,~,V] = svd(M,'econ');
  n = V(:,end)';
  % matrix of normals
  N = repmat(n,size(P,1),1);
  % points projected on the line
  Q = P - dot(M,N,2) .* N;

  % diameter of the dataset
  l = norm(max(P)-min(P));
  
  % distance of points from the line
  D = sqrt(sum((P-Q).^2,2));  
  % maximal distance
  d = max(D);

end