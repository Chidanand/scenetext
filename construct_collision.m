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
        
        
        I1_ori = I_image(bb1(1,2):min(bb1(1,2)+bb1(1,4),size(I_image,1)),bb1(1,1):min(bb1(1,1)+bb1(1,3),size(I_image,2)),:);
        I2_ori = I_image(bb2(1,2):min(bb2(1,2)+bb2(1,4),size(I_image,1)),bb2(1,1):min(bb2(1,1)+bb2(1,3),size(I_image,2)),:);
        mask1 = imResize(reshape(template_01(:,bb1(1,6)),100,100),[size(I1_ori,1) size(I1_ori,2)]);
        mask2 = imResize(reshape(template_01(:,bb2(1,6)),100,100),[size(I2_ori,1) size(I2_ori,2)]);
        mask1_3d = zeros(size(mask1,1),size(mask1,2),3);
        mask2_3d = zeros(size(mask2,1),size(mask2,2),3);
        mask1_3d(:,:,1) = mask1;mask1_3d(:,:,2) = mask1;mask1_3d(:,:,3) = mask1;
        mask2_3d(:,:,1) = mask2;mask2_3d(:,:,2) = mask2;mask2_3d(:,:,3) = mask2;
        I1 = im2double(I1_ori).*mask1_3d;
        I2 = im2double(I2_ori).*mask2_3d;
%         figure(1);imshow(I1);
%         figure(2);imshow(I2);
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
        dist = 0.5*sum( (vec1 - vec2).^2 ./ (vec1 + vec2 + eps) );
        C(i,j) = dist;
    end
end
A = A + A';
A = A / max(A(:));
C = C + C';
C = C / max(C(:));