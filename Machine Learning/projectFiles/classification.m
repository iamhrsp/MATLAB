clear
clc
close all
%getting features and classes out of the training data
trainData = load("sat.trn");
%%trainData = table2array(trainData)
features  = trainData(:,1:end-1);
class     = trainData(:,end);

%creating knn classifier
kModel    = fitcknn(features,class);

%testing the model
testData = load("sat.tst");
%%testData = table2array(testData);
testFeatures = testData(:,1:end-1);
testClass    = testData(:,end);

predictClass = predict(kModel, testFeatures);

cMatrix = confusionmat(testClass, predictClass); 

subplot(1,2,1)
confusionchart(cMatrix);
%figure
%confusionchart(cMatrix,'Normalization', 'row-normalized');
title("knn Confusion")
%The KNN classifier performs fairly well for certain classes, especially classes 1, 3, and 6.
%For example, the KNN model predicts class 1 accurately 455 times, which is excellent, but there are minor 
% misclassifications into classes 3 and 5. 
%there is noticeable confusion in the middle classes (3, 4, and 5), particularly between class 3 and class 4, 
% as well as between class 4 and class 6.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classEncod = ind2vec(class');
nnfunction = patternnet();
nnfunction = train(nnfunction,features',classEncod);

predClassEncod = nnfunction(testFeatures');
[~, predictClassPatnet] = max(predClassEncod);
classPatnetRow = predictClassPatnet';

subplot(1,2,2)
confusionchart(testClass,classPatnetRow)
title("Patternnet")

%A comparison between the two plots reveals that Patternnet is better at
%prediction. This can be seen visually as well since Patternnet has fewer
%misclassifications or confusions or off-diagonal values compared to KNN
%model. 
%in KNN class 6 is being predicted even though it shouldn't. It simply compares distances to the nearest neighbors 
% and assigns a class without knowing anything about its validity. Howeverm
% in Patternnet, any class that does not have any instance is dropped
% giving more reliable predictions.
