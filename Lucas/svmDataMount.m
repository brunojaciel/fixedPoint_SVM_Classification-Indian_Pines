
%svmData = image2D(trainingSamples{2}(1),:);

clear svmData;
clear classes;

load Indian_pines_corrected;
load Indian_pines_gt;

n_samples = 200;
n_classes = 5;
n_bands = 10;

classes = cell(n_samples * n_classes,1);
idx = cell(1,n_classes);

trainingOrder = [1,2; 1,3; 1,4; 1,5; 2,3; 2,4; 2,5; 3,4; 3,5; 4,5];

%Define a smaller images set

%185   191   184   178   176    46   153    70   146    92   170   171   128   111   101 -> 0.20 -> 0.0300
%192   185   179   161    56    99   109    79   127    81 -> 0.20 -> 0.0350
%191   184   178    46    70   146    92   171   111   101 -> 0.20 -> 0.0600
%96    97    46   195    92   131   182   178   133   123  -> 0.20 -> 0.0650
%191   184   178    46    70   146    92   171   111   101 -> 0.20 -> 0.0600

%197   192   187   183   185    56    44    98   172   131 -> 0.25 -> 0.0480
%62    41   126   130    92    39   101   182   121    17  -> 0.25 -> 0.0480
%196   189   190   161    54   153   148   100   152   112 -> 0.25 -> 0.0840
%196   189   190   161    54   153   148   100   152   112 -> 0.25 -> 0.0840
%196   189   190   161    54   153   148   150   170    95   100   152   111   112    78 -> 0.25 -> 0.0600

%187   178    85   177    55    50   174   128    36    82 -> 0.30 -> 0.0467
%187   178    85   177    55    50   174   128    36    82 -> 0.30 -> 0.0467
%187   178   194    85   177    55    50   150   174   128   125    36   82   124   135  -> 0.30 -> 0.0467
%185   194    97    72    46   170    92    98     4   129 -> 0.30 -> 0.0600
%84   131    43    98   101   182    81   184   121   118  -> 0.30 -> 0.0600

trainImage = indian_pines_corrected(1:63,96:145,[44,68,100,103,106,125,127,136,183,188]);
%trainImage = indian_pines_corrected(1:63,96:145,[7,13,28,38,42,46,50,70,89,126]);
%trainImage = indian_pines_corrected(1:63,96:145,[20,92,101,106,109,112,126,131,144,150,155,157,160,162,163,165,172,174,176,177,178,185,192,197,200]);
trainGT = indian_pines_gt(1:63,96:145);   %Define a GT mapping correspondent to auxImage

%Redefine the classes numbers in auxGT
for l = 1 : numel(trainGT)

    switch trainGT(l)
        case 11
            trainGT(l) = 1;
        case 2
            trainGT(l) = 2;
        case 10
            trainGT(l) = 3;
        case 8
            trainGT(l) = 4;
        case 14
            trainGT(l) = 5;
    end
    
end


%Reshape auxImage into a 2D array.
%Lines represent pixels and columns represent spectral bands
training2D = reshape(trainImage, 63*50, n_bands);


%Auxiliary 2D image with all bands
auxImage = indian_pines_corrected(1:63,96:145,:);
image2D = reshape(auxImage, 63*50, 200);

for j = 1 : n_classes

    idx{j} = find(trainGT == j);
    
end


for k = 1 : n_classes
        
    trainingSamplesIdx{k} = datasample(idx{k},n_samples);
    
    %testSamples{k} = datasample(idx{k},n_samples * 2);
        
end

lastIndex = 0;
for n = 1 : n_classes
    for i = 1 : n_samples
       svmTrainingData(i+lastIndex,:) = training2D(trainingSamplesIdx{n}(i),:);
       
       featureData(i+lastIndex,:) = image2D(trainingSamplesIdx{n}(i),:);
       
       classes{i+lastIndex} = ['class ' num2str(n)];
    end
    
    lastIndex = lastIndex + n_samples;
end

