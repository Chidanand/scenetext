function A = construct_collision(bbs)
n = size(bbs,1);
A = zeros(n,n);

for i=1:n
    for j=i+1:n
        bb1 = bbs(i,:);
        bb2 = bbs(j,:);
        inters = bbApply( 'intersect', bb1, bb2 );
        uin = bbApply( 'union', bb1, bb2 );
        A(i,j) = bbApply( 'area', inters ) / bbApply( 'area', uin );
    end
end

A = A + A';
A = A / max(A(:));