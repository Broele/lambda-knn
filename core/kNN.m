function [G, Adj]=kNN(Points, k)
%KNN creates the neighborhood graph for a set of points using the k-rnn
%method
%   Syntax:
%       [G, Adj] = kNN( Point, k)
%   Description:
%       G is a graph where G(i,j) represents the weight of the edge from i
%           to j. G(i,j) = inf means that there is no edge.
%       Adj is the binarized version of G

%% Compute Distance Matrix
[N]=size(Points, 1);
D = pdist2(Points,Points,'cityblock');
D(diag(true(N,1))) = Inf;


%% Only use the k shortest edges
G=Inf*ones(N);
[~, idx] = sort(D, 2);
idx = idx(:,1:k);
Adj = full(sparse(repmat((1:N)',1,k), idx, true, N, N));
G(Adj) = D(Adj);

end


