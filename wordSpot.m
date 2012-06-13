function [words,t1,t2,bbs]=wordSpot(ff,I,lexS,fModel,wordSvm,nmsPrms,frnPrms,plxPrms)
% Function for End-to-end word spotting function
%
% Full description can be found in: 
%   "End-to-end Scene Text Recognition," 
%    K. Wang, B. Babenko, and S. Belongie. ICCV 2011
%
% USAGE
%  [words1,words] = wordSpot( I, lexS )
%
% INPUTS
%   I        - input image
%   lexS     - input lexicon, comma-separated string
%   fModel   - trained Fern character classifier
%   wordSvm  - trained Svm word classifier
%   nmsPrms  - character-level non max suppression parameters (see bbNms.m)
%   frnPrms  - fern parameters (see charDet.m)
%   plxPrms  - plex parameters (see wordDet.m)
%
% OUTPUTS
%   words      - array of word objects with no threshold
%
% CREDITS
%  Written and maintained by Kai Wang and Boris Babenko
%  Copyright notice: license.txt
%  Changelog: changelog.txt
%  Please email kaw006@cs.ucsd.edu if you have questions.

[dPath,ch,ch1,chC,chClfNm,dfNP]=globals;

if nargin<3, error('not enough params'); end
if ~exist('wordSvm','var'), wordSvm={}; end
if (~exist('nmsPrms','var') || isempty(nmsPrms)), nmsPrms=dfNP; end
if ~exist('frnPrms','var'), frnPrms={}; end
if ~exist('plxPrms','var'), plxPrms={}; end

load aspect_ratio;
vary_size = [0.4 0.5 0.6 0.7 0.8 0.9 1];    % steps for varying sizes

% construct trie
lex=wordDet('build',lexS);

% % run character detector (Ferns)
f_name=fullfile(sprintf('data/BB_I%05i.mat',ff));
if(~exist(f_name,'file'))
    t1S=tic; 
    bbs = [];
    for q=1:length(vary_size)
        r = 1/vary_size(q);
        I2=imResample(I,[round(size(I,1)),round(size(I,2)*r)]);
        bbs_q=charDet(I2,fModel,frnPrms);
        bbs_q(:,[1 3])=bbs_q(:,[1 3])/r;
        bbs = [bbs; bbs_q];
    end
    t1=toc(t1S);
    save(f_name,'bbs');
else
    t1S=tic; 
    load(f_name);
    t1=toc(t1S);
end

% prunning by aspect ratio (case sensitive)
bbs=asp_prun(bbs,ap_mean,ap_var,ch);
% upper and lower case are equivalent
bbs(:,6)=equivClass(bbs(:,6),ch);
% character NMS
nmsPrms{8} = {1,1};
bbs=bbNms(bbs,nmsPrms);


[~,idx] = sort(bbs(:,5),'descend');
bbs = bbs(idx(1:30),:);
% imshow(I);charDetDraw(bbs(idx(1:15),:),ch);

% tstDir = fullfile(dPath,'svt\test');
% objs=bbGt('bbLoad',fullfile(tstDir,sprintf('%s/I%05i.jpg.txt','wordLexPad',ff)));
% lexi=upper([objs.lbl]); 
cost = zeros(1,length(lexS));
v = zeros(size(bbs,1),length(lexS));
cvx_quiet(true);
[A C] = construct_collision(I,bbs);

for i=1:length(lexS)
    bigram_prob = buildbigram(lexS{i});
%     bbs = bbs(idx(1:15),:);

%     [A C] = construct_collision(I,bbs,bigram_prob);
    B = construct_B(bbs,bigram_prob);
    param = [1 1 0.2];
    W = param(1)*A - param(2)*B + param(3)*C;
    s = bbs(:,5);
    [v(:,i) cost(i)] = convex_magic(2*W,s);
end
[val idxx] = min(cost);
figure;imshow(I);charDetDraw(bbs(v(:,idxx)==1,:),ch);
lexS{idxx}
%%
% A = construct_collision(I,bbs,bigram_prob);


% a1 = 0.1
% a2 = 0.1:0.3:2;
% min_cost = inf;
% idx = zeros(2,1);
% best_v = [];

% for i=1:length(a1)
%     for j=1:length(a2)
% %         param = [a1(i) a2(j) 0.4];
% %         
% %         W = param(1)*A - param(2)*B + param(3)*C;
% %         [v final_cost] = convex_magic(W,s);
%         
% %         cost = re_score(size(I,2),bbs,v,final_cost);
%         
% %         if cost < min_cost 
% %             min_cost = cost;
% %             idx = [i j];
% %             best_v = v;
% % %             figure;imshow(I);charDetDraw(bbs(best_v==1,:),ch);
% %         end
%     end
% end

% figure(4);imshow(I);charDetDraw(bbs(best_v==1,:),ch);

%%
% f_name=fullfile(sprintf('data/Result_I%05i.mat',ff));
% save(f_name,'bbs','best_v');

% bbs = bbs(best_v==1,:);

bbs(:,5) = bbs(:,5)*500;

% run word detector (PLEX)
t2S=tic; words=wordDet('plexApply',bbs,ch1,lex,plxPrms); t2=toc(t2S);
if ~isempty(wordSvm)
  % if available, score using SVM
  words=wordNms(words,wordSvm);
end

