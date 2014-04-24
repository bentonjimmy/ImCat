function s = sample(image, ss)
%Sample will sample the values of an image an ss number of times
%   This will create a vector that contains an ss number of values sampled
%   from the input image.  This function assumes the images are 3-layer jpg
%   files.

%Get the size of the image
[rows, cols, z] = size(image);
%Check if the sampe size is greater than the image
if(ss > (rows * cols))
   ss =  (rows * cols);
end
%Create an empy vector to hold the random samples
s = zeros(1, ss);
randrow = randsample(1:rows, ss, true);
randcol = randsample(1:cols, ss, true);
for i=1:ss
    %Get the value at a random row and col for all three layers of a jpg.
    %The values of all three layers are concatenated to make a value that
    %still represents all three layers without adding complexity by keeping
    %the values in 3 dimensions
    val = (uint32(image(randrow(i), randcol(i), 1)) * 1000000) + (uint32(image(randrow(i), randcol(i), 2)) * 1000) + (uint32(image(randrow(i), randcol(i), 3)));
    s(1, i) = val; 
end

end

