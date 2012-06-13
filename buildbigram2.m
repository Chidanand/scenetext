function bigram_prob = buildbigram2
% allGtStrs = {'DOOR','THE','SAKANA','AGENCY','GRANT'};
allGtStrs = {'DOOR'};
ch='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_';
lex='THE';

bigram_prob = zeros(62,62);
for i=1:length(allGtStrs)   % how many words in lexicon
    for j=1:length(allGtStrs{1})-1    % how many characters in that word
        left = find(ch==allGtStrs{1}(j));
        right = find(ch==allGtStrs{1}(j+1));
        bigram_prob(left,right) = 1;
    end
end
