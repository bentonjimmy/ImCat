function [x, a] = findEdges(im, filter, threshold)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

a = abs(filter2(filter, im));

ys = size(im, 1);
xs = size(im, 2);
x = zeros(xs, ys);

maxval = max(max(a));
minval = min(min(a));
diff = maxval - minval;

for i=1:xs
   for j=1:ys 
       nv = (a(i,j) - minval)/(diff);
       if(nv <= threshold)
           x(i,j) = 0;
       else
           x(i,j) = 1;
       end
   end
end

end

