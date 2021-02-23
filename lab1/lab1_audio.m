%% ===== AUDIO =====
clear
format compact

hey04  = 128 * audioread('hey04_8bit.wav');
nuit04 = 128 * audioread('nuit04_8bit.wav');
speech = 128 * audioread('speech.wav');

x = hey04;
[counts, bins] = intHistogram(x, -128, 127);

probs = counts ./ length(x);

entropy = -sum(probs .* log2(probs), 'omitnan')

%% Count pairs
numPairs = length(x) - 1;
pairCounts = zeros(length(bins));

for i = 1:numPairs
    matching1 = x(i) == bins;
    matching2 = x(i+1) == bins;
    pairCounts(matching1, matching2) = pairCounts(matching1, matching2) + 1;
end

%% ...
pairProbs = pairCounts ./ numPairs;
condProbs = pairCounts ./ counts; % is this right?

pairEntropy = -sum(pairProbs(:) .* log2(pairProbs(:)), 'omitnan') % H(Xi,Xi+1)
condEntropy = pairEntropy - entropy % H(Xi+1 | Xi)
% condEntropy2 = -sum(pairProbs(:) .* log2(condProbs(:)), 'omitnan');

%% Huffman no memory
dataRateNoMem = huffman(probs) / 1

%% Huffman differences
dataRateMem1 = huffmanDiffRate(x, predictor1(x))
dataRateMem2 = huffmanDiffRate(x, predictor2(x))

disp(' ')

%% Local functions

%Pi = Xi-1
function pred = predictor1(samples)
    pred = zeros(length(samples),1);
    % First prediction is zero
    for i = 2:length(pred)
        pred(i) = samples(i-1);
    end
end

% Pi = 2*Xi-1-Xi-2
function pred = predictor2(samples)
    pred = zeros(length(samples),1);
    % First prediction is zero
    pred(2) = 2*samples(1);
    for i = 3:length(pred)
        pred(i) = 2*samples(i-1) - samples(i-2);
    end
end

function rate = huffmanDiffRate(samples, predictedSamples)
    diff = samples - predictedSamples;
    [counts, ~] = intHistogram(diff, -255, 255);
    probs = counts ./ length(samples);
    rate = huffman(probs) / 1;
end













