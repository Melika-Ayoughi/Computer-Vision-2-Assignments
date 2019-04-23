function [noisy_source] = add_noise(source,mean, variance)
%ADD_NOISE adds guasian noise with mean and variance
noisy_source = source + mean * randn(size(source)) + variance;
end

