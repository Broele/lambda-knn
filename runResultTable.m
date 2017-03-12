%% Settings
K = [1 3 5 10 15 20];
% Methods with three columns: call parameter, file identifier, latex display name
methods = {...
        {'knn', 0}, 'k-NN', 'k-NN'; ...
        {'krnn', 0}, 'k-rNN', 'k-rNN'; ...
        {'lknnl', 0, 2}, 'l-kNN L(2)', '$\lambda$-kNN L'; ...
        {'lknng', 0, 2}, 'l-kNN G(2)', '$\lambda$-kNN G'; ...
        {'lknnc', 0, 1, 1}, 'l-kNN C(1,1)', '$\lambda$-kNN C';...
    };

%% Dataset 1
[P, C] = loadOrCompute('datasets/stored/Rings_500', @createDataset, 'rings', [200 300], 'sigma', 0.15, 'radius', 1);

S1 = computeMultipleStatistics('results', P, 'rings_500', methods(:,1), methods(:,2), K);

%% Dataset 2
[P, C] = loadOrCompute('datasets/stored/Helix_2000', @createDataset, 'Helix', 2000, 'sigma', 0.1, 'C', 1);

S2 = computeMultipleStatistics('results', P, 'helix_2000', methods(:,1), methods(:,2), K);

%% Dataset 2a
[P, C] = loadOrCompute('datasets/stored/Helix_1000', @createDataset, 'Helix', 1000, 'sigma', 0.1, 'C', 1);

S2a = computeMultipleStatistics('results', P, 'helix_1000', methods(:,1), methods(:,2), K);

%% Dataset 3
if exist('dataset/stored/cloud1.csv', 'file')
    D = dlmread('dataset/stored/cloud1.csv',';');
    P = D - repmat(mean(D,1),1024,1);
    P = P ./ repmat(std(D,1),1024,1);

    S3 = computeMultipleStatistics('results', P, 'clouds1', methods(:,1), methods(:,2), K);
else
    warning('Cloud dataset not available');
end
%% Dataset 4
if exist('datasets/stored/worldcitiespop.txt', 'file')
    D = dlmread('datasets/stored/worldcitiespop.txt', ',', 1, 4);
    M = find(D >= 200000);
    P = D(M, [3,2]);

    S4 = computeMultipleStatistics('results', P, 'cities200k', methods(:,1), methods(:,2), K);

    %% Dataset 4a
    M = find(D >= 100000);
    P = D(M, [3,2]);

    S4a = computeMultipleStatistics('results', P, 'cities100k', methods(:,1), methods(:,2), K);
else
    warning('Cities dataset not available');
end
%% Output two files
mainStats2LatexTable(...
    'C:\Users\broel\Documents\papers\2015_lKNN\eval.a.tex', ...
    K, ...
    methods(:,3), ...
    S1, S2);

mainStats2LatexTable(...
    'C:\Users\broel\Documents\papers\2015_lKNN\eval.b.tex', ...
    K, ...
    methods(:,3), ...
    S3, S4a);

mainStats2LatexTable(...
    'C:\Users\broel\Documents\papers\2015_lKNN\eval.c.tex', ...
    K, ...
    methods(:,3), ...
    S2, S3, S4a);