clear
clc
close all
importData = readtable("Concrete_Data.xls");
concreteData = table2array(importData);

features = concreteData(:,1:end-1);
target   = concreteData(:,end);
lrm      = fitlm(features, target);

%disp(lrm);

predictedStrength = predict(lrm,features);

fprintf("Linear Regression Model produces a Mean Squared Error of %d\n",mean((predictedStrength - target).^2));

%%
net = fitnet(10);

[net tr] = train(net,features',target');
nnPredictedStrength = net(features');


fprintf("fitnet() produces a Mean Squared Error of %d", mean((nnPredictedStrength' - target).^2))

%Lower Mean Square Error means the model performs better. Fitnet() produces
%lower Mean Square Error.
%%
plotregression(target, predictedStrength, 'Linear Model Regression');
figure;
plotregression(target', nnPredictedStrength, 'Neural Network Regression');
