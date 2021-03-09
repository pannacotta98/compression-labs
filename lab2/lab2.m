%% Parameters
clear
% Typical block sizes for audio coding are 256--2048 sample // Slides
windowSize = 512;
quantSteps = 24;

%% Read data
[x, Fs] = audioread('audio/heyhey.wav');

stepSize = (max(x) - min(x)) / quantSteps;

%% Compression
xTransf = mdct(x, windowSize);
quantizedTransf = uniformQuantization(xTransf, stepSize);

%% Reconstruct and play
xRec = imdct(quantizedTransf * stepSize);
player = audioplayer(xRec, Fs);
play(player)

%% Calculate stats
SNR = signalToNoise(x, xRec)
% This seems to be wrong...
quantHist = ihist(quantizedTransf(:));
probs = quantHist / sum(quantHist);
R = huffman(probs)

%% Stop audio
clear player % ?