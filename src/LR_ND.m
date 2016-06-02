function out = LR_ND( xc, x, y, basis, dist )
% Locally Weighted Regression for N-D
% Built to allow constant, linear, quadratic,
% and cubic local fits using Least Square
%
% currently experimenting with kernel
% function to weight data as a function of 
% the difference between the data locations
% and the location of the point we want to
% evaluate

d = sort(dist);
sigma = 3*std(d(1:5))
w = exp( - (dist/sigma).^2 );
%w = ones(size(dist));
ndata = length(x(1,:));
X = zeros( ndata, basis.size);

for i = 1:ndata
    xd = x(:,i);
    for j = 1:basis.size
        X(i,j) = basis.eval(xd,j);
    end
end

Xt = X'*diag(w,0);
An = Xt*X;
yn  = Xt*y;
a = An\yn;

out = 0;
for j = 1:basis.size
    out = out + a(j) * basis.eval(xc,j);
end


end
