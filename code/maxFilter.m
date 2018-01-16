function f_hat = maxFilter(g, m, n)
fun = @(x) max(x(:)); 
f_hat = nlfilter(g,[m n],fun);