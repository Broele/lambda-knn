function mainStats2LatexTable( filename, K, names, varargin )
%MAINSTATS2LATEXTABLE prints multiple statistics as one latex table
%   Syntax:
%       mainStats2LatexTable( filename, K, names, S1, S2, ... )
%       mainStats2LatexTable( fid, K, names, S1, S2, ... )
%       mainStats2LatexTable( 1, K, names, S1, S2, ... )
%   Description:
%       The method exports the code for a latex table into a file. This
%       table contains statistics that were collected over multiple
%       datasets, methods and settings for k.
%   Parameters:
%       filename : the name of the destination file. Alternatively, a file
%               handler can be used. Use file handler 1 for output in the
%               command window.
%       K        : An array with n different values for k. These are only
%               used for output purposes.
%       names    : A cell array with m different names for the algorithms.
%               A with the array K, these are only used to lable rows.
%       S1, ...  : A sequence auf arrays with graph statistics. Each array 
%               comes form another dataset. These arrays are results form
%               the function computeMultipleStatistics. The have n rows and
%               m columns.

%% Parse input
D = numel(varargin);

S = varargin;

% Define the statistic columns

% sFcts = {@(s) s.avgDegree, ...
%          @(s) s.stdDegree, ...
%          @(s) s.sumOfDist, ...
%          @(s) s.sumOfDist / s.avgDegree};

sFcts = {@(s) s.avgDegree, ...
         @(s) s.stdDegree, ...
         @(s) s.sumOfDist};

L = numel(sFcts);
N = numel(K);
M = numel(names);
     
if ischar(filename)
    fid = fopen(filename, 'wt');
else
    fid = filename;
end
     
%% Print preamble
% Open environment
fprintf(fid, '\\begin{tabular}{|l|l|');
for d = 1:D
    for s = 1:L
        fprintf(fid,'r');
    end
    fprintf(fid, '|');
end
fprintf(fid, '}\n');

%% Print header
fprintf(fid, '\\hline\n');

% Name
fprintf(fid, '\\multicolumn{2}{|l|}{Dataset}');
for d = 1:D
    fprintf(fid, ' & \\multicolumn{%d}{|c|}{Dataset %d}', L, d);
end
fprintf(fid, '\\\\\n\\hline\n');

% Source
fprintf(fid, '\\multicolumn{2}{|l|}{Source}');
for d = 1:D
    fprintf(fid, ' & \\multicolumn{%d}{|c|}{\\cite{ds:%d}}', L, d);
end
fprintf(fid, '\\\\\n\\hline\n');

% Number Of Nodes
fprintf(fid, '\\multicolumn{2}{|l|}{Nodes}');
for d = 1:D
    fprintf(fid, ' & \\multicolumn{%d}{|c|}{%d}', L, S{d}(1,1).nodeN);
end
fprintf(fid, '\\\\\n\\hline\\hline\n');

% Headline
fprintf(fid, 'K & Method');
for d = 1:D
    for s = 1:L
        fprintf(fid,' & head%d',s);
    end
end
fprintf(fid, '\\\\\n\\hline\n');

%% loop over multiple k
for i = 1:N
    k = K(i);
    fprintf(fid, '\\multirow{%d}{*}{%d}\n', M, k);
    %% Loop over all methods
    for j = 1:M
        fprintf(fid, '& %s\n', names{j});
        %% Loop over datasets
        for d = 1:D
            stat = S{d}(i,j);
            fprintf(fid, '    ');
            %% Loop over Stats
            for s = 1:L
                fprintf(fid, '& %.2f', sFcts{s}(stat));
            end
            fprintf(fid, '\n');
        end
        fprintf(fid, '\\\\\n');
    end
    fprintf(fid, '\\hline\n');
end

%% Close table
fprintf(fid, '\\end{tabular}\n');

if ischar(filename)
    fclose(fid);
end
end

