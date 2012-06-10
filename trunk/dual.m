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

[V,D] = eig(Z);
v = V(:,end);
v(v>=.5) = 1;
v(v<.5) = 0;
v
cost = -s'*v + v'*A*v