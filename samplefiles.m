function [samparray, sampledfilename, fileclass] = samplefiles(directory, samplesize, pointssampled)
%SampleFiles This will sample the samplesize number of files in the
%directory.  Each file is sampled pointssampled amount of times.
%   This will sample the samplesize number of files in the
%directory.  Each file is sampled pointssampled amount of times.

if(isdir(directory)) %Check if the parameter is an actual directory
    allfiles = dir(directory); %Get a list of all the files in the directory
    j=1;
    for i=1:length(allfiles)
       if(allfiles(i).isdir == 0) %Remove an files that are directories
           files(j) = allfiles(i);
           j = j + 1;
       end
    end
    
    if(strcmpi(samplesize, 'all') == 1)
       samplesize = length(files); 
    elseif(samplesize > length(files))
       samplesize = length(files); 
    end
    %Create the array that will hold all the random samples
    samparray = zeros(samplesize, pointssampled); 
    %If the samplesize is the size of the entire directory just take all
    %the files
    if(length(files) ~= samplesize)
        filesample = randsample(files, samplesize, true);
    else
        filesample = files;
    end
    sampledfilename = cell(length(filesample), 1); %Vector to hold the file names being sampled
    fileclass = cell(length(filesample), 1);%Vector to hold the class type of the file
    
    for i=1:length(filesample)
        %The first two letters of the file name, before the underscore,
        %represent the class of the image
       fileclass{i, 1} = strtok(filesample(i).name, '_');
       sampledfilename{i, 1} = filesample(i).name;
       toread = strcat(directory,'/', sampledfilename{i, 1});
       image = imread(toread); %Load the image
       s = sample(image, pointssampled); %Sample the image
       samparray(i, :) = s;
       clear image; %remove the image to free up space
    end
end

end

