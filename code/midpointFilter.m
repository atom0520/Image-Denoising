function f_hat = midpointFilter(g, m, n)
fun = @(x) ( min(x(:))+max(x(:)) )/2; 
f_hat = nlfilter(g,[m n],fun);