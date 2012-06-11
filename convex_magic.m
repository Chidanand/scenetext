% Solving for z
function configs = convex_magic(A,s)

n = length(s);
configs = zeros(n,3);

cvx_begin
    variable Z(n,n);
    variable z(n);
    minimize(trace(A*Z) - .5*s'*z)
    subject to 
        diag(Z) - .5*z == 0;
        [Z z; z' 1] == semidefinite(n+1);
cvx_end
cost = zeros(1,n);
for i=1:size(z)
    temp = z;
    thr = z(i);
    temp(temp>=thr) = 1;
    temp(temp<thr) = 0;
    cost(i) = -s'*temp + temp'*A*temp;
end
[~,idx] = sort(cost);
for i=1:3
    thr = z(idx(i));
    v = z;
    v(v>=thr) = 1;
    v(v<thr) = 0;
    configs(:,i) = v;
end


% [V,D] = eig(Z);
% v = V(:,end);
% v(v>=.5) = 1;
% v(v<.5) = 0;
% v
% cost = -s'*v + v'*A*v