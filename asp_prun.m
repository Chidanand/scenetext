function bbs=asp_prun(bbs,ap_mean,ap_var,ch)
% loop for each character
shrink_rate = 1;
for i=1:length(ch)-1
    bbs_i = bbs(bbs(:,6)==i,:);
    x_mean = ap_mean(i);
    x_var = ap_var(i);
    if ~isempty(bbs_i)
        % loop for each bbs in that character
        bbs_out = zeros(size(bbs_i,1),6);
        bbs_count = 1;
        for j=1:size(bbs_i,1)
            x = bbs_i(j,3)/bbs_i(j,4) / shrink_rate;  %width / height
            prob = exp(-((x-x_mean)*1)^2 / (2*x_var));
%             if prob > 0.4
            bbs_i(j,5) = bbs_i(j,5) * prob;
            
            if bbs_i(j,5) > 0.1
                bbs_out(bbs_count,:) = bbs_i(j,:);
                bbs_count = bbs_count + 1;
            end
        end
        bbs(bbs(:,6)==i,:) = [];
        bbs = [bbs; bbs_out(1:bbs_count-1,:)];
    end
end