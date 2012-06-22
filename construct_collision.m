function [A C] = construct_collision(I_image,bbs,template_01)
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
        
        I1 = imcrop(I_image,bb1(1:4));
        I2 = imcrop(I_image,bb2(1:4));
        
        mask1 = imResize(reshape(template_01(:,bb1(1,6)),100,100),[size(I1,1) size(I1,2)]);
        mask2 = imResize(reshape(template_01(:,bb2(1,6)),100,100),[size(I2,1) size(I2,2)]);

        mask1_3d = repmat(mask1,[1 1 3]);
        mask2_3d = repmat(mask2,[1 1 3]);

        I1 = im2double(I1).*mask1_3d;
        I2 = im2double(I2).*mask2_3d;

        hist_1 = []; hist_2 = [];
        for k=1:3 % for each channel
            [n1,y] = imhist(I1(:,:,k),nbins);
            n1(1,1) = 0;
            hist_1 = [hist_1; n1/max(n1)];
            [n2,y] = imhist(I2(:,:,k),nbins);
            n2(1,1) = 0;
            hist_2 = [hist_2; n2/max(n2)];
        end
        vec1 = hist_1 / sum(hist_1);
        vec2 = hist_2 / sum(hist_2);
%         dist = 0.5*sum( (vec1 - vec2).^2 ./ (vec1 + vec2 + eps) );
        dist = norm(vec1-vec2,2);
        C(i,j) = dist;
    end
end
A = A + A';
A = A / max(A(:));
C = C + C';
C = C / max(C(:));