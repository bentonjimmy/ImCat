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
for j=1:(c-7)
   swhist = zeros(361, 256, 256); %histogram of values in the structure
   for i=1:(r-7)
       %go through 8x8 pixel structure
       structure_values = zeros(64, 3); %the values in the 8x8 structure
       %swhist = zeros(1, 64); %histogram of values in the structure
       if(i<9) %Get the initial 8x8 values
           for a=i:(i+7)
              for b=j:(j+7)
                 %hue = HMMDim(a, b, 1);
                 %diff = HMMDim(a, b, 2);
                 %sum = HMMDim(a, b, 3);
                 swhist(HMMDim(a, b, 1), HMMDim(a, b, 2), HMMDim(a, b, 3)) = swhist(HMMDim(a, b, 1), HMMDim(a, b, 2), HMMDim(a, b, 3)) + 1;
              end
           end
       else %After the first 8x8 are read, read the 9th row and so on
           for b=j:(j+7)
                 %hue = HMMDim(i, b, 1);
                 %diff = HMMDim(i, b, 2);
                 %sum = HMMDim(i, b, 3);
                 swhist(HMMDim(i, b, 1), HMMDim(i, b, 2), HMMDim(i, b, 3)) = swhist(HMMDim(i, b, 1), HMMDim(i, b, 2), HMMDim(i, b, 3)) + 1;
                 swhist(HMMDim(i-8, b, 1), HMMDim(i-8, b, 2), HMMDim(i-8, b, 3)) = swhist(HMMDim(i-8, b, 1), HMMDim(i-8, b, 2), HMMDim(i-8, b, 3)) + 1;
           end
       end
       
       %Add the colors found in the 8x8 structure to the CSD histogram
       for x=1:361 %represents hue
           for y=1:256 %represents diff
               for z=1:256 %represents sum
                   if(swhist(x, y, z) > 1)%The value appeared at least once
                       %quantize the values in the sw histogram 
                       if((y-1) < 6)
                           val = 1+floor((z-1) / 8);
                       elseif((y-1) < 20)
                           val = 33 + (floor((x-1)/90)*8) + floor((z-1)/32);
                       elseif((y-1) < 60)
                           val = 65 + (floor((x-1)/22.5)*4) + floor((z-1)/64);
                       elseif((y-1) < 110)
                           val = 129 + (floor((x-1)/22.5)*4) + floor((z-1)/64);
                       else
                           hue = x;
                           if((hue-1) == 360)
                              hue = 359; 
                           end
                           val = 193 + (floor(hue/22.5)*4) + floor((z-1)/64);
                       end
                       %Increment the histogram by 1
                       descriptor(val) = descriptor(val) + 1;
                   end
               end
           end
       end
        
   end
end

end

