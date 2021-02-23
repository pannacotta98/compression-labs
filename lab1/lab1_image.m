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

%% Huffman
noPredRate = huffman(probs)

% Nog fel
pred1Rate = huffmanDiffRate(x, predictor1(x))
% Hmm
pred2Rate = huffmanDiffRate(x, predictor2(x))
% Really not sure
pred3Rate = huffmanDiffRate(x, predictor3(x))

%% Functions

function pred = predictor1(samples)
    pred = zeros(size(samples, 1), size(samples, 2));
    pred(1,:) = 128;
    for i = 2:size(pred, 1)
       pred(i,:) = samples(i-1,:); 
    end
end
% function pred = predictor1(samples)
%     pred = zeros(size(samples, 1), size(samples, 2));
%     padSamples = padarray(samples, [1,0], 128, 'pre');
%     for i = 1:size(pred, 1)
%        pred(i,:) = padSamples(i,:);
%     end
% end

function pred = predictor2(samples)
    pred = zeros(size(samples, 1), size(samples, 2));
    pred(:,1) = 128;
    for i = 2:size(pred, 2)
       pred(:,i) = samples(:,i-1); 
    end
end

% Pi,j = Xi-1,j + Xi,j-1 - Xi-1,j-1
function pred = predictor3(samples)
    pred = zeros(size(samples, 1), size(samples, 2));
    padSamples = padarray(samples, [1,1], 128, 'pre');
    for i = 1:size(pred, 1)
        for j = 1:size(pred, 2)
            % padSamples have additional values at the first index, thus
            % the indices are offset by +1
            pred(i,j) = padSamples(i,j+1) + padSamples(i+1,j) - padSamples(i,j);
        end
    end
end

function rate = huffmanDiffRate(samples, predictedSamples)
    if (size(samples) ~= size(predictedSamples))
        error('size mismatch');
    end
    diff = samples - predictedSamples;
    numPixels = size(diff, 1) * size(diff, 2);
%     [counts, ~] = intHistogram(diff(:), -255, 255);
    [counts, ~] = ihist(diff(:));
    probs = counts ./ numPixels;
    rate = huffman(probs) / 1;
end













