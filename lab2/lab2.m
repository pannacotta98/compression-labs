%% Parameters
clear
% Typical block sizes for audio coding are 256--2048 sample // Slides
windowSize = 256;

%% Read data
[x, Fs] = audioread('audio/heyhey.wav');

%% Compression
xTransf = mdct(x, windowSize);
% quantize


%% Play
player = audioplayer(xRec, Fs);
play(player)

%% Stop audio
clear player % ?