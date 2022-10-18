


for i = 1 : 1
   for j = 1 : n_samples
      classData(j,:) = svmTrainingData(j + (n_samples * (trainingOrder(i,1) - 1)),:);
      classData(j + n_samples,:) = svmTrainingData(j + (n_samples * (trainingOrder(i,2) - 1)),:);
      
      classLabels{j} = classes{j + (n_samples * (trainingOrder(i,1) - 1))};
      classLabels{j + n_samples} = classes{j + (n_samples * (trainingOrder(i,2) - 1))};
      
   end
   
end

c = cvpartition(200,'KFold',10);

sigma = optimizableVariable('sigma',[1e-5,1e5],'Transform','log');
box = optimizableVariable('box',[1e-5,1e5],'Transform','log');

minfn = @(z)kfoldLoss(fitcsvm(classData,classLabels,'CVPartition',c,...
    'KernelFunction','rbf','BoxConstraint',z.box,...
    'KernelScale',z.sigma));

results = bayesopt(minfn,[sigma,box],'IsObjectiveDeterministic',true,...
    'AcquisitionFunctionName','expected-improvement-plus')

z(1) = results.XAtMinObjective.sigma;
z(2) = results.XAtMinObjective.box;
svm1v2 = fitcsvm(classData,classLabels,'KernelFunction','rbf',...
    'KernelScale',z(1),'BoxConstraint',z(2));



