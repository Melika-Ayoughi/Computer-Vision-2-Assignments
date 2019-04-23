function set_out = subsample(set_in, percentage, method, normals)

sample_size = int32(floor(size(set_in, 2)*percentage));

if (strcmp(method, "uniform"))
    indices = randsample(size(set_in, 2), sample_size);
elseif (strcmp(method, "informed"))

    % selection on gradient magnitude
%     squared = normals .^ 2;
%     summed_gradients = sum(squared, 1);
%     magnitudes = summed_gradients .^ 0.5;

% alternative: selection on gradient dot product with normals for each point 
    multiplied = set_in .* normals;
    magnitudes = sum(multiplied, 1);
    [~, indices] = maxk(magnitudes, sample_size);
    
    
else
    error("wrong keyword in subsampling: "+method);
end

set_out = set_in(:, indices);

end