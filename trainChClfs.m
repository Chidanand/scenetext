function trainChClfs
% Train character classifiers (SVM)


[dPath,ch,ch1,chC,chClfNm]=globals;
% parameters that pretty much won't change
sBin=8; oBin=8; chH=48;
S=6; M=256; nTrn=Inf;
cHogFtr=@(I)reshape((5*hog(double(imResample(I,[chH,chH])),sBin,oBin)),[],1);
cFtr=cHogFtr;

% Train character detectors specified in the param list
% paramSet={train dataset,with/without neighboring chars,
%           bg dataset,# bg images,bootstrap}
% paramSets={{'icdar','charEasy','icdar',5000,0}};

%   %%
%   % load ICDAR training data
%   paramSets={{'icdar','charEasy','icdar',5000,0}};
%   paramSet=paramSets{1};
%   trnD=paramSet{1}; trnT=paramSet{2}; trnBg=paramSet{3}; 
%   nBg=paramSet{4}; bs=paramSet{5};
%   cDir=fullfile(dPath,trnD,'clfs');
%   clfPrms={'S',S,'M',M,'trnT',trnT,'bgDir',trnBg,'nBg',...
%     nBg,'nTrn',nTrn};
%   cNm=chClfNm(clfPrms{:}); clfPath=fullfile(cDir,[cNm,'.mat']);
%   % load training images without background
%   RandStream.getDefaultStream.reset();
%   [I1,y1]=readAllImgs(fullfile(dPath,trnD,'train',trnT),chC(1:63),nTrn);
%   x1=fevalArrays(I1,cFtr)';
%   
%   % load ICDAR testing data
%   paramSets={{'icdar','charEasy','icdar',5000,0}};
%   paramSet=paramSets{1};
%   trnD=paramSet{1}; trnT=paramSet{2}; trnBg=paramSet{3}; 
%   nBg=paramSet{4}; bs=paramSet{5};
%   cDir=fullfile(dPath,trnD,'clfs');
%   clfPrms={'S',S,'M',M,'trnT',trnT,'bgDir',trnBg,'nBg',...
%     nBg,'nTrn',nTrn};
%   cNm=chClfNm(clfPrms{:}); clfPath=fullfile(cDir,[cNm,'.mat']);
%   % load training images without background
%   RandStream.getDefaultStream.reset();
%   [I2,y2]=readAllImgs(fullfile(dPath,trnD,'test',trnT),chC(1:63),nTrn);
%   x2=fevalArrays(I2,cFtr)';
%   
%   x_icdar = [x1; x2];
%   y_icdar = [y1; y2];
%   save('ICDAR_trte.mat','x_icdar','y_icdar');
%   
%   %%
%   clear all;
%   [dPath,ch,ch1,chC,chClfNm]=globals;
%   sBin=8; oBin=8; chH=48;
%   S=6; M=256; nTrn=Inf;
%   cHogFtr=@(I)reshape((5*hog(double(imResample(I,[chH,chH])),sBin,oBin)),[],1);
%   cFtr=cHogFtr;
%   % load char74
%   paramSets={{'c74k','char','icdar',0,0}};
%   paramSet=paramSets{1};
%   trnD=paramSet{1}; trnT=paramSet{2}; trnBg=paramSet{3}; 
%   nBg=paramSet{4}; bs=paramSet{5};
%   cDir=fullfile(dPath,trnD,'clfs');
%   clfPrms={'S',S,'M',M,'trnT',trnT,'bgDir',trnBg,'nBg',...
%     nBg,'nTrn',nTrn};
%   cNm=chClfNm(clfPrms{:}); clfPath=fullfile(cDir,[cNm,'.mat']);
%   % load training images without background
%   RandStream.getDefaultStream.reset();
%   [I3,y3]=readAllImgs(fullfile(dPath,trnD,'train',trnT),chC(1:63),nTrn);
%   x3=fevalArrays(I3,cFtr)';
% 
%   x_char74 = x3;
%   y_char74 = y3;
%   save('char_trte.mat','x_char74','y_char74');
%   
%   %%
%   clear all;
%   [dPath,ch,ch1,chC,chClfNm]=globals;
%   sBin=8; oBin=8; chH=48;
%   S=6; M=256; nTrn=Inf;
%   cHogFtr=@(I)reshape((5*hog(double(imResample(I(:,11:end-10,:),[chH,chH])),sBin,oBin)),[],1);
%   cFtr=cHogFtr;
%   
%   % load synthetic training data
%   paramSets={{'synth','charHard','icdar',0,0}};
%   paramSet=paramSets{1};
%   trnD=paramSet{1}; trnT=paramSet{2}; trnBg=paramSet{3}; 
%   nBg=paramSet{4}; bs=paramSet{5};
%   cDir=fullfile(dPath,trnD,'clfs');
%   clfPrms={'S',S,'M',M,'trnT',trnT,'bgDir',trnBg,'nBg',...
%     nBg,'nTrn',nTrn};
%   cNm=chClfNm(clfPrms{:}); clfPath=fullfile(cDir,[cNm,'.mat']);
%   % load training images without background
%   RandStream.getDefaultStream.reset();
%   [I4,y4]=readAllImgs(fullfile(dPath,trnD,'train',trnT),chC(1:63),nTrn);
%   x4=fevalArrays(I4,cFtr)';
%   
%   % load synthetic testing data
%   paramSets={{'synth','charHard','icdar',0,0}};
%   paramSet=paramSets{1};
%   trnD=paramSet{1}; trnT=paramSet{2}; trnBg=paramSet{3}; 
%   nBg=paramSet{4}; bs=paramSet{5};
%   cDir=fullfile(dPath,trnD,'clfs');
%   clfPrms={'S',S,'M',M,'trnT',trnT,'bgDir',trnBg,'nBg',...
%     nBg,'nTrn',nTrn};
%   cNm=chClfNm(clfPrms{:}); clfPath=fullfile(cDir,[cNm,'.mat']);
%   % load training images without background
%   RandStream.getDefaultStream.reset();
%   [I5,y5]=readAllImgs(fullfile(dPath,trnD,'test',trnT),chC(1:63),nTrn);
%   x5=fevalArrays(I5,cFtr)'; 
%   
%   x_synth = [x4; x5];
%   y_synth = [y4; y5];
%   save('synth_trte.mat','x_synth','y_synth');
%   %%
%   clear all;
%   [dPath,ch,ch1,chC,chClfNm]=globals;
%   
%   load('ICDAR_trte.mat','x_icdar','y_icdar');
%   load('char_trte.mat','x_char74','y_char74');
%   load('synth_trte.mat','x_synth','y_synth');
  
  % only use 10000 synthetic data
%   idx_rand = randperm(length(y_char74));
%   idx = idx_rand(1:10000);
%   
%   x = [x_icdar; x_char74; x_synth(idx,:)];
%   y = [y_icdar; y_char74; y_synth(idx)];
%   
%   save('SVM_train_corpus.mat','x','y');
  % train one-against-all SVM with RBF
  load SVM_train_corpus;
  
  trainY = y; trainX = x;
  % only choose 90% to train
%   ratioo = 0.9;
%   idx_rand = randperm(length(y));
%   n_train = ceil(length(y)*ratioo);
  
%   trainY = y(idx_rand(1:n_train)); trainX = x(idx_rand(1:n_train),:);
%   testY = y(idx_rand(n_train+1:end)); testX = x(idx_rand(n_train+1:end),:);
  % Fist we do cross validation to find parameters c and r
  %%
% bestcv = 0;
% for log2c = 5:1:7,
%   for log2g = -7:1:-4,
%     cmd = ['-q -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
%     cv = get_cv_ac(trainY, trainX, cmd, 3);
%     if (cv >= bestcv),
%       bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
%     end
%     fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
%   end
% end
% save('SVM_para.mat','bestc','bestg');

%%
% Re train again
bestc=32; bestg=0.015625;
param = [' -c ' int2str(bestc) ' -g ' int2str(bestg) ' -b 1'];
SVM_model = svmtrain(y, x, param);

[pred ac decv] = svmpredict(y, x, SVM_model,'-b 1');
fprintf('Training Accuracy = %g%%\n', ac * 100);

fModel.sBin = sBin;
fModel.oBin = oBin;
fModel.chH = chH;
fModel.ferns = SVM_model;
save('SVM_model_0611','SVM_model');


end