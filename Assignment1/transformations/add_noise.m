function [noisy_source] = add_noise(source,mean, variance)	 % DOCSTRING_GENERATED
 % ADD_NOISE		 [adds noise to a source pcb file]
 % INPUTS 
 %			source = point cloud
 %			mean = 
 %			variance = 
 % OUTPUTS 
 %			noisy_source = ..


%ADD_NOISE adds guasian noise with mean and variance
noisy_source = source + mean * randn(size(source)) + variance;

end

