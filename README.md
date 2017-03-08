# lambda-knn
Sample code for the lambda-knn method
## Usage
- Initialize with `init` (add subfolder to the path).
- Use `createDataset` for creating a synthetic dataset.
- Use `createGraph` to perform one of the methods and get the resulting graph.

## Example
```matlab
% Create synthetic dataset with 500 points
P = createDataset('spirals', 500, 'sigma', 0.1);

% Get two graphs
G1 = createGraph(P, 'krnn', 5);
G2 = createGraph(P, 'lknnc', 5, 1, 1);

% Get statistics
S(1) = graphStatistics(G1);
S(2) = graphStatistics(G2);

% Print statistics
printMainStatsTable(1, S, 'krnn', 'lknnc');
```