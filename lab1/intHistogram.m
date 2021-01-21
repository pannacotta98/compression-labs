function [counts, bins] = intHistogram(x, min, max)
    bins = (min:max)';
    counts = zeros(length(bins),1);
    
    for i = 1:length(x)
        matchingBin = bins == x(i);
        counts(matchingBin) = counts(matchingBin) + 1;
    end
    
    %% Check hehe
    if (sum(counts) ~= length(x))
        error('oops');
    end
end

