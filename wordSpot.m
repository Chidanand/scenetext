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
vary_size = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1];    % steps for varying sizes

% construct trie
lex=wordDet('build',lexS);
% % run character detector (Ferns)
t1S=tic; 
    % varying sizes
    bbs = [];
    for q=1:length(vary_size)
        r = 1/vary_size(q);
        I2=imResample(I,[round(size(I,1)),round(size(I,2)*r)]);
        bbs_q=charDet(I2,fModel,frnPrms);
        bbs_q(:,[1 3])=bbs_q(:,[1 3])/r;
        bbs = [bbs; bbs_q];
    end
t1=toc(t1S);

% f_name=fullfile(sprintf('data/BB_I%05i.mat',ff));
% save(f_name,'bbs');
% load(f_name);

% prunning by aspect ratio (case sensitive)
bbs=asp_prun(bbs,ap_mean,ap_var,ch);
% upper and lower case are equivalent
bbs(:,6)=equivClass(bbs(:,6),ch);
% character NMS
nmsPrms{8} = {1,1};
bbs=bbNms(bbs,nmsPrms);

% f_name=fullfile(sprintf('data/bbs/BB_I%05i.mat',ff));
% save(f_name,'bbs');
% load(f_name);

% [val idx] = sort(bbs(:,5),'descend');
% bbs = bbs(idx(1:20),:);
% imshow(I);charDetDraw(bbs(idx(1:10),:),ch);

A = construct_collision(bbs);
s = bbs(:,5);
v = convex_magic(A,s);
imshow(I);charDetDraw(bbs(v==1,:),ch);
% bbs = bbs(v==1,:);

bbs(:,5) = bbs(:,5)*500;

% run word detector (PLEX)
t2S=tic; words=wordDet('plexApply',bbs,ch1,lex,plxPrms); t2=toc(t2S);
if ~isempty(wordSvm)
  % if available, score using SVM
  words=wordNms(words,wordSvm);
end

