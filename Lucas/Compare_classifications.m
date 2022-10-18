
clc;

compareMisses = 0;

compareResults = [classificationResult01;classificationResult02;classificationResult03;classificationMatlab];

for i = 1 : 500
   
    if classificationResult03(i) ~= classificationMatlab(i)
       compareMisses = compareMisses + 1; 
    end
    
end

compareMisses