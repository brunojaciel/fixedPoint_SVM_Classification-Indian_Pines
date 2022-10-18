
for k = 1 : n_classes
        
    testSamples{k} = datasample(idx{k},n_samples * 2);
        
end

class1Data = training2D(testSamples{1},:);
class2Data = training2D(testSamples{2},:);
class3Data = training2D(testSamples{3},:);
class4Data = training2D(testSamples{4},:);
class5Data = training2D(testSamples{5},:);


testDataArray = {class1Data,class2Data,class3Data,class4Data,class5Data};


svmArray = {svm1v2,svm1v3,svm1v4,svm1v5,...
            svm2v3,svm2v4,svm2v5,...
            svm3v4,svm3v5,...
            svm4v5};
        
trueLabels = {'class 1','class 2','class 3','class 4','class 5'};


idx1 = 1;
idx2 = 2;
for i = 1 : 10
    
   misses = 0; 
    
   testData = [testDataArray{idx1};testDataArray{idx2}];
   
   [label,score] = predict(svmArray{i},testData); 
   
   for j = 1 : n_samples * 2
      if strcmp(label(j),trueLabels{idx1}) ~= 1
         misses = misses + 1; 
      end
   end
   
   for j = n_samples * 2 : n_samples * 4
      if strcmp(label(j),trueLabels{idx2}) ~= 1
         misses = misses + 1; 
      end
   end
   
   
   error(i) = misses / (n_samples * 4);
   
   if idx2 < 5
       idx2 = idx2 + 1;
   else
       idx1 = idx1 + 1;
       idx2 = idx1 + 1;
   end
   
end

classifiers = [1,2,3,4,5,6,7,8,9,10];
perc = error * 100;

table(classifiers(:),perc(:),'VariableNames',{'Classifiers','MissRate'})

% table(testClasses{:},label{:},score(1:400,2),'VariableNames',...
%     {'TrueLabel','PredictedLabel','Score'});

% 
% losses = zeros(1,10);
% 
% model = crossval(svm1v2);
% losses(1) = kfoldLoss(model);
% 
% model = crossval(svm1v3);
% losses(2) = kfoldLoss(model);
% 
% model = crossval(svm1v4);
% losses(3) = kfoldLoss(model);
% 
% model = crossval(svm1v5);
% losses(4) = kfoldLoss(model);
% 
% model = crossval(svm2v3);
% losses(5) = kfoldLoss(model);
% 
% model = crossval(svm2v4);
% losses(6) = kfoldLoss(model);
% 
% model = crossval(svm2v5);
% losses(7) = kfoldLoss(model);
% 
% model = crossval(svm3v4);
% losses(8) = kfoldLoss(model);
% 
% model = crossval(svm3v5);
% losses(9) = kfoldLoss(model);
% 
% model = crossval(svm4v5);
% losses(5) = kfoldLoss(model);





