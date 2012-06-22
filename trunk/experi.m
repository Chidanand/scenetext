clear;clc;close all;
%%
I_image = imread('C:\Users\John\Documents\MATLAB\svt\test\wordsPad\I00002.jpg');
load('C:\Users\John\Documents\convex project\data\BB_I00002.mat');
ch='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_';
load('bb_test')

bb1 = bbs(3,:);
bb2 = bbs(14,:);

%%
I1 = imcrop(I_image,bb1(1:4));
I2 = imcrop(I_image,bb2(1:4));
figure(1);
subplot(3,2,1);imshow(I1);
subplot(3,2,2);imshow(I2);

nbins = 30;
hist_1 = []; hist_2 = [];
for k=1:3 % for each channel
    [n1,y] = imhist(I1(:,:,k),nbins);
    hist_1 = [hist_1; n1/max(n1)];
    [n2,y] = imhist(I2(:,:,k),nbins);
    hist_2 = [hist_2; n2/max(n2)];
end
vec1 = hist_1 / sum(hist_1);
vec2 = hist_2 / sum(hist_2);
% dist = 0.5*sum( (vec1 - vec2).^2 ./ (vec1 + vec2 + eps) )
dist = norm(vec1-vec2,2)
%%
load('data\template\template_01');
I1_ori = imcrop(I_image,bb1(1:4));
I2_ori = imcrop(I_image,bb2(1:4));

mask1 = imResize(reshape(template_01(:,bb1(1,6)),100,100),[size(I1,1) size(I1,2)]);
mask2 = imResize(reshape(template_01(:,bb2(1,6)),100,100),[size(I2,1) size(I2,2)]);
subplot(3,2,3);imshow(mask1);
subplot(3,2,4);imshow(mask2);

mask1_3d = repmat(mask1,[1 1 3]);
mask2_3d = repmat(mask2,[1 1 3]);

I1 = im2double(I1_ori).*mask1_3d;
I2 = im2double(I2_ori).*mask2_3d;
subplot(3,2,5);imshow(I1);
subplot(3,2,6);imshow(I2);

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
% dist = 0.5*sum( (vec1 - vec2).^2 ./ (vec1 + vec2 + eps) )
dist = norm(vec1-vec2,2)
% bbs = bbs(idx(1:15),:);
% figure;imshow(I_image);charDetDraw(bbs,ch);

%%
% I1_ori = imcrop(I_image,bb1(1:4));
% I2_ori = imcrop(I_image,bb2(1:4));
% M1 = mser_compute(I1_ori);
% M2 = mser_compute(I2_ori);
% figure(2);
% subplot(2,2,1);imshow(M1);
% subplot(2,2,3);imshow(M2);
% 
% M1 = repmat(M1,[1 1 3]);
% M2 = repmat(M2,[1 1 3]);
% 
% subplot(2,2,2);imshow(I1_ori.*uint8(M1));
% subplot(2,2,4);imshow(I2_ori.*uint8(M2));
% 
% Im1 = I1_ori.*uint8(M1);
% Im2 = I2_ori.*uint8(M2);
% nbins = 15;
% hist_1 = []; hist_2 = [];
% for k=1:3 % for each channel
%     [n1,y] = imhist(Im1(:,:,k),nbins);
%     n1(1,1) = 0;
%     hist_1 = [hist_1; n1/max(n1)];
%     [n2,y] = imhist(Im2(:,:,k),nbins);
%     n2(1,1) = 0;
%     hist_2 = [hist_2; n2/max(n2)];
% end
% vec1 = hist_1 / sum(hist_1);
% vec2 = hist_2 / sum(hist_2);
% dist = 0.5*sum( (vec1 - vec2).^2 ./ (vec1 + vec2 + eps) )

%%
% I = imread('C:\Users\John\Documents\MATLAB\svt\test\wordsPad\I00002.jpg');
% % pfx = fullfile(vl_root,'data','spots.jpg') ;
% % I = imread(pfx) ;
% image(I) ; 
% I = uint8(rgb2gray(I)) ;
% 
% [r,f] = vl_mser(I,'MinDiversity',0.7,...
%                 'MaxVariation',0.2,...
%                 'Delta',10) ;
%             
% f = vl_ertr(f) ;
% vl_plotframe(f) ;
% 
% M = zeros(size(I)) ;
% for x=r'
%  s = vl_erfill(I,x) ;
%  M(s) = M(s) + 1;
% end

% figure(2) ;
% clf ; imagesc(I) ; hold on ; axis equal off; colormap gray ;
% [c,h]=contour(M,(0:max(M(:)))+.5) ;
% set(h,'color','y','linewidth',3) ;