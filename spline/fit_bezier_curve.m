function [X,d] = fit_bezier_curve(P,t,n,w)
%
% FITBEZIERCURVE Fit a cubic Bezier curve to a set of points P with
% associated parameter values t.
%
% Input : 
%   P  #Px3
%
%
% Example:
%   load('fit_bezier_curve_test_data.mat');
%   [V,d] = fit_bezier_curve(points,params,3);
%   t = linspace(0,1,100)';
%   X = casteljau_curve(0,d,t,V);
%   cla; view(2);
%   plot_points(points);
%   hold on;
%   plot_curve(X);
%   plot_points(V);
%   plot_curve(V);
%
%
% (2018) Tibor Stanko [https://tiborstanko.sk]
%
%

assert( size(P,1)==length(t) )

if nargin < 4
  w = ones(size(t));
end

% dimension of the input points
dim = size(P,2);
% get unique param values
[t_unique,~,mask] = unique(t);
% Bernstein polynomials
Bernstein = @(k,t) nchoosek(n,k).* (1-t).^(n-k) .* t.^k;
% init matrices
Lhs = zeros(n+1,n+1);
Rhs = zeros(n+1,dim);
% loop over n+1 rows
for i = 0:n
    % evaluate on unique params
    bi = Bernstein(i,t_unique);
    % get all params
    bi = w .* bi(mask);
    % Lhs : loop over n+1 columns
    for j = i:n
        bj = Bernstein(j,t_unique);
        bj = bj(mask);
        l = sum(bi.*bj);
        % the matrix is symmetric: (i,j)=(j,i)
        Lhs(i+1,j+1) = l;
        Lhs(j+1,i+1) = l;
    end
    % Rhs : loop over columns
    for j = 1:dim
        Rhs(i+1,j) = sum(bi.*P(:,j));
    end
end
% check the determinant and solve
if det(Lhs) < 1e-4 && n>2 
    % collinear, just fit line
    fprintf('\nWARNING\nin fit_bezier_curve:\n  detected almost collinear points\n  setting degree=1\n');
    d = 1;
    X = fit_bezier_curve(P,t,d);
else
    %fprintf('fit_bezier_curve, d=%d\n',n);
    d = n;
    X = Lhs \ Rhs;
end
