function [ varargout ] = loadOrCompute( filename, fct, varargin )
%LOADORCOMPUTE Either loads previously computed results or computes and
%saves the results.
%   Syntax:
%       [...] = loadOrCompute( filename, fct, param1, param2, ...);
%   Description:
%       This methods loads the results from the specified file and resturns
%       them, as long as the file exists. Note that in this case it is not
%       checked whether the parameters fit to the stored file. It is up to
%       the filename to ensure so.
%       If the file does not exists, the function handle fct is called with
%       the given paramters. Be aware that the number of stored output
%       parameters is determined by the call, not by fct.
%   Examples:
%       for r = 1:20
%           filename = sprintf('sqrt_%d.mat', r);
%           s = loadOrCompute(filename, @sqrt, r);
%           % Use s;
%       end;
n = nargout;
if n == 0
    n = nargout(fct);
end

if ~endsWith(filename, '.mat', 'IgnoreCase', true)
    filename = [filename, '.mat'];
end

if exist(filename, 'file')
    out = load(filename);
    varargout = out.out;
else
    out = cell(1,n);
    [out{1:n}] = fct(varargin{:});
    if ~isempty(filename)
        makeDirIfNotExists(fileparts(filename));
        save(filename, 'out');
    end
    varargout = out;
end

end

