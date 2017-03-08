function printMainStatsTable( filename, stats, varargin )
%PRINTMAINSTATSTABLE prints a table with main statistics
%   Syntax:
%       printMainStatsTable( filename, stats )
%       printMainStatsTable( filename, stats, names1, names2,  )
%   Description:
%       This method prints some main statistics for a number of graphs.
%       Each graph can either be given directly be the graph or as a 
%           cell with method and parameters.
%       Optional, the methods can be named

%% parse inputs
n = numel(stats);

names = varargin;
for i = (numel(names) + 1) : n
    names{i} = sprintf('Graph %d', i);
end

if ~isempty(filename)
    if ischar(filename)
        fid = fopen(filename, 'wt');
    else
        fid = filename;
    end
else
    fid = 1;
end

%% Output
len = max(cellfun(@numel, names));
for i = 1:len
    fprintf('-');
end
fprintf('-+--------+--------+-------- \n');
format = ['%', num2str(len), 's | %6.3f | %6.3f | %6.3f \n'];

for j = 1:numel(stats)
    fprintf(fid, format, names{j}, stats(j).avgDegree, stats(j).stdDegree, stats(j).sumOfDist);
end

%% Clean up
if fid ~= 1 && ischar(filename)
    fclose(fid);
end

