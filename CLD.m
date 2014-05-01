function [CLD, tinyim] = CLD(im)
%CLD Color Layout Descriptor
%   Detailed explanation goes here

[r, c, d] = size(im); %get the size of the input image
partitionr = floor(r/8); %size of the row partitions
partitionc = floor(c/8); %size of the column partitions

tinyim = uint8(zeros(8,8,d));
%get the average color in each partition
for i=0:7
    for j=0:7
        avgd1 = uint32(0);
        avgd2 = uint32(0);
        avgd3 = uint32(0);
        for k=(i*partitionr + 1):((i+1)*partitionr)
            for l=(j*partitionc + 1):((j+1)*partitionc)
               avgd1 = avgd1+uint32(im(k, l, 1));
               avgd2 = avgd2+uint32(im(k, l, 2));
               avgd3 = avgd3+uint32(im(k, l, 3));
            end    
        end  
        %find the average pixel value
        tinyim(i+1, j+1, 1) = avgd1/(partitionc * partitionr);
        tinyim(i+1, j+1, 2) = avgd2/(partitionc * partitionr);
        tinyim(i+1, j+1, 3) = avgd3/(partitionc * partitionr);
    end
end

%convert tiny image to YCbCr
tinyYCbCr = rgb2ycbcr(tinyim);

%Calculate Discrete Cosine Transformations
dctY = dct2(tinyYCbCr(:, :, 1));
dctCb = dct2(tinyYCbCr(:, :, 2));
dctCr = dct2(tinyYCbCr(:, :, 3));

CLD = double(zeros(1,12));
%Get the first 6 values from dctY - zigzag order
CLD(1) = dctY(1, 1);
CLD(2) = dctY(1, 2);
CLD(3) = dctY(2, 1);
CLD(4) = dctY(3, 1);
CLD(5) = dctY(2, 2);
CLD(6) = dctY(1, 3);
%Get 3 values from dctCb - zigzag order
CLD(7) = dctCb(1, 1);
CLD(8) = dctCb(1, 2);
CLD(9) = dctCb(2, 1);
%Get 3 values from dctCr - zigzag order
CLD(10) = dctCr(1, 1);
CLD(11) = dctCr(1, 2);
CLD(12) = dctCr(2, 1);

end

