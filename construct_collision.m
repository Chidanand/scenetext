function Out = construct_collision(I,bbs,bigram_prob)
n = size(bbs,1);

% First feature (collision)
A = zeros(n,n);
for i=1:n
    for j=i+1:n
        bb1 = bbs(i,:);
        bb2 = bbs(j,:);
        inters = bbApply( 'intersect', bb1, bb2 );
        maxarea = max(bbApply( 'area', bb1),bbApply( 'area', bb2))
        A(i,j) = bbApply( 'area', inters )/maxarea;
%         uin = bbApply( 'union', bb1, bb2 );
%         A(i,j) = bbApply( 'area', inters ) / bbApply( 'area', uin );
    end
end
A = A + A';
A = A / max(A(:));

% Second feature (distance)
D = zeros(n,n);
for i=1:n
    for j=i+1:n
        bb1 = bbs(i,:);
        bb2 = bbs(j,:);
        cen1 = [bb1(1,1)+0.5*bb1(1,3) bb1(1,2)+0.5*bb1(1,4)];
        cen2 = [bb2(1,1)+0.5*bb2(1,3) bb2(1,2)+0.5*bb2(1,4)];
        
        dist = norm(cen1-cen2,2);
        D(i,j) = dist;
    end
end
D = D + D';
D = exp(-D/mean(D(:)));
D = D / max(D(:));


% Second feature (collision)
B = zeros(n,n);
for i=1:n
    for j=1:n
        if (i==j)
            continue;
        end
        if bbs(i,1) < bbs(j,1)
            bb1 = bbs(i,6);
            bb2 = bbs(j,6);
            B(i,j) = bigram_prob(bb1,bb2);
        end
    end
end
B = B .* D;
B = B / max(B(:));

% Thrid feature (color similarity)
C = zeros(n,n);
nbins = 15;
for i=1:n
    for j=i+1:n
        close all;
        bb1 = bbs(i,:);
        bb2 = bbs(j,:);
        I1 = I(bb1(1,2):bb1(1,2)+bb1(1,4)-1,bb1(1,1):bb1(1,1)+bb1(1,3)-1,:);
        I2 = I(bb2(1,2):bb2(1,2)+bb2(1,4)-1,bb2(1,1):bb2(1,1)+bb2(1,3)-1,:);
%         figure;imshow(I1);figure;imshow(I2);
        hist_1 = [];
        hist_2 = [];
        for k=1:3 % for each channel
            [n1,y] = imhist(I1(:,:,k),nbins);
            hist_1 = [hist_1; n1/max(n1)];
            [n2,y] = imhist(I2(:,:,k),nbins);
            hist_2 = [hist_2; n2/max(n2)];
        end
        vec1 = hist_1 / sum(hist_1);
        vec2 = hist_2 / sum(hist_2);
        dist = 0.5*sum( (vec1 - vec2).^2 ./ (vec1 + vec2 + eps) );
        C(i,j) = dist;
    end
end
C = C + C';
C = C / max(C(:));

% Out = A;
Out = A - B + C;
%Out = Out / max(Out(:));