function [G, Adj]=lambda_knn_combined(Points,k,f1,f2,lambdaMethod)
% LAMBDA_DIR_COMBINED this method computes a directed graph using the
% combines lambda-KNN method.
%   Syntax:
%       [G, Adj]=lambda_knn_combined(Point,k,f1,f2);
%       [G, Adj]=lambda_knn_combined(Point,k,f1,f2,lambdaMethod);
%   Description:
%       This method computes a directed graph using the combines lambda-KNN
%       method. For this, a parameter mult and k as well as two factors f1
%       and f2 have to be given. The local k is then the product of k and
%       mult.
%       Points contains the data points as matrix with one row for each
%           point.
%       The optional parameter lambdaMethod allows to compute lambda1 and
%           lambda2 in different ways, following
%               lambda1 = f1 * R
%               lambda2 = f2 * N * R
%           Possible methods to compute R are:
%           'one'     : R = 1
%           'min'     : R = min(dist(:))   
%           'avgmin'  : R = mean(min(dist));
%           'medmin'  : R = median(min(dist));
%           'avgk'    : R = mean(mean(sort_dist(1:k,:)))
%           'amedk'   : R = mean(median(sort_dist(1:k,:)))
%           'medk'    : R = median(sort_dist(1:k,:)(:))
%           'maxk'    : R = max(sort_dist(k,:))
%           'avgmaxk' : R = mean(sort_dist(k,:));
%           'medmaxk' : R = median(sort_dist(k,:));    (default)
%           here the local and global R might differ if k has two elements

%% Parse input
if nargin < 5 || isempty(lambdaMethod)
    lambdaMethod = 'medmaxk';
end

% deal with double k
if numel(k) == 1
    k = [k k];
end
kL = k(1);
kG = k(2);

[N]=size(Points, 1);

G=Inf(N);
Adj=zeros(N);
Table=zeros(N*(N-1),4);

% Compute pairwise distances
dist = pdist2(Points,Points,'cityblock');
dist(diag(true(N,1))) = Inf;

% Adapt lambda - weights
refValue = [0 0];
for i = 1:2
    switch lower(lambdaMethod)
        case 'one'
            refValue(i) = 1;
        case 'min'
            refValue(i) = min(dist(:));
        case 'avgmin'
            refValue(i) = mean(min(dist));
        case 'medmin'
            refValue(i) = median(min(dist));
        case 'avgk'
            sdist = sort(dist,2);
            refValue(i) = mean(mean(sdist(:,1:k(i))));
        case 'amedk'
            sdist = sort(dist,2);
            refValue(i) = mean(median(sdist(:,1:k(i))));
        case 'medk'
            sdist = sort(dist,2);
            sdist = sdist(:,1:k(i));
            refValue(i) = median(sdist(:));
        case 'maxk'
            sdist = sort(dist,2);
            sdist = sdist(:,k(i));
            refValue(i) = max(sdist(:));
        case 'avgmaxk'
            sdist = sort(dist,2);
            sdist = sdist(:,k(i));
            refValue(i) = mean(sdist(:));
        case 'medmaxk'
            sdist = sort(dist,2);
            sdist = sdist(:,k(i));
            refValue(i) = median(sdist(:));
    end
end
lamda1=f1*refValue(1);
lamda2=f2*N*refValue(2);

V=Inf(N);
rank=zeros(1,N);
for i=1:N
    [~,index]=sort(dist(i,:)); 
    for l=1:N
        rank(1,index(l))=l;
    end
    for j=1:N
        if(i==j)
            continue;
        else
            V(i,j)=dist(i,j)+lamda1*(2*rank(1,j)-2*kL-1);
        end
    end         
end

count=0;
for i=1:N
    for j=1:N
        if(V(i,j)==Inf)
            continue;
        else
            count=count+1;
            Table(count,1)=i;
            Table(count,2)=j;
            Table(count,3)=V(i,j);
            Table(count,4)=dist(i,j);
        end
    end
end

Table=sortrows(Table,3);
avg_deg=0;
F=0+lamda2*(0-kG)^2;

G_new=G;
Adj_new=Adj;

for i=1:count     
    
    G_new(Table(i,1),Table(i,2))=Table(i,4);   
    Adj_new(Table(i,1),Table(i,2))=1; 
    
    delta=Table(i,3)+lamda2*((avg_deg+(1/N)-kG)^2-(avg_deg-kG)^2);    
    
    F_new=F+delta;
   
    if(F_new>=F)
       break;             
    else
        F=F_new;
        G=G_new;  
        Adj=Adj_new;                
        avg_deg=avg_deg+(1/N);       
    end
end
end