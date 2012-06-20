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

bbs=asp_prun(bbs,ap_mean,ap_var,ch);
bbs(:,6)=equivClass(bbs(:,6),ch);
nmsPrms{8} = {1,1};
bbs=bbNms(bbs,nmsPrms);

[~,idx] = sort(bbs(:,5),'descend');
bbs = bbs(idx(1:15),:);
save()
cost = zeros(1,length(lexS));
v = zeros(size(bbs,1),length(lexS));
cvx_quiet(true);
load('data/template/template_01'); % load template mask
[A C] = construct_collision(I,bbs,template_01);

lexicons = regexp(lexS{1},',','split');
for i=1:length(lexicons)
%     bigram_prob = buildbigram(lexicons{i})/length(lexicons{i});
%     B = construct_B(bbs,bigram_prob);
    param = [.5 1.2 .5];
%     W = param(1)*A - param(2)*B + param(3)*C;
    W = C;
    s = bbs(:,5);
    [v(:,i) cost(i)] = convex_magic(W,s);
end
[val idxx] = min(cost);
figure;imshow(I);charDetDraw(bbs(v(:,idxx)==1,:),ch);
lexicons{idxx}

t2S=tic; words=wordDet('plexApply',bbs,ch1,lex,plxPrms); t2=toc(t2S);
