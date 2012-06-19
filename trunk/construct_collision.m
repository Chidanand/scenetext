function [A C] = construct_collision(I_image,bbs)
n = size(bbs,1);

% First feature (collision)
A = zeros(n,n);
C = zeros(n,n);
nbins = 15;
for i=1:n
    for j=i+1:n
        bb1 = bbs(i,:);
        bb2 = bbs(j,:);
        inters = bbApply( 'intersect', bb1, bb2 );
        totalarea = bbApply( 'area', bb1) + bbApply( 'area', bb2);
        percent = bbApply( 'area', inters )/totalarea;
        A(i,j) = percent;

        I1 = I_image(bb1(1,2):min(bb1(1,2)+bb1(1,4),size(I_image,1)),bb1(1,1):min(bb1(1,1)+bb1(1,3),size(I_image,2)),:);
        I2 = I_image(bb2(1,2):min(bb2(1,2)+bb2(1,4),size(I_image,1)),bb2(1,1):min(bb2(1,1)+bb2(1,3),size(I_image,2)),:);
        hist_1 = []; hist_2 = [];
        for k=1:3 % for each channel
            [n1,y] = imhist(I1(:,:,k),nbins);
            hist_1 = [hist_1; n1/max(n1)];
            [n2,y] = imhist(I2(:,:,k),nbins);
            hist_2 = [hist_2; n2/max(n2)];
        end
        vec1 = hist_1 / sum(hist_1);
        vec2 = hist_2 / sum(hist_2);
        dist = 0.5*sum( (vec1 - vec2).^2 ./ (vec1 + vec2 + eps) );
        C(i,j) = dist;
    end
end
A = A + A';
A = A / max(A(:));
C = C + C';
C = C / max(C(:));