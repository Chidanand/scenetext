function BestMatch( X, Y )
    d_best_IDX = zeros(length(X), 5); % L1, L2, Linf, nprod, prod
    d_best_V = zeros(length(X), 5); % L1, L2, Linf, nprod, prod

    d_table = zeros(length(X), 5, length(Y));
    bin = zeros(length(X), 5, length(Y));
    prop(1).TYPE = 'lp';    prop(1).p = 1;
    prop(2).TYPE = 'lp';    prop(2).p = 2;
    prop(3).TYPE = 'lp';    prop(3).p = inf;
    prop(4).TYPE = 'prod'; 
    prop(5).TYPE = 'nprod';
    
    for m = 1 : length(X)
        x = X(m).I;
        for t = 1 : 5
            for n = 1 : length(Y)
                y = Y(n).I;
                d_table(m, t, n) = distanceFun( x(:), y(:), prop(t) );
                bin(m, t, n) = (X(m).label == Y(n).label ); 
            end
            if strcmp(prop(t).TYPE, 'lp')
                [V IDX] = min( d_table(m, t, :) );
            else
                [V IDX] = max( d_table(m, t, :) );
            end
            d_best_IDX(m, t) = IDX;
            d_best_V(m, t) = V;
            
        end
    end
    
    % visualization
    figure;
    for m = 1 : length(X)
        subplot(length(X), 6, (m-1)*6 + 1);
        imshow(X(m).I);
        text(4,38, num2str(X(m).label), 'fontsize', 18);
        for t = 1 : 5
            y = Y(d_best_IDX(m, t));
            subplot(length(X), 6, (m-1)*6 + 1 + t);
            imshow(y.I);
            if y.label == X(m).label
                text(4,38, num2str(y.label), 'fontsize', 18);
            else
                text(4,38, ['*' num2str(y.label)], 'fontsize', 18);
            end
        end
    end
    set(gcf, 'position', [504    49   459   635], 'color', 'w');
    export_fig('../fig/p2.pdf');
end


