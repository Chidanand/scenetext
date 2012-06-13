function d = distanceFun( x1, x2, prop )
    x1 = double(x1); x2 = double(x2);
    if strcmp(prop.TYPE, 'lp')          % lp norm
        d = norm( x1-x2, prop.p );
    elseif strcmp(prop.TYPE, 'prod')    %inner prod
        d = x1' * x2;
    elseif strcmp(prop.TYPE, 'nprod')   %norm inner prod
        d = x1' * x2 / (norm(x1)*norm(x2));
    elseif strcmp(prop.TYPE, 'chi2')    %chi2
        hx1 = x1 / sum(x1);
        hx2 = x2 / sum(x2);
        d = 0.5 * sum( (hx1 - hx2).^2 ./ (hx1 + hx2 + eps)  );
    end
end

