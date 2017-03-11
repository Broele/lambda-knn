function [ S ] = computeMultipleStatistics( resultPath, data, dataName, methods, methodNames, K )
%COMPUTEMULTIPLESTATISTICS computes multiple statistics
%   Syntax:
%       S = computeMultipleStatistics( resultPath, data, dataNames, methods, methodNames, K );
%   Description
%       resultPath defines a path to the functions results. This allows to
%           reload already computed results.
%       data is a datasets.
%       dataName is the name of the dataset.
%       method stores a cell array with multiple methods. Each method is
%           given by a cell array of parameters for the call of createGraph
%       methodNames gives a list of names for the methods
%       The parameter K allows replace the second method parameters with
%           multiple K values
%   Example:
%       S = computeMultipleStatistics('results', ...
%           createDataset('helix', 1000, 'sigma', 0.1, 'C', 1),...
%           'helix_1000',...
%           {{'knn', 0}, {'krnn', 0}, {'lknnc', 0, 0.5, 1.25,'medk'}},...
%           {'knn', 'krnn', 'lknnc_0.5_1.25'}, ...
%           1:2:7
%       );

makeDirIfNotExists(resultPath);

% Iterate over datasets
for i = 1:numel(K);
    k = K(i);
    % Iterate over methods
    for j = 1:numel(methods)
        method = methods{j};
        mName = methodNames{j};
        method{2} = k;
        
        filename = sprintf('%s_%s_K%d', dataName, mName, k);
        filename = fullfile(resultPath, filename);
        
        G = loadOrCompute(filename, @createGraph, data, method{:});
        S(i,j) = graphStatistics(G);
    end
end
end

