function [IDX, C, D] = mycluster(carray, numclusters, startloc)
%mycluster Uses k-means clustering to cluster the points in carray into
%numclusters clusters
%   Using the k-means clustering algorithm, mycluster will take the points
%   passed in carray and cluster them into the number of clusters specified
%   in numclusters.  An optional third parameter can also be passed which
%   can contain starting locations for the clusters.

%Check the number of arguments passed since startloc is optional
if(nargin < 3) 
    [r, c] = size(carray);
    if(numclusters > r)
        numclusters = r;
    end
    %Take a random sample to create initial locations of clusters
    s = randsample(1:r, numclusters);
    for i=1:length(s)
          %Put rows at s(i) into startloc
          startloc(i,:) = carray(s(i), :);
    end
end

%Cluster the data points using kmeans clustering
[IDX, C, ~, D] = kmeans(carray, numclusters, 'start', startloc);


end

