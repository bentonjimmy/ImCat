function [Scores, maxScore] = SVMClassify(SVMModels, classify, numOfClasses)
%SVMClassify is used to classify the feature vectors using the given models
%   Using the SVM models passed in SVMModels, the feature vectos in
%   classify will be classified into numOfClasses classes.  This function
%   takes the one-versus-all approach to SVM multi-classification, meaning
%   that it will predict the classes of each feature vector numOfClasses
%   times.

%Use Models to predict the points in classify
for c=1:numOfClasses
    [~, score] = predict(SVMModels{c}, classify);
    Scores(:,c) = score(:,2); % Second column contains positive-class scores
end

%Assign the points in classify to the class with the highest score
[~,maxScore] = max(Scores,[],2);

end

