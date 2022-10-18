
obs = featureData;
grp = classes;

%obs = HSI;
%grp = MAP;

rng(8000,'Twister');

holdoutCVP = cvpartition(grp,'holdout',0.30);

dataTrain = obs(holdoutCVP.training,:);
grpTrain = grp(holdoutCVP.training);

try
   yhat = classify(obs(test(holdoutCVP),:), dataTrain, grpTrain,'quadratic');
catch ME
   display(ME.message);
end

dataTrainG1 = dataTrain(grp2idx(grpTrain)==1,:);
dataTrainG2 = dataTrain(grp2idx(grpTrain)==2,:);
[h,p,ci,stat] = ttest2(dataTrainG1,dataTrainG2,'Vartype','unequal');

ecdf(p);
xlabel('P value');
ylabel('CDF value');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,featureIdxSortbyP] = sort(p,2); % sort the features
testMCE = zeros(1,14);
resubMCE = zeros(1,14);
nfs = 5:5:70;
classf = @(xtrain,ytrain,xtest,ytest) ...
             sum(~strcmp(ytest,classify(xtest,xtrain,ytrain,'quadratic')));
resubCVP = cvpartition(length(grp),'resubstitution');
 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tenfoldCVP = cvpartition(grpTrain,'kfold',10);

fs1 = featureIdxSortbyP(1:150);

fsLocal = sequentialfs(classf,dataTrain(:,fs1),grpTrain,'cv',tenfoldCVP);

[fsCVfor50,historyCV] = sequentialfs(classf,dataTrain(:,fs1),grpTrain,...
    'cv',tenfoldCVP,'Nf',50);
plot(historyCV.Crit,'o');
xlabel('Number of Features');
ylabel('CV MCE');
title('Forward Sequential Feature Selection with cross-validation');

fsCVfor17 = fs1(historyCV.In(15,:))

testMCECVfor17 = crossval(classf,obs(:,fsCVfor17),grp,'partition',...
    holdoutCVP)/holdoutCVP.TestSize

