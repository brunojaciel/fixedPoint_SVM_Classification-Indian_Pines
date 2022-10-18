
%%%%%%%%%%%     IMPORTANT      %%%%%%%%%%%
%Execute svmDataMount program previously
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;

%Hyperparameters Optimization Parameters
optParam = struct('ShowPlots', false, 'Verbose', 0);

%Number of classfifiers basedo on number of classes
n_classifiers = (n_classes*(n_classes - 1)) / 2;
%n_classifiers = 8;

%Classes data and label arrays to be used during training
classData = zeros(n_samples*2,n_bands);
classLabels = cell(n_samples*2,1);

rng(1);
%Train each SVM classifier
for i = 1 : n_classifiers
   for j = 1 : n_samples
      classData(j,:) = svmTrainingData(j + (n_samples * (trainingOrder(i,1) - 1)),:);
      classData(j + n_samples,:) = svmTrainingData(j + (n_samples * (trainingOrder(i,2) - 1)),:);
      
      classLabels{j} = classes{j + (n_samples * (trainingOrder(i,1) - 1))};
      classLabels{j + n_samples} = classes{j + (n_samples * (trainingOrder(i,2) - 1))};
      
   end
   
   switch trainingOrder(i,1)
       case 1
           switch trainingOrder(i,2)
               case 2
                   svm1v2 = fitcsvm(classData, classLabels, 'KernelFunction', 'RBF', 'OptimizeHyperparameters', 'auto',...
                                    'HyperparameterOptimizationOptions', optParam, 'Standardize' , true);
               case 3
                   svm1v3 = fitcsvm(classData, classLabels, 'KernelFunction', 'RBF', 'OptimizeHyperparameters', 'auto',...
                                    'HyperparameterOptimizationOptions', optParam, 'Standardize' , true);
               case 4
                   svm1v4 = fitcsvm(classData, classLabels, 'KernelFunction', 'RBF', 'OptimizeHyperparameters', 'auto',...
                                    'HyperparameterOptimizationOptions', optParam, 'Standardize' , true);
               case 5
                   svm1v5 = fitcsvm(classData, classLabels, 'KernelFunction', 'RBF', 'OptimizeHyperparameters', 'auto',...
                                    'HyperparameterOptimizationOptions', optParam, 'Standardize' , true);
           end
       case 2
           switch trainingOrder(i,2)
               case 3
                   svm2v3 = fitcsvm(classData, classLabels, 'KernelFunction', 'RBF', 'OptimizeHyperparameters', 'auto',...
                                    'HyperparameterOptimizationOptions', optParam, 'Standardize' , true);
               case 4
                   svm2v4 = fitcsvm(classData, classLabels, 'KernelFunction', 'RBF', 'OptimizeHyperparameters', 'auto',...
                                    'HyperparameterOptimizationOptions', optParam, 'Standardize' , true);
               case 5
                   svm2v5 = fitcsvm(classData, classLabels, 'KernelFunction', 'RBF', 'OptimizeHyperparameters', 'auto',...
                                    'HyperparameterOptimizationOptions', optParam, 'Standardize' , true);
           end
       case 3
           switch trainingOrder(i,2)
               case 4
                   svm3v4 = fitcsvm(classData, classLabels, 'KernelFunction', 'RBF', 'OptimizeHyperparameters', 'auto',...
                                    'HyperparameterOptimizationOptions', optParam, 'Standardize' , true);
               case 5
                   svm3v5 = fitcsvm(classData, classLabels, 'KernelFunction', 'RBF', 'OptimizeHyperparameters', 'auto',...
                                    'HyperparameterOptimizationOptions', optParam, 'Standardize' , true);
           end
       case 4
           svm4v5 = fitcsvm(classData, classLabels, 'KernelFunction', 'RBF', 'OptimizeHyperparameters', 'auto',...
                                    'HyperparameterOptimizationOptions', optParam, 'Standardize' , true);
           
   end
   
end

% for i = 1 : n_classes
%     
%     indx = strcmp(classes, classeIdn(i));
%     svmModels{i} = fitcsvm(svmTrainingData, indx, 'KernelFunction', 'RBF', 'OptimizeHyperparameters', 'auto',...
%                     'HyperparameterOptimizationOptions', optParam); 
% end

% svmModel = fitcsvm(svmTrainingData,classes,'KernelFunction','RBF','OptimizeHyperparameters','auto');
% cvSvmModel = crossval(svmModel);
% classLoss = kfoldLoss(cvSvmModel)
