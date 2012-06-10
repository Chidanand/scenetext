function cost = asp_cost(bbs,ap_mean,ap_var,ch)

cost = 1 - exp(-((x-ap_mean(i))*1)^2 / 2*ap_var(i));

% c_idx = chibb(1,6);
% p_idx = parbb(1,6);
% p_asp = parbb(1,3) / parbb(1,4);
% c_w_should_be = p_asp / asp(p_idx) * asp(c_idx) * chibb(1,4);
% sdist = 1 - abs(c_w_should_be - chibb(1,3)) / max(c_w_should_be, chibb(1,3));

% c_idx = chibb(1,6); p_idx = parbb(1,6);
% p_asp = parbb(1,3) / parbb(1,4); c_asp = chibb(1,3) / chibb(1,4);
% p_sdist = 1 - exp(-(p_asp-ap_mean(p_idx))^2 / 2*ap_var(p_idx));
% c_sdist = 1 - exp(-(c_asp-ap_mean(c_idx))^2 / 2*ap_var(c_idx));
% sdist2 = p_sdist + c_sdist;