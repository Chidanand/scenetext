% Compute char detection accuracy for Random Fern
% I should compute two acc, one for resize, one w/o resize
clear;clc;close all;
addpath(genpath('toolbox'));
load charBoundary;
load fModel; load frnPrms; load nmsPrms;
ch='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_';
a = nmsPrms{8}{1}; b = nmsPrms{8}{2};   % resize ratio

threshold = 0.5;
char_count = 0;
t_positive = 0;

for j=1:length(charBound)   % loop over images
    I = imread(['data/svt_char/' charBound(j,1).ImgName]);
    bbs=charDet(I,fModel,frnPrms);
%     bbs=bbNms(bbs,nmsPrms);
    bbs=bbApply('resize',bbs,a,b); 
    for k=1:13  % loop over character
        if ~isempty(charBound(j,k).char)
            char_count = char_count + 1;    % count total char in svt_char
            char_idx = find(ch==charBound(j,k).char);
            bbs_idx = bbs(bbs(:,6)==char_idx,:);  % might be multiple 
            int_un_ratio = zeros(size(bbs_idx,1),1);
            for m=1:size(bbs_idx,1)
                int_area = bbApply( 'intersect', charBound(j,k).boundary, bbs_idx(m,:) );
                un_area = bbApply( 'union', charBound(j,k).boundary, bbs_idx(m,:) );
                int_un_ratio = bbApply( 'area', int_area ) / bbApply( 'area', un_area );
                if int_un_ratio >= threshold
                    t_positive = t_positive + 1;    % if int_un > thres, true positive
                end
            end

        end
    end
end

char_count
t_positive
acc = t_positive / char_count
