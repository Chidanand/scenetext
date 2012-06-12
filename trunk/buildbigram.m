%load allGtStrs
allGtStrs = {'DOOR','THE','SAKANA','AGENCY','GRANT','JAS','KFC',...
    'CVS','TRIDENT','DIEGO','GIFTS','BOOKSTORE','CHINESE','STORE','SAN','VIA','ARMY','HOTEL','SPACE',...
    'SUSHI','FIFTH'};
ch='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_';

n = length(ch);
prior_counts = zeros(n,1);
bigram_counts = zeros(n,n);
bigram_prob = zeros(n,n);
for i=1:length(allGtStrs)
    current_str = allGtStrs{i};
    for j = 1:length(current_str)
        current_char = find(ch==current_str(j));
        prior_counts(current_char) = prior_counts(current_char) + 1;
    end
end

unigram = (prior_counts + 1)/(sum(prior_counts)+1);
    
for i=1:length(allGtStrs)
    current_str = allGtStrs{i};
    for j = 1:length(current_str)-1
        current_char = find(ch==current_str(j));
        next_char = find(ch==current_str(j+1));
        bigram_counts(current_char,next_char) = bigram_counts(current_char,next_char) + 1;
    end
end

k = .001;

for next=1:n
    for current=1:n
        bigram_prob(current,next) = (bigram_counts(current,next))/(prior_counts(current)+k);
    end
end

save('bigram_prob2','bigram_prob');