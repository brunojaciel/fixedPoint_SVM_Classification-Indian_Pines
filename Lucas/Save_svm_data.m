
clear dataMean;
clear dataDev;

svmModels = {svm1v2, svm1v3, svm1v4, svm1v5, svm1v6, svm1v7, svm1v8, ... 
            svm2v3, svm2v4, svm2v5, svm2v6, svm2v7, svm2v8, ... 
            svm3v4, svm3v5, svm3v6, svm3v7, svm3v8, ...
            svm4v5, svm4v6, svm4v7, svm4v8, ...
            svm5v6, svm5v7, svm5v8, ...
            svm6v7, svm6v8, ...
            svm7v8};

                    
svLabels = {svm1v2.SupportVectorLabels, svm1v3.SupportVectorLabels, svm1v4.SupportVectorLabels, svm1v5.SupportVectorLabels,...
            svm2v3.SupportVectorLabels,svm2v4.SupportVectorLabels,svm2v5.SupportVectorLabels, ...
                    svm3v4.SupportVectorLabels,svm3v5.SupportVectorLabels,...
                        svm4v5.SupportVectorLabels};

svLabelsNames = ["svLabel01.dat","svLabel02.dat","svLabel03.dat","svLabel04.dat","svLabel05.dat"...
                    "svLabel06.dat","svLabel07.dat","svLabel08.dat","svLabel09.dat","svLabel10.dat"];
                    
idx1 = 1;
idx2 = 2;

for i = 1 : 10
    
    auxMat = svmModels{i}.X;
    dataMean(i,:) = mean(auxMat);
    dataDev(i,:) = std(auxMat);
    
    if idx2 < 5
        idx2 = idx2 + 1;
    else
        idx1 = idx1 + 1;
        idx2 = idx1 + 1;
    end
    
end



sv_12 = svm1v2.SupportVectors;
sv_13 = svm1v3.SupportVectors;
sv_14 = svm1v4.SupportVectors;
sv_15 = svm1v5.SupportVectors;
sv_23 = svm2v3.SupportVectors;
sv_24 = svm2v4.SupportVectors;
sv_25 = svm2v5.SupportVectors;
sv_34 = svm3v4.SupportVectors;
sv_35 = svm3v5.SupportVectors;
sv_45 = svm4v5.SupportVectors;

supportVectors = {sv_12, sv_13, sv_14, sv_15, ...
                    sv_23, sv_24, sv_25, ...
                        sv_34, sv_35, ...
                            sv_45};

alpha_12 = svm1v2.Alpha;
alpha_13 = svm1v3.Alpha;
alpha_14 = svm1v4.Alpha;
alpha_15 = svm1v5.Alpha;
alpha_23 = svm2v3.Alpha;
alpha_24 = svm2v4.Alpha;
alpha_25 = svm2v5.Alpha;
alpha_34 = svm3v4.Alpha;
alpha_35 = svm3v5.Alpha;
alpha_45 = svm4v5.Alpha;

alphas = {alpha_12, alpha_13, alpha_14, alpha_15, ...
            alpha_23, alpha_24, alpha_25, ...
                alpha_34, alpha_35, ...
                    alpha_45};

bias = [svm1v2.Bias,svm1v3.Bias,svm1v4.Bias,svm1v5.Bias,svm2v3.Bias,svm2v4.Bias,...
    svm2v5.Bias,svm3v4.Bias,svm3v5.Bias,svm4v5.Bias];

kernelScale = [svm1v2.KernelParameters.Scale,svm1v3.KernelParameters.Scale,svm1v4.KernelParameters.Scale,...
                svm1v5.KernelParameters.Scale,svm2v3.KernelParameters.Scale,svm2v4.KernelParameters.Scale,...
                svm2v5.KernelParameters.Scale,svm3v4.KernelParameters.Scale,svm3v5.KernelParameters.Scale,...
                svm4v5.KernelParameters.Scale];


svNames = ["sv_12.dat","sv_13.dat","sv_14.dat","sv_15.dat","sv_23.dat",...
        "sv_24.dat","sv_25.dat","sv_34.dat","sv_35.dat","sv_45.dat"];
    
alphaNames = ["alpha12.dat", "alpha13.dat", "alpha14.dat", "alpha15.dat", "alpha23.dat",...
                "alpha24.dat", "alpha25.dat", "alpha34.dat", "alpha35.dat", "alpha45.dat",];
            
classNames = ["Class01.dat", "Class02.dat", "Class03.dat", "Class04.dat", "Class05.dat",];

%Standardize data to write
for x = 1: 5
    for i = 1 : 200
       for j = 1 : 10
           standardData{x}(i,j) = (testDataArray{x}(i,j) - svmModels{x}.Mu(j)) / svmModels{x}.Sigma(j);
       end
    end
end
    
testDataFile = [standardData{1};standardData{2};standardData{3};standardData{4};standardData{5}];
    
%Write parameter files
for i = 1 : 10
    fid = fopen(svNames(i), 'w');
    fwrite(fid,cast(supportVectors{i},'single'),'single');
    fclose(fid);
    
    fid = fopen(svLabelsNames(i), 'w');
    fwrite(fid,cast(svLabels{i},'single'),'single');
    fclose(fid);
    
    fid = fopen(alphaNames(i),'w');
    fwrite(fid,cast(alphas{i},'single'),'single');
    fclose(fid);
    
end

fid = fopen("bias.dat",'w');
fwrite(fid,cast(bias,'single'),'single');
fclose(fid);

fid = fopen("kernelScale.dat",'w');
fwrite(fid,cast(kernelScale,'single'),'single');
fclose(fid);


%Write Test samples file
fid = fopen("testData.dat",'w');
fwrite(fid,cast(testDataFile,'single'),'single');
fclose(fid);







