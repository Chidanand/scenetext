% Solving for z
function v = convex_magic(A,s)
% A = [0 .5 0 0;
%     .5 0 .5 0 ;
%      0 .5 0 .5;
%      0 0  .5 0];
 
% s = [1; 1; 1; 2];

n = length(s);

cvx_begin
    variable Z(n,n);
    variable z(n);
    minimize(.5*trace(A*Z) - .5*s'*z)
    subject to 
        diag(Z) - .5*z == 0;
        [Z z; z' 1] == semidefinite(n+1);
cvx_end
v = z;
cost = zeros(1,n);
for i=1:size(z)
    temp = z;
    thr = z(i);
    temp(temp>=thr) = 1;
    temp(temp<thr) = 0;
    cost(i) = -s'*temp + 0.5*temp'*A*temp;
end
[val idx] = min(cost);
thr = z(idx);
v(v>=thr) = 1;
v(v<thr) = 0;


% [V,D] = eig(Z);
% v = V(:,end);
% v(v>=.5) = 1;
% v(v<.5) = 0;
% v
% cost = -s'*v + v'*A*v