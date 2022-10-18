

%Classification by Matlab

clc;

newPixel = class4Data(65,:);
%newPixel = svmTrainingData(120,:);
%newPixel = testDataFile(348,:);
%newPixel = testDataArray{1}(1,:);

classif = zeros(1,10);

% for w = 1 : 500
% 
%     newPixel = svmTrainingData(w,:);
%     
%     for i = 1 : 10
%     
%        [~,score(i,:)] = predict(svmModels{i},newPixel);
%    
%        if score(i,1) > 0
%            classif(i) = 1;
%        else
%            classif(i) = 0;
%        end
%    
%     end
%     
%     %classif
% 
%     %Hamming distance
%     nOnes = 10;
%     for i = 1 : 5
% 
%         auxRes = xor(classif,idCodes(i,:));
% 
%         classRes = and(auxRes,maskCodes(i,:));
% 
%         n = nnz(classRes);
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
%     classificationMatlab(w) = pixelClass;
%     
% end


for i = 1 : 10
    
   [~,score(i,:)] = predict(svmModels{i},newPixel);
   
   if score(i,2) < 0
       classif(i) = 1;
   else
       classif(i) = 0;
   end
   
end

classif

%Hamming distance
nOnes = 10;
for i = 1 : 5
   
    auxRes = xor(classif,idCodes(i,:));
    
    classRes = and(auxRes,maskCodes(i,:));
    
    n = nnz(classRes);
    
    if n < nOnes
        pixelClass = i;
        nOnes = n;
    end
    
end

pixelClass