function feature_points = generate_feature_points(imgs)





feature_points = struct();

for i = 1:size(imgs,1)
    
    image = imgs(i, :, :);
    [f,d] = vl_sift(single(reshape(image, 480, 512))) ;
    local_struct = struct();
    local_struct.frames = f;
    local_struct.descriptors = d;
    feature_points.("pic"+string(i)) = local_struct;


end