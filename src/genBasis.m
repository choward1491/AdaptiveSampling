function basis = genBasis( dim, order )
%GENBASIS Summary of this function goes here
%   Detailed explanation goes here

% Basis input dimensions
basis.dim = dim;

% Get basis size
basis.size = 1;
if( order == 1 )
    basis.size = basis.size + dim;
elseif( order == 2 )
    basis.size = basis.size + dim + 0.5*dim*(dim+1);
end

% setup function for evaluating basis
basis.eval = @(x,index) evalBasis(x,index,basis.dim);


end

