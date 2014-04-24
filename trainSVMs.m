function [SVMModels] = trainSVMs(training, trainingclasses)
%trainSVMs trains SVM models using the training points and the classes they
%belong to.
%   trainSVMs will create an SVM model for each unique class in the vector
%   training classes.  training contains the feature vectors used to train
%   the models while trainingclasses contains the class that the feature
%   vector belongs to.  This function takes the one-versus-all approach to SVM multi-classification, meaning
%   that it will create a training model for each class.

%Create vector holding the unique classes of the training data
uniqueclasses = unique(trainingclasses);
%Array to hold SVM models
SVMModels = cell(length(uniqueclasses), 1);

for c=1:length(uniqueclasses)
   %Create each training svm
   %uniqueclasses(c) vs others - Create a binary version of the class
   %labels
   currclass = strcmp(trainingclasses, uniqueclasses(c));
   %Training svm is put into a struct
   SVMModels{c} = fitcsvm(training, currclass, 'ClassNames', [false true], 'Standardize', false, 'KernelFunction', 'linear', 'BoxConstraint', .005);
end


