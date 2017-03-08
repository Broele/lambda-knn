function [G, Adj]=kRNN(Point,k)
%KRNN creates the neighborhood graph for a set of points using the k-rnn
%method
%   Syntax:
%       [G, Adj] = kRNN( Point, k)
%   Description:
%       G is a graph where G(i,j) represents the weight of the edge from i
%           to j. G(i,j) = inf means that there is no edge.
%       Adj is the binarized version of G

%% Initialize
m=2*k;

[N, Ndim]=size(Point);

G=Inf*ones(N);
Adj=zeros(N);

%% Computing the table
col = repmat(1:N, N,1);
col(diag(true(1,N))) = 0;
Table = [squareform(col')', squareform(col)', pdist(Point, 'cityblock')'];
dist = squareform(Table(:,3));
dist(diag(true(1,N))) = inf;
count = size(Table,1);

Table=sortrows(Table,3);


%% main loop
G=Inf*ones(N);
Adj=false(N);
averageDegree=0;
maxDegree=k;

while(averageDegree<k && maxDegree<=m)
    
    % Iteratively check pairs in the Table
    for iter=1:count
        if(Table(iter,3)==Inf)
            % Entry was already used
            continue;
        end
        i = Table(iter,1);
        j = Table(iter,2);
        if max(sum(Adj([i,j],:),2)) < maxDegree
            % Degree of both nodes  < maxDegree
            G(i,j)   = Table(iter,3);
            Adj(i,j) = true;
            G(j,i)   = Table(iter,3);
            Adj(j,i) = true;
            Table(iter,3)=Inf;
        end
    end
    
    % Update Values
    maxDegree=maxDegree+1;
    sumDegree=sum(sum(Adj));    
    averageDegree=floor(sumDegree/N); 
   
end

end
