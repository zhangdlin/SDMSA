% Please note that the demo applies only to UCI dataset!!!
% If you use other datasets, please select the corresponding parameters and settings!!!
% If you use other datasets, please select the corresponding parameters and settings!!!
% If you use other datasets, please select the corresponding parameters and settings!!!
% If you use other datasets, please select the corresponding parameters and settings!!!

%  If you have any questions, please contact me at anytime(dlinzzhang@gmail.com).
% If you use our code, please cite our article.



function demo_KKUCI()
clc
clear all
nbits_set=[64];

%% load dataset
load('dataset-only UCI.mat');


XTrain = I_tr; YTrain = T_tr; LTrain = L_tr;
XTest = I_te; YTest = T_te; LTest = L_te;


%% initialization  ԭʼ
fprintf('initializing...\n')
param.lambdaX = 0.5;
param.beide = 1e-4;
param.lambda = 1e3; 
param.gamma = 0.1; 
param.theta = 1e-5;
param.iter = 30;
run = 5;


%% centralization
fprintf('centralizing data...\n');
XTest = bsxfun(@minus, XTest, mean(XTrain, 1)); XTrain = bsxfun(@minus, XTrain, mean(XTrain, 1));
YTest = bsxfun(@minus, YTest, mean(YTrain, 1)); YTrain = bsxfun(@minus, YTrain, mean(YTrain, 1));

%% kernelization
fprintf('kernelizing...\n\n');

[XKTrain,XKTest]=Kernelize(XTrain,XTest); [YKTrain,YKTest]=Kernelize(YTrain,YTest);
XKTest = bsxfun(@minus, XKTest, mean(XKTrain, 1)); XKTrain = bsxfun(@minus, XKTrain, mean(XKTrain, 1));
YKTest = bsxfun(@minus, YKTest, mean(YKTrain, 1)); YKTrain = bsxfun(@minus, YKTrain, mean(YKTrain, 1));


%% evaluation
for bit=1:length(nbits_set) 
    nbits=nbits_set(bit);
    
 
for i = 1 : run
    %% SDMSA
    param.nbits=nbits;
    eva_info =evaluate(XKTrain,YKTrain,XKTest,YKTest,LTest,LTrain,param);
    
    % train time
 %   trainT = eva_info.trainT;
    
    % MAP
    Image_to_Text_MAP = eva_info.Image_to_Text_MAP;
    Text_to_Image_MAP=eva_info.Text_to_Image_MAP;
    map(i, 1) = Image_to_Text_MAP;
    map(i, 2) = Text_to_Image_MAP;
    
    fprintf('mAP at run %d runs for ImageQueryOnTextDB: %.4f\n', i,  map(i, 1));
    fprintf('mAP at run %d runs for TextQueryOnImageDB: %.4f\n', i,  map(i, 2));
    
end
fprintf('average map over %d runs for ImageQueryOnTextDB: %.4f\n', run,  mean(map( : , 1)));
fprintf('average map over %d runs for TextQueryOnImageDB: %.4f\n', run,  mean(map( : , 2)));
   
  end
end
