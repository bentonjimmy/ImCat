function [descriptor] = CSD(im)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

hsvim = rgb2hsv(im); %convert to hsv image
[r, c] = size(im); %get the size of the input image

%create the empty HMMD images, it only needs to have values for Hue, Diff
%and Sum
HMMDim = zeros(r, c, 3); 
%convert image to HMMD image
for i=1:r
   for j=1:c
       maxrgb = max(im(i, j, :));
       minrgb = min(im(i, j, :));
       HMMDim(i, j, 1) = hsvim(i, j, 1) * 360; %convert hue to 360 degrees
       HMMDim(i, j, 2) = maxrgb - minrgb; %calculate diff
       HMMDim(i, j, 3) = (maxrgb + minrgb)/2; %calculate sum
   end
end

%descriptor = zeros(1, 255); %the final image descriptor
%THE QUANTIZATION IS NOT LINEAR; HOWS SHOULD IT BE STORED?

%evaluate each pixel in the image
for i=1:(r-7)
   for j=1:(c-7)
       %go through 8x8 pixel structure
       structure_values = zeros(64, 3); %the values in the 8x8 structure
       swhist = zeros(1, 64); %histogram of values in the structure
       for a=i:(i+7)
          for b=j:(j+7)
             hue = HMMDim(a, b, 1);
             diff = HMMDim(a, b, 2);
             sum = HMMDim(a, b, 3);
             z=1;
             while(z<=64)
                if((structure_values(z, 1) == hue && structure_values(z, 2) == diff && structure_values(z, 3) == sum) || (structure_values(z, 1) == 0 && structure_values(z, 2) == 0 && structure_values(z, 3) == 0))
                    swhist(z) = swhist(z)+1;
                end
                z = z+1;
             end
          end
       end
       y=1;
       while((y<=64) && (swhist(y) ~= 0))
           %quantize the values in the sw histogram 
           if(diff < 6)
               sumval = floor((structure_values(y, 3)*255) / 8);
           elseif(diff < 20)
                   
           elseif(diff < 60)
               
           elseif(diff < 110)
               
           else
               
           end
           y = y+1;
       end
   end
end

end

