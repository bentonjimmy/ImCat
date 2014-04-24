function [Scores, maxScore, classifyclasses] = master_func(TrainingDir, filesToSample, sampleCount, numClusters, ClassifyDir)
%master_func runs all the other functions to train SVMs and predict classes
%   This function is used to run all the other functions.  TrainingDir
%   contains the images to be used for training the SVM models.
%   filesToSample is the number of files in TrainingDir that will be used
%   to train the SVMs.  sampleCount is the number of times an image will be
%   sampled.  numClusters is the number of clusters to creating during the
%   k-means clustering portion of the process.

%Training portion
[samparray, ~, fileclass] = samplefiles(TrainingDir, filesToSample, sampleCount);
[IDX, C] = mycluster(samparray, numClusters);
[fvt] = myquantize(IDX);
[SVMModels] = trainSVMs(fvt, fileclass);

%Classification portion
[carray, ~, classifyclasses] = samplefiles(ClassifyDir, 'all', sampleCount);
[cIDX] = addToCluster(carray, C);
[fvc] = myquantize(cIDX);
[Scores, maxScore] = SVMClassify(SVMModels, fvc, length(unique(fileclass)));

end

