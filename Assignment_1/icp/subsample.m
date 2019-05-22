function set_out = subsample(set_in, percentage, method, normals)	 % DOCSTRING_GENERATED
 % SUBSAMPLE		 [subsamples a part of the point cloud]
 % INPUTS 
 %			set_in = the set that enters
 %			percentage = percentage to keep
 %			method = method used for sampling
 %			normals = normals of set
 % OUTPUTS 
 %			set_out = the subsampled set



sample_size = int32(floor(size(set_in, 2)*percentage));

if (strcmp(method, "uniform"))
    indices = randsample(size(set_in, 2), sample_size);
elseif (strcmp(method, "informed"))

%  selection on gradient dot product with normals for each point 
    multiplied = set_in .* normals;
    magnitudes = sum(multiplied, 1);
    [~, indices] = maxk(magnitudes, sample_size);
    
else
    error("wrong keyword in subsampling: "+method);
end

set_out = set_in(:, indices);

end