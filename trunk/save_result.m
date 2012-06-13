clear;clc;close all;
% save the result
dbgFileNm=sprintf('answer_list.txt');
fid=fopen(dbgFileNm,'w'); 
ch='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_';
for i=0:500
%     fprintf('LOG:%s\n',dbgFileNm);
    f_name=fullfile(sprintf('data/Result_I%05i.mat',i));
    load(f_name,'bbs','best_v');
    out = bbs(best_v==1,:);
    [val idx] = sort(out(:,1));
    out_list = [];
    for j=1:length(idx)
        out_list(j) = ch(out(idx(j),6));
    end
    pr = [int2str(i) ',' out_list];
    fprintf(fid,[pr '\n']);
end
fclose(fid);