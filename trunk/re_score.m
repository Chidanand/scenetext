function cost = re_score(wid,bbs,v,final_cost)

bbs = bbs(v==1,:);
n = size(bbs,1);

if n>1  % at least two characters
    center = zeros(2,n);
    for i=1:n
        center(:,i) = [bbs(i,1)+0.5*bbs(i,3) bbs(i,2)+0.5*bbs(i,4)];
    end
    [val idx] = sort(bbs(:,1));


    for i=1:n-1
        cen1 = center(:,idx(i));
        cen2 = center(:,idx(i+1));
        cent_dis(i) = (cen1-cen2)'*(cen1-cen2) / (wid^2);
%     cent_dis(i) = (cen1-cen2)'*(cen1-cen2);
    end
cost = var(cent_dis);
else
    cost = 1e5;
end