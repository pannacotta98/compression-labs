clear
format compact
%% Parameters
clear
% Typical block sizes for audio coding are 256--2048 sample // Slides
windowSize = 512;
quantSteps = 24.3;

%% Read data
[x, Fs] = audioread('audio/heyhey.wav');

stepSize = (max(x) - min(x)) / quantSteps;
maxRate = 128000 / Fs

%% Compression
xTransf = mdct(x, windowSize);
quantizedTransf = uniformQuantization(xTransf, stepSize);

%% Reconstruct and play
xRec = imdct(quantizedTransf * stepSize);
player = audioplayer(xRec, Fs);
play(player)
audiowrite('compressedReconstructed.wav', xRec, Fs);

%% Calculate stats
SNR = signalToNoise(x, xRec)
% This seems to be wrong...
quantHist = ihist(quantizedTransf(:));
probs = quantHist / sum(quantHist);
R = huffman(probs)

N = length(quantHist)
lengthsData = N * ceil(log2(N - 1))

%stepSizeIn16Bit = 0.5 * (2^16) * stepSize

RWithSideInfo = R + lengthsData / length(x)

%% Stop audio
clear player % ?
