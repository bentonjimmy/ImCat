function scanImages(directory, extension)
%
%

if(isdir(directory)) %Check if the parameter is an actual directory
    allfiles = dir(fullfile(directory, '*'+extension)); %Get a list of all the files in the directory
    j=1;
    for i=1:length(allfiles)
       if(allfiles(i).isdir == 0) %Remove an files that are directories
           files(j) = allfiles(i);
           j = j + 1;
       end
    end
    
    %Create the array that will hold all the random samples
    array = zeros(samplesize, pointssampled); 
   
    for i=1:length(files)
       sampledfilename{i, 1} = files(i).name;
       toread = strcat(directory,'/', sampledfilename{i, 1});
       image = imread(toread); %Load the image
       s = inspectImage(image); %Sample the image
       array(i, :) = s; %Store results 
       clear image; %remove the image to free up space
    end
    
end