function SNR = signalToNoise(original, compressed)

if length(original) ~= length(compressed)
    error('length not matching');
end

signalError = original - compressed;
distortion = mean(signalError .^ 2);
SNR = 10 * log10(var(original) / distortion);

% It now occurs to me that an SNR function is amlost definitely built in to
% matlab...
end

