%% Create synthetic dataset with 500 points
P = createDataset('spirals', 500, 'sigma', 0.1);

X = [];

% Iterate over multiple k
for k = [1:10, 15, 20]
    %% Create Graphs and names
    G{1} = createGraph(P, 'knn', k);
    N{1} = sprintf('knn(k=%2d)',k);
    G{2} = createGraph(P, 'krnn', k);
    N{2} = sprintf('krnn(k=%2d)',k);
    G{3} = createGraph(P, 'lknnc', k, 2, 0);
    N{3} = sprintf('l-knn L(k=%2d)',k);
    G{4} = createGraph(P, 'lknnc', k, 0, 2);
    N{4} = sprintf('l-knn G(k=%2d)',k);
    G{5} = createGraph(P, 'lknnc', k, 1, 1);
    N{5} = sprintf('l-knn 1(k=%2d)',k);
    G{6} = createGraph(P, 'lknnc', k, 0.5, 1.5);
    N{6} = sprintf('l-knn 2(k=%2d)',k);

    % Get statistics
    for i = 1:numel(G)
        S(i) = graphStatistics(G{i});
    end

    % Print statistics
    printMainStatsTable(1, S, N{:});
end