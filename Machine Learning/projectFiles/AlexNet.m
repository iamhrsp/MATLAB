clear
clc
close all

% Chose one image at a time for running the analysis

%image = imread('1.jpg'); %cat
%image = imread('2.jpg'); %saffron in a basket

image = imread('2.jpg'); %saffron in a basket
net = alexnet('Weights','imagenet');
inputSize = net.Layers(1).InputSize;
classNames = net.Layers(end).ClassNames;
I = imresize(image,inputSize(1:2));

[label,scores] = classify(net,I);


[sortedscores order] = sort(scores,'descend');
sortedclassNames = classNames(order);
figure(1);
clf
subplot(1,2,1)
imshow(image)
subplot(1,2,2)
labels = categorical(sortedclassNames(1:10));
labels = reordercats(labels,sortedclassNames(1:10));
bar(labels,sortedscores(1:10));


%%----COMMENTS about the result------%%
% - picture1
%The algorithm successfully recognised the object as a type of cat. 
% The top predicted categories are all within the cat family showing that
% AlexNet can very well recognise the common well defined objects

%-picture2
%The algorithm failed to correctly classify the basket of saffron which is
%rare and might not be present in the training dataset. From wig to a jelly
%fish, the model displays traits of uncontrolled humourous behaviour.

