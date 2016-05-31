% Test Script

N = 5;
M = 5;
f = @(x) sin(20*x);
%f = @(x) sin(3*x).*cos(8*x + 0.3);
%f = @(x) heaviside(x - pi/2 ) + heaviside( x - pi/6 );
%f = @(x) 30*exp(-x) + 10*exp(x);
%f = @(x) 1 + 3*exp(-(x-pi/2).^2/0.05 )
%f = @(x) 2*x + sin(5*x).*cos(x);
sigma0 = 0.5;

x0 = sort(rand(N,1)*pi);
y0  = f(x0);
xe = linspace(0,pi,500)';
ye = f(xe);

num_iter = 100;
err = zeros(num_iter,1);

for k = 1:num_iter

    sigma = 0.1 + 0.7*exp(-1e-1*k);
    
% loop through and generate linear solution
soln1 = zeros(size(ye));
for i = 1:length(xe)
    soln1(i) = LR(xe(i),x0,y0,sigma,abs(x0-xe(i)),1);
end

% loop through and generate quadratic soln
soln2 = zeros(size(ye));
for i = 1:length(xe)
    soln2(i) = LR(xe(i),x0,y0,sigma,abs(x0-xe(i)),3);
end

% Compute Error surface
E = abs( soln2 - soln1 );
err(k) = sqrt(dot(E,E))/length(E);
emax = max(E);

for j = 1:length(xe)
    xl = xe(j)
    dm = 100/(min( abs(xe(j) - x0)  ) + 1e-5);
    dm
    E(j) = E(j)/dm/1000;
end

figure(1)
plot( x0, y0, 'go', xe, ye, 'b-', xe, soln1, 'r-', xe, soln2, 'k--', xe, E, 'c-^','MarkerFaceColor','k')
xlabel('X','FontSize',16)
ylabel('Y','FontSize',16)
title(['Truth vs Estimates, Iter=',num2str(k)],'FontSize',16)
legend({'Data','Truth','Estimate1','Estimate2', 'Error'})

figure(2)
plot( 1:k, err(1:k), 'b-')
axis([1,num_iter,0,10])
xlabel('X','FontSize',16)
ylabel('Y','FontSize',16)
title(['True Error, Iter=',num2str(k)],'FontSize',16)
legend({'Error'})

X0 = 0;

func = @(x) @(x) LR(x,xe,-E,0.1,abs(xe-x).^2,2);
xn = zeros(10,1);
yn = zeros(10,1);
xg = rand(10,1)*pi;

for i = 1:10
    xn(i) = fminunc( @(x) LR(x,xe,-E,0.1,abs(xe-x).^2,2) , xg(i));
    if( xn(i) < 0 )
        xn(i) = 0;
    elseif( xn(i) > pi )
        xn(i) = pi;
    end
    xn(i)
    yn(i) = LR(xn(i),xe,-E,0.1,abs(xe-xn(i)).^2,2);
end

soln3 = zeros(size(ye));
for i = 1:length(xe)
    soln3(i) = LR(xe(i),xe,-E,0.1,abs(xe-xe(i)).^2,2);
end

figure(3)
plot(xe,soln3)

Xt = xn(yn==min(yn));
X = Xt(1)

X0 = X;
x0 = [x0; X];
y0 = [y0; f(X)];

pause(0.1)

end
