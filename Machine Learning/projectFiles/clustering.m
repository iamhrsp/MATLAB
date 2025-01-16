%% Question2
clear
clc
data = load("cars.mat");
dataMatrix = data.cardata;

zMPG = (dataMatrix.MPG - mean(dataMatrix.MPG))./std(dataMatrix.MPG);
zDisp = (dataMatrix.Displacement - mean(dataMatrix.Displacement))./std(dataMatrix.Displacement);
zHorse = (dataMatrix.Horsepower - mean(dataMatrix.Horsepower))./std(dataMatrix.Horsepower);
zWeight = (dataMatrix.Weight - mean(dataMatrix.Weight))./std(dataMatrix.Weight);
zAcc = (dataMatrix.Acceleration - mean(dataMatrix.Acceleration))./std(dataMatrix.Acceleration);

znormMatrix = [zMPG zDisp zHorse zWeight zAcc];

covarianceMatrix = cov(znormMatrix);

[eigenVectors, eigenValues] = eig(covarianceMatrix);

% Extract eigenvalues
eigenValues = diag(eigenValues);
% Sort eigenvalues in descending order
[sortedEigenValues, index] = sort(eigenValues, 'descend');
sortedEigenVectors = eigenVectors(:, index);

% Select the first two principal components
topComponents = sortedEigenVectors(:, 1:2);

pcaScores = znormMatrix * topComponents;

% Scatter plot of the first two principal components
figure;
scatter(pcaScores(:, 1), pcaScores(:, 2));
xlabel('Principal Component 1');
ylabel('Principal Component 2');
title('PCA Scores');
grid on;

% Use evalclusters to evaluate the number of clusters
eva = evalclusters(znormMatrix, 'linkage', 'silhouette', 'klist', 1:10);

% Display the optimal number of clusters based on silhouette score
optimalClusters = eva.OptimalK;
fprintf('Optimal number of clusters : %d',optimalClusters)

%Determining Variance captured by first two features
[coeff, score, latent] = pca(znormMatrix);       %feat_var represents each feature variance given by the eigen values

totVariance = sum(latent);     %Total variance in the data = sum of all the features variances

TopTwoVar = (latent(1) + latent(2))/totVariance * 100       %Variance explained by first two components or features

%The two principal components represent the miles per gallon and
%displacement. The division of the data in two clusters represents the type
%of cars. For example, compact cars with higher MPG and bigger cars or
%trucks with lower MPG and higher displacement

%Among the five features, the first two features capture ~93% of the information present in original dataset.

%%
HCM = linkage(znormMatrix, 'ward');
figure
dendrogram(HCM);        % Visualise the hierarchichal clustering model
title("Hierarchichal Clustering Tree")

clusters = cluster(HCM, 'maxclust', 2); %  Cutting the tree at level 2 since two optimum clusters obtained

% Perform PCA on the normalized data
[coeff, score, latent, tsquared, explained] = pca(znormMatrix);

% Create a scatter plot of the first two principal components
figure
scatter(score(:,1), score(:,2), 50, clusters, 'filled');
xlabel('1st Principal Component');
ylabel('2nd Principal Component');
title('PCA Scatter Plot with Cluster Coloring');

%Just two colours for two clusters
colorbar; % To show which colors correspond to which clusters

%%
% Assuming 'score' is your PCA result and 'origin' is the last column in your data
origin = dataMatrix{:, end};  % Extracting the 'origin' column (categorical)

% Scatter plot of the first two principal components, colored by 'origin'
figure
gscatter(score(:,1), score(:,2), origin);
xlabel('Principal Component 1');
ylabel('Principal Component 2');
title('PCA Scatter Plot Colored by Car Origin');

% yes there is a clear corelation between the clusters and car origin.
% Cars maufactured in Europe and Japan only belong to cluster 2, 
% while as USA origin cars are found in both the clusters. 
