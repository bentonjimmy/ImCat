function [IDX, D] = addToCluster(points, centroids)
%addToCluster Find the nearest cluster to a set of points
%   Using predefined cluster centroids the points will be assigned to the
%   nearest cluster based off of their euclidean distance to the centroids

%Get the number of rows in centroids
[rows, ~] = size(centroids);
%Find the nearest centroid to the given points
[IDX, D] = knnsearch(centroids, points, 'k', rows);

end

