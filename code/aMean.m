function f_hat=aMean(g,m,n)

fun = @(x) mean(x(:)); 

[mg, ng] = size(g);
f_hat = zeros(mg, ng);

m2 = floor((m-1)/2);
n2 = floor((n-1)/2);
g_pad = padarray(g, [m2 n2], 'replicate', 'both');

rows = 0:(m-1);
cols = 0:(n-1);

% create a waitbar if we are able
if images.internal.isFigureAvailable()
    wait_bar = waitbar(0,'Applying arithmetic mean filter...');
else
    wait_bar = [];
end

% Apply fun to each neighborhood of a
for ig=1:mg    
    for jg=1:ng
        x = g_pad(ig+rows,jg+cols);
        f_hat(ig,jg) = feval(fun,x);
    end
    
    % udpate waitbar
    if ~isempty(wait_bar)
        waitbar(ig/mg,wait_bar);
    end
end

close(wait_bar);