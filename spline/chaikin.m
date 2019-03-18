function X = chaikin(X,k)
% Chaikin subdivision for a closed curve
% n = number of iterations
d = size(X,2);
for i=1:k
    n = size(X,1);
    X1 = zeros(2*n,d);
    X1( 1:2:2*n,:) = 0.75 * X + 0.25 * X([2:end 1],:);
    X1( 2:2:2*n,:) = 0.25 * X + 0.75 * X([2:end 1],:);
    X = X1;
end

