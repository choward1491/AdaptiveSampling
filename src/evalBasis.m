function y = evalBasis( x, index, ndim )

i = index - 1;
if( i == 0 )
    y = 1;
elseif( i <= ndim )
    y = x(i);
else
    i = i - ndim;
    L = ndim;
    start = 1;
    while( i > L )
        i = i - L;
        L = L - 1;
        start = start + 1;
    end
    
    y = x(start)*x(start+i-1);
    
end
    


end