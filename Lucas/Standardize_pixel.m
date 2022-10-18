

inputPixel = class4Data(65,:);


svmModels = {svm1v2, svm1v3, svm1v4, svm1v5,...
                svm2v3,svm2v4,svm2v5, ...
                    svm3v4,svm3v5,...
                        svm4v5};

for i = 1 : 10 %Number of classifiers
    
   for j = 1 : 10 %Number of features
       
      stdPixel(i,j) = (inputPixel(j) - svmModels{i}.Mu(j)) / svmModels{i}.Sigma(j); 
             
   end
    
end

%Write standardized pixel
fid = fopen("stdPixel.dat",'w');
fwrite(fid,cast(stdPixel,'single'),'single');
fclose(fid);