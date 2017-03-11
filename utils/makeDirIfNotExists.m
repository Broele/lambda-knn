function makeDirIfNotExists( dir )
%MAKEDIRIFNOTEXISTS creates a directory, if it doesn't exist
%   Syntax:
%       makeDirIfNotExists( dir )

if ~exist(dir, 'dir')
    mkdir(dir);
end

end

