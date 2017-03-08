function [ points, classes, identifier ] = createDataset( type, varargin )
%LOADDATASET gets a dataset
%   Synatx:
%       [ points, classes ] = createDataset( type, N, param1, value1, ... );
%   Description:
%       This function returns a dataset consisting of points, corresponding
%           classes and a dataset identifier.
%   Supported types are:
%       'rings':
%           This function creates a number of concentric circles. N is
%           here a vector with the number of points in each.
%           Parameters:
%               'sigma': The standard deviation of the radius for each
%                   ring. This can be a scalar or a vector with a different
%                   value for each ring. If there are less values than
%                   rings, the last value is repeated.
%                   Default: 0.1
%               'radius': A vector with radii for the rings. Note that each
%                   value just stores the distance to the previous ring. If
%                   the vector is to short, it is filled with the last
%                   value. This allows to define the default as equidistant
%                   rings that start with a circle in the center as [0 1]
%                   Default: 1
%       'spirals':
%           This function creates a number of spirals. N is
%           here the number of points.
%           Parameters:
%               'C':
%               'sigma':
%               'r0':
%               'phi':
%   General parameters:
%       'seed': The seed for the random generator. This allows to run
%           repreatable tests. Default: 1

parser = inputParser;
parser.addParamValue('seed', 1);
switch lower(type)
    case 'rings'
        % Parse input
        parser.addOptional('N', [10 20]);
        parser.addParameter('sigma', 0.1);
        parser.addParameter('radius', 1);
        parser.parse(varargin{:});
        
        N    = parser.Results.N;
        seed = parser.Results.seed;
        sig  = parser.Results.sigma;
        R    = parser.Results.radius;
        
        % Process input
        N    = reshape(N, 1, []);
        n    = numel(N);
        sig  = enforceRowVector(sig, n);
        R    = enforceRowVector(R, n);
        rStr = vec2str(R, true);
        R    = cumsum(R);
        
        % Compute further parameters
        eID = cumsum(N);
        sID = [1, eID(1:end-1)+1];
        
        % Initialize return
        M = sum(N);
        points  = zeros(M,2);
        classes = zeros(M,1);
        
        % create identifier
        identifier = sprintf('rings(N=%s,s=%s,r=%s)', mat2str(N), vec2str(sig), rStr);
        
        % Generate points
        s = rng(seed);
        for ring = 1:n
            m = N(ring);
            % Angle
            a = rand(m,1) * 2 * pi;
            % Radius
            r = R(ring) + sig(ring).*randn(m,1);
            % Compue the points
            [x, y] = pol2cart(a, r);
            points(sID(ring):eID(ring),:) = [x y];
            % set class
            classes(sID(ring):eID(ring)) = ring;
        end
        rng(s);
        
        
    case 'spirals'
        % Parse input
        parser.addOptional('N', 1000);
        parser.addParameter('C', 3);
        parser.addParameter('sigma', 0.05);
        parser.addParameter('r0', 0.2);
        parser.addParameter('phi', 200);
        parser.parse(varargin{:});
        
        N    = parser.Results.N;
        C    = parser.Results.C;
        seed = parser.Results.seed;
        r0   = parser.Results.r0;
        phi  = parser.Results.phi;
        sig  = parser.Results.sigma;
        
        phi = pi * phi / 180;
        
        % Initialize return
        points  = zeros(N,2);
        
        % create identifier
        identifier = sprintf('spiral(N=%d,C=%d,s=%g,r0=%g,phi=%g)', N, C, sig, r0, phi);
        
        % Generate points
        s = rng(seed);
        
        % Undistorted angle and radius
        a = rand(N,1);
        A = a * phi;
        R = r0 + (1-r0) * a;
        % Distortion (of radius)
        % R = R .* exp(randn(N,1) * sig);
        R = R + randn(N,1) * sig;
        
        % devide into classes
        classes = randi(C,N,1);
        A = A + (classes/C) * 2 * pi;
        
        points(:,1) = R .* cos(A);
        points(:,2) = R .* sin(A);
        rng(s);
        
        
    otherwise
        error('Dataset type "%s" is not supported', type);
end

% append seed to identifier
identifier = sprintf('%s.S%d', identifier, seed);
end

function b = allEquals(X)
    if iscell(X)
        b = all(cellfun(@(x) isequal(X{1},x), X(:)));
    else
        b = all(X(1) == X(:));
    end
end

function V = enforceRowVector(V, n)
    V = reshape(V, 1, []);
    m = numel(V);
    if m < n 
        V = [V, repmat(V(end), 1, n - m)];
    end
    if m > n
        V = V(1:n);
    end
end   

function str = vec2str(V, dynLen)
    if nargin < 2 || ~dynLen
        if allEquals(V)
            str = sprintf('%g', V(1));
        else
            str = mat2str(V);
        end
    else
        while numel(V) > 1 && V(end-1) == V(end)
            V(end) = [];
        end
        str = mat2str(V);
    end
end