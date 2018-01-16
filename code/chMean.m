function f_hat=chMean(g,m,n,Q)

fun = @(x,Q) contraharmmean(x(:),Q); 

[mg, ng] = size(g);
f_hat = zeros(mg, ng);

m2 = floor((m-1)/2);
n2 = floor((n-1)/2);
g_pad = padarray(g, [m2 n2], 'replicate', 'both');

rows = 0:(m-1);
cols = 0:(n-1);

% create a waitbar if we are able
if images.internal.isFigureAvailable()
    wait_bar = waitbar(0,sprintf('Applying contraharmonic mean filter (Q=%.1f)...',Q));
else
    wait_bar = [];
end

% Apply fun to each neighborhood of a
for ig=1:mg    
    for jg=1:ng
        x = g_pad(ig+rows,jg+cols);
        f_hat(ig,jg) = feval(fun,x,Q);
    end
    
    % udpate waitbar
    if ~isempty(wait_bar)
        waitbar(ig/mg,wait_bar);
    end
end

close(wait_bar);

function m = contraharmmean(x,Q)
xQ1 = x.^(Q+1);
xQ = x.^(Q);
m = sum(xQ1)/sum(xQ);
