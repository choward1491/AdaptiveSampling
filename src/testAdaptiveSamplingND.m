
center = [1;1];
f = @(x) 3*exp( -dot(x-center,x-center)/0.3 );

N = 20;
x0 = lhsdesign( N, 2 )*2;
x0 = x0';
y0 = zeros(N,1);
for i = 1:N
    y0(i) = f(x0(:,i));
end

M = 50;
[X,Y] = meshgrid( linspace(0,2,M), linspace(0,2,M) );
Z = zeros(size(X));
for i = 1:M
    for j = 1:M
        Z(i,j) = f([X(i,j);Y(i,j)]);
    end
end


% get basis
basis1 = genBasis(2,1);
basis2 = genBasis(2,2);
soln1 = zeros(size(Z));
soln2 = zeros(size(Z));

iter = 30;

err = zeros(iter,1);

for k = 1:iter
    
    dist = zeros(length(y0),1);
    coef = zeros(size(Z));
    
    % compute solution values
    for i = 1:M
        for j = 1:M
            xc = [X(i,j);Y(i,j)];
            
            for l = 1:length(y0)
                del = xc - x0(:,l);
                dist(l) = sqrt(dot(del,del));
            end
            
            soln1(i,j) = LR_ND( xc, x0, y0, basis1, dist);
            soln2(i,j) = LR_ND( xc, x0, y0, basis2, dist);
            coef(i,j) = 1e5/(min( dist  ) + 1e-5);
        end
    end
    
    PHI = abs(soln2-soln1)./coef;
    err(k) = norm(abs(soln2-Z),Inf);
    
    figure(1)
    plot( 1:k, err(1:k), 'b-o' )
    axis([1,iter,0,5])
    
end

