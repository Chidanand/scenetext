clear;clc;
I_image = imread('C:\Users\John\Documents\MATLAB\svt\test\wordsPad\I00002.jpg');
load('C:\Users\John\Documents\convex project\data\BB_I00002.mat');
ch='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_';
load('bb_test')

bb1 = bbs(3,:);
bb2 = bbs(2,:);
I1 = I_image(bb1(1,2):min(bb1(1,2)+bb1(1,4),size(I_image,1)),bb1(1,1):min(bb1(1,1)+bb1(1,3),size(I_image,2)),:);
I2 = I_image(bb2(1,2):min(bb2(1,2)+bb2(1,4),size(I_image,1)),bb2(1,1):min(bb2(1,1)+bb2(1,3),size(I_image,2)),:);
  
nbins = 15;
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
dist = 0.5*sum( (vec1 - vec2).^2 ./ (vec1 + vec2 + eps) )


load('data\template\template_01');
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

nbins = 15;
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
dist = 0.5*sum( (vec1 - vec2).^2 ./ (vec1 + vec2 + eps) )
% bbs = bbs(idx(1:15),:);
% figure;imshow(I_image);charDetDraw(bbs,ch);