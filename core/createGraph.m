function [ G ] = createGraph( points, method, varargin )
%CREATEGRAPH creates the neighborhood graph for a set of points using a
%specified method
%   Syntax:
%       G = createGraph( points, method, param1, param2, ...)
%   Description:
%       G is a graph where G(i,j) represents the weight of the edge from i
%           to j. G(i,j) = inf means that there is no edge.
%   Supported methods:
%       1. kNN:  
%           only one parameter - k
%       2. kRNN (kRNN using degrees): 
%           only one parameter - k
%       3. lkNNl (local lambda): 
%           two parameter: k, frac
%       4. lkNNg (global lambda): 
%           two parameter: k, frac
%       5. lkNNc (combined lambda): 
%           four parameter: k, frac1, frac2, m
%           - allows modification of the lambda computation
%           - k can have 2 elements (local + global)
%       6. lkNNabs (combined lambda with phi=abs): 
%           four parameter: k, frac1, frac2, m
%           - allows modification of the lambda computation
%           - k can have 2 elements (local + global)
%       7. lkNNu (combined lambda, undirected): 
%           four parameter: k, frac1, frac2, m
%           - allows modification of the lambda computation
%           - k can have 2 elements (local + global)

switch lower(method)
    case 'knn'
        k = varargin{1};
        G = kNN(points, k);
     case 'krnn'
        k = varargin{1};
        G = kRNN(points, k);
    case 'lknnl'
        k = varargin{1};
        frac = varargin{2};
        G = lambda_knn_combined(points, k, frac, 0);
    case 'lknng'
        k = varargin{1};
        frac = varargin{2};
        G = lambda_knn_combined(points, k, 0, frac);
    case 'lknnc'
        G = lambda_knn_combined(points, varargin{:});
    case 'lknnabs'
        G = lambda_Dir_abs(points, varargin{:});
    case 'lknnu'
        G = lambda_knn_undirected(points, varargin{:});
    otherwise
        error('Method "%s" is not supported.', method);
end
        


end

