
%clc;

%svSizes = [36,43,21,15,26,15,24,18,21,8];
%svSizes = [26,39,8,65,36,17,37,15,47,24];
svSizes = [30, 47, 14, 10, 18, 7, 200, 43, 42, 2];

newPixel = class4Data(65,:);
%newPixel = svmTrainingData(1,:);
%newPixel = testDataFile(201,:);


idCodes = [1,1,1,1,0,0,0,0,0,0;
           0,0,0,0,1,1,1,0,0,0;
           0,0,0,0,0,0,0,1,1,0;
           0,0,0,0,0,0,0,0,0,1;
           0,0,0,0,0,0,0,0,0,0];
       
maskCodes = [1,1,1,1,0,0,0,0,0,0;
             1,0,0,0,1,1,1,0,0,0;
             0,1,0,0,1,0,0,1,1,0;
             0,0,1,0,0,1,0,1,0,1;
             0,0,0,1,0,0,1,0,1,1];

acc1 = 0;
acc2 = 0;

for i = 1 : 10 %Classifiers loop
    
    for j = 1 : svSizes(i) %SVs loop
        
        for x = 1 : 10 %Bands loop
            
            normValue = (newPixel(x) - dataMean(i,x)) / dataDev(i,x); %Normalize value
            
            supVal = supportVectors{i}(j,x);
            auxValue = normValue - supVal;
            %auxValue = stdPixel(i,x) - supportVectors{i}(j,x);
            auxValue = auxValue * auxValue;
            
            acc1 = acc1 + auxValue;
            
        end
        
        %acc1 = (acc1 / kernelScale(i)) * (-1);
        %acc1 = acc1 / (2 * (kernelScale(i)^2)) * (-1);
        acc1 = acc1 / ((kernelScale(i)^2)) * (-1);
        %acc1 = (acc1 * (-1)) / ((2 * kernelScale(i)^2));
        
        expRes = exp(acc1);
        
        acc2 = acc2 + (expRes * alphas{i}(j) * svLabels{i}(j));
        
        acc1 = 0;
        
    end
    
    acc2 = acc2 + bias(i);
    
    if acc2 < 0
        resultCode(i) = 1;
    else
        resultCode(i) = 0;
    end
    
    acc2 = 0;
end

resultCode


%Hamming distance
nOnes = 10;
for i = 1 : 5
   
    auxRes = xor(resultCode,idCodes(i,:));
    
    classRes = and(auxRes,maskCodes(i,:));
    
    n = nnz(classRes);
    
    if n < nOnes
        pixelClass = i;
        nOnes = n;
    end
    
end

pixelClass


% for w = 1 : 500
%    
%     newPixel = svmTrainingData(w,:);
%     
%     
%     for i = 1 : 10 %Classifiers loop
%     
%         for j = 1 : svSizes(i) %SVs loop
% 
%             for x = 1 : 10 %Bands loop
% 
%                 normValue = (newPixel(x) - dataMean(i,x)) / dataDev(i,x); %Normalize value
% 
%                 auxValue = normValue - supportVectors{i}(j,x);
%                 auxValue = auxValue * auxValue;
% 
%                 acc1 = acc1 + auxValue;
% 
%             end
% 
%             %acc1 = acc1 / kernelScale(i) * (-1);
%             acc1 = acc1 / ((kernelScale(i)^2)) * (-1);
%             %acc1 = (acc1 * (-1)) / ((2 * kernelScale(i)^2));
% 
%             expRes = exp(acc1);
% 
%             acc2 = acc2 + (expRes * alphas{i}(j) * svLabels{i}(j));
% 
%             acc1 = 0;
% 
%         end
%     
%         acc2 = acc2 + bias(i);
%     
%         if acc2 < 0
%             resultCode(i) = 1;
%         else
%             resultCode(i) = 0;
%         end
%     
%         acc2 = 0;
%     end
% 
%     %resultCode
% 
% 
%     %Hamming distance
%     nOnes = 10;
%     for i = 1 : 5
%    
%     auxRes = xor(resultCode,idCodes(i,:));
%     
%     classRes = and(auxRes,maskCodes(i,:));
%     
%     n = nnz(classRes);
%     
%         if n < nOnes
%             pixelClass = i;
%             nOnes = n;
%         end
%     
%     end
% 
%     %pixelClass
%     
%     classificationResult03(w) = pixelClass;
%     
% end
