function [quantized, stepSize] = uniformQuantization(x, stepSize)
    quantized = round(x / stepSize);
end