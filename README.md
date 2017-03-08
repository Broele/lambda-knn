# lambda-knn
Sample code for the lambda-knn method
## Usage
- Initialize with `init` (add subfolder to the path)
- Usage `createGraph` to perform one of the methods and get the resulting graph

## Example
```matlab
% Create random points
P = randn(100, 2);

% Get two graphs
G1 = createGraph(P, 'krnn', 5);
G2 = createGraph(P, 'lknnc', 1, 1, 5);
```