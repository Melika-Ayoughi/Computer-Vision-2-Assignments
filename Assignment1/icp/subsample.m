function set_out = subsample(set_in, percentage, method, normals)

sample_size = int32(floor(size(set_in, 2)*percentage));

if (strcmp(method, "uniform"))
    indices = randsample(size(set_in, 2), sample_size);
elseif (strcmp(method, "informed"))

    % for now, selection on gradient magnitude, if you can think of
    % something better? someone mentioned a distance threshold TODO: reconsider
    squared = normals .^ 2;
    summed_gradients = sum(squared, 1);
    magnitudes = summed_gradients .^ 0.5;
    [~, indices] = maxk(magnitudes ,sample_size);
    
else
    error("wrong keyword in subsampling: "+method);
end

set_out = set_in(:, indices);

end