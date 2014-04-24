function [fv] = myquantize(pointloc)
%myquantize Quantizes the clustered points in pointloc
%   Given a vector containing the cluster locations for a vector of points,
%   this function will quantize those points into a histogram feature
%   vector that creates a unique value for each of the points in pointloc.
%   Pointloc - A vector containing the assigned cluster of each image to be
%   quantized

%Get the number of unique clusters
clusters = unique(pointloc);
%This vector holds the next value to be entered into an image feature
%vector
countvector = ones(1,length(clusters));
%Create the array to hold the feature vectors
fv = zeros(length(pointloc),(length(clusters)));

for i=1:length(pointloc)
    fv(i, pointloc(i)) = countvector(pointloc(i));
    %Increment countvector to the next value to assign
    countvector(pointloc(i)) = countvector(pointloc(i)) + 1;
end

end

