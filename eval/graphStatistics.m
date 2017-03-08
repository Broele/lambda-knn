function [ stats ] = graphStatistics( G, C )
%GRAPHSTATISTICS computes statistics about a graph
%   Syntax:
%       stats = graphStatistics( G );
%       stats = graphStatistics( G, C );
%   Description
%       This method analyzes a graph structure and returns the statistics
%           as a struct. The graph is given by a adjacency matrix G.
%       G(i,j) contains the distance between point i and j, if there is and
%           edge, and inf otherwise.
%       The resulting statistics contains the following values:
%           egdeN     : number of edges
%           avgDegree : average node degree
%           maxDegree : maximal node degree
%           minDegree : minimal node degree
%           stdDegree : standard deviation of the node degrees
%           degHisto  : histogram of node degrees (ignoring isolated nodes)
%           conComp   : number of connected components
%           conCompW  : number of weakly connected components
%           sumOfDist : The average sum of outgoing edge distances per node
%       It is possible to add a vector of class indices as a second
%       parameter. C contains values between 1 and m, where m is the 
%       maximal class ID 
%       If C is given, the statistics also contain the following
%       values:
%           confusion: a square matrix where the value (i,j) is the number
%               of edges going from class i to class j
%           innerEdges: number of edges that connect nodes of the same
%               class
%			avgClassDist: a square matrix which contains in (i,j) the
%               averarage distance of nodes from class i to their nearest
%               neighbor in class j. The distance is measured as shortest
%               path in the graph.

%% Preprocess
D = G;
G = (G ~= inf);
n = size(G,1);

%% Node degree
%% Unlabeled Statistics 
% Node degree
Deg = sum(G,2);

stats.edgeN = sum(Deg);
stats.avgDegree = mean(Deg);
stats.maxDegree = max(Deg);
stats.minDegree = min(Deg);
stats.stdDegree = std(Deg);
stats.degHisto  = full(sparse(1,Deg(Deg>0),1,1,max(Deg)));

% Connected Components
stats.conComp  = graphconncomp(sparse(G));
stats.conCompW = graphconncomp(sparse(G), 'Weak', true);

stats.sumOfDist = sum(D(G)) / n;

%% Distances
gDist = graphallshortestpaths(sparse(G));

%% Additional values if class ID are given
if nargin > 1
    % enforce C to be a row vector
    C = reshape(C, 1, []);
    % count the classes
    m = max(C);
    % helper variable with repeated C
    Cr = repmat(C, n, 1);
    stats.confusion = full(sparse(Cr', Cr, double(G), m, m));
    
    stats.innerEdges = sum(diag(stats.confusion));
    
    nC = full(sparse(C,1,1,m,1));
    minDist = zeros(n,m);
    for i = 1:m
        minDist(:,i) = min(gDist(:,C==i), [], 2);
    end
    stats.avgClassDist = full(sparse(repmat(C',1,m), repmat(1:m, n, 1), minDist, m, m));
    stats.avgClassDist = stats.avgClassDist ./ repmat(nC,1,m);
end
end

