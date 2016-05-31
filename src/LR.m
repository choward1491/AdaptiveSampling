function out = LR( xc, x, y, sigma, dist, order )
% Locally Weighted Regression
% Built to allow constant, linear, quadratic,
% and cubic local fits using Least Square
%
% currently experimenting with kernel
% function to weight data as a function of 
% the difference between the data locations
% and the location of the point we want to
% evaluate

d = sort(dist);
sigma = 1.2*std(d(1:5));
w = exp( - (dist/sigma).^2 );

if( order == 0 )
    X = ones(size(x));
elseif( order == 1 )
    X = [ones(size(x)), x ];
elseif( order == 2 )
    X = [ones(size(x)), x, x.^2 ];
elseif( order == 3 )
    X = [ones(size(x)), x, x.^2, x.^3 ];
end

Xt = X'*diag(w,0);
An = Xt*X;
yn  = Xt*y;
a = An\yn;




if( order == 0 )
    out = a(1);
elseif( order == 1 )
    out = a(1) + a(2)*xc;
elseif( order == 2 )
    out = a(1) + xc*( a(2) + xc*a(3) );
elseif( order == 3 )
    out = a(1) + xc*( a(2) + xc*(a(3) + xc*a(4)) );
end




end