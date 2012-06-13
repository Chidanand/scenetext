% Picture generator
clear;clc;close all;
addpath('Utility', 'export_fig');
I = imread('pic_1.png');
imshow(I)
set(gcf, 'color', 'w');
export_fig('../fig/pic_1.pdf');