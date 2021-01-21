hey04  = 128 * audioread('hey04_8bit.wav');
nuit04 = 128 * audioread('nuit04_8bit.wav');
speech = 128 * audioread('speech.wav');

x = hey04;
[counts, bins] = intHistogram(x, -128, 127);

probs = counts ./ length(x);