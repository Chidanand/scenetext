% compute mask
clear;clc;close all;
ch='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_';

load('template')
template_01 = zeros(10000,36);
% load('template_01')
for i=1:36
%     subplot(6,6,i),imshow(reshape(template(:,i),100,100));
    idx = template(:,i) > 0.05;
    out = zeros(10000,1);
    out(idx) = 1;
    out = reshape(out,100,100);

%     out = template(:,i);
%     out = reshape(out,100,100);
    out = out(:,13:end-12);
    out = imresize(out,[100 100]);
    template_01(:,i) = out(:);
    subplot(6,6,i),imshow(reshape(template_01(:,i),100,100));
end
out2 = template_01(:,19);
out2 = reshape(out2,100,100);
out2 = out2(:,16:end-15);
figure;imshow(out2);
out2 = imresize(out2,[100 100]);
template_01(:,19) = out2(:);

% normalize tempalte to [0,1]
template_01 = template_01 + 0.01;
template_01 = template_01 / max(template_01(:));
save('template_01','template_01');