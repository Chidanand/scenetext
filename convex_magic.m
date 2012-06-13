% Solving for z
function [v final_cost] = convex_magic(A,s)

n = length(s);
configs = zeros(n,2);

cvx_begin
    variable Z(n,n);
    variable z(n);
    minimize(trace(A*Z) - .5*s'*z)
    subject to 
        diag(Z) - .5*z == 0;
        [Z z; z' 1] == semidefinite(n+1);
cvx_end
cost = zeros(1,n);

% [V,~] = eig(Z);
% v = V(:,end);
% for i=1:size(v)
%     temp = v;
%     thr = v(i);
%     temp(temp>=thr) = 1;
%     temp(temp<thr) = 0;
%     cost(i) = -s'*temp + temp'*A*temp;
% end
% [~,idx] = sort(cost);
% thr = v(idx(1));
% v(v>=thr) = 1;
% v(v<thr) = 0;
% configs(:,1) = v;
% 
% v = V(:,end-1);
% for i=1:size(v)
%     temp = v;
%     thr = v(i);
%     temp(temp>=thr) = 1;
%     temp(temp<thr) = 0;
%     cost(i) = -s'*temp + temp'*A*temp;
% end
% [~,idx] = sort(cost);
% thr = v(idx(1));
% v(v>=thr) = 1;
% v(v<thr) = 0;
% configs(:,2) = v;

for i=1:size(z)
    temp = z;
    thr = z(i);
    temp(temp>=thr) = 1;
    temp(temp<thr) = 0;
    cost(i) = -s'*temp + temp'*A*temp;
end
[val,idx] = sort(cost);
thr = z(idx(1));
v = z;
v(v>=thr) = 1;
v(v<thr) = 0;
final_cost = val(1);
% configs(:,3) = v;


% [V,D] = eig(Z);
% v = V(:,end);
% v(v>=.5) = 1;
% v(v<.5) = 0;
% v
% cost = -s'*v + v'*A*v