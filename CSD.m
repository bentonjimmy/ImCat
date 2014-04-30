function [descriptor] = CSD(im)
%CSD Creates the Color Structure Descriptor
%   Using the given image im, this function returns the Color Structure
%   Descriptor of the image.  The descriptor is found by first converting
%   the RGB image to an HMMD image, where H is hue, M is the max RGB value,
%   M is the min RGB value and D is the difference between the max and min.

hsvim = rgb2hsv(im); %convert to hsv image
[r, c, ~] = size(im); %get the size of the input image

%create the empty HMMD images, it only needs to have values for Hue, Diff
%and Sum
HMMDim = zeros(r, c, 3); 
%convert image to HMMD image
for i=1:r
   for j=1:c
       maxrgb = uint16(max(im(i, j, :)));
       minrgb = uint16(min(im(i, j, :)));
       angle = uint16(hsvim(i, j, 1) * 360);
       HMMDim(i, j, 1) = angle; %convert hue to 360 degrees
       difference = maxrgb - minrgb;
       HMMDim(i, j, 2) = difference; %calculate diff
       avgsum = (maxrgb + minrgb) / 2;
       HMMDim(i, j, 3) = avgsum; %calculate sum
   end
end

descriptor = zeros(1, 256); %the final image descriptor

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
             while(z<=64)%Check if the value already appears in vector or needs to be added
                if((structure_values(z, 1) == hue && structure_values(z, 2) == diff && structure_values(z, 3) == sum) || (structure_values(z, 1) == 0 && structure_values(z, 2) == 0 && structure_values(z, 3) == 0))
                    swhist(z) = swhist(z)+1;
                    structure_values(z, 1) = hue;
                    structure_values(z, 2) = diff;
                    structure_values(z, 3) = sum;
                    z = 65; %exit the loop
                end
                z = z+1;
             end
          end
       end
       y=1;
       %Add the colors found in the 8x8 structure to the CSD histogram
       while((y<=64) && (swhist(y) ~= 0))
           %quantize the values in the sw histogram 
           if(structure_values(y, 2) < 6)
               val = 1+floor(structure_values(y, 3) / 8);
           elseif(structure_values(y, 2) < 20)
               val = 33 + (floor(structure_values(y, 1)/90)*8) + floor(structure_values(y, 3)/32);
           elseif(structure_values(y, 2) < 60)
               val = 65 + (floor(structure_values(y, 1)/22.5)*4) + floor(structure_values(y, 3)/64);
           elseif(structure_values(y, 2) < 110)
               val = 129 + (floor(structure_values(y, 1)/22.5)*4) + floor(structure_values(y, 3)/64);
           else
               if(structure_values(y, 1) == 360)
                  structure_values(y, 1) = 359; 
               end
               val = 193 + (floor(structure_values(y, 1)/22.5)*4) + floor(structure_values(y, 3)/64);
           end
           if(val > 256)
               i
               j
               structure_values(y, 1)
               structure_values(y, 2)
               structure_values(y, 3)
             break;
           end
           %Increment the histogram by 1
           descriptor(val) = descriptor(val) + 1;
           y = y+1;
       end
   end
end

end

