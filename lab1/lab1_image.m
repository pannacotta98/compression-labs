clear
format compact

baboon = double(imread('baboon.png'));
boat = double(imread('boat.png'));
woodgrain = double(imread('woodgrain.png'));

x = woodgrain;

numPixels = size(x, 1) * size(x, 2);

[counts, bins] = intHistogram(x(:), 0, 255);
probs = counts ./ numPixels;
entropy = -sum(probs .* log2(probs), 'omitnan')

%% Count horizonatal pairs
numHorPairs = size(x, 2) * (size(x, 1) - 1); % TODO
horPairCounts = zeros(length(bins));

for row = 1:size(x,1)
    for col = 1:(size(x,2) - 1)
        match1 = x(row, col) == bins;
        match2 = x(row, col + 1) == bins;
        
        if nnz(match1) ~= 1 || nnz(match2) ~= 1
           error('men va nu då eller'); 
        end
        
        horPairCounts(match1, match2) ...
                = horPairCounts(match1, match2) + 1;
    end
end

horPairProbs = horPairCounts ./ numHorPairs;

% H(Xi,j,Xi+1,j)
horPairEntropy = -sum(horPairProbs(:) .* log2(horPairProbs(:)), 'omitnan')
% H(Xi+1,j | Xi,j)
horCondEntropy = horPairEntropy - entropy

%% Count vertical pairs
numVertPairs = size(x, 2) * (size(x, 1) - 1); % TODO
vertPairCounts = zeros(length(bins));

for col = 1:size(x,1)
    for row = 1:(size(x,2) - 1)
        match1 = x(row, col) == bins;
        match2 = x(row + 1, col) == bins;
        
        if nnz(match1) ~= 1 || nnz(match2) ~= 1
           error('men va nu då eller'); 
        end
        
        vertPairCounts(match1, match2) ...
                = vertPairCounts(match1, match2) + 1;
    end
end

vertPairProbs = vertPairCounts ./ numVertPairs;

vertPairEntropy = -sum(vertPairProbs(:) .* log2(vertPairProbs(:)), 'omitnan')
vertCondEntropy = vertPairEntropy - entropy














