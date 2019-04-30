function [F] = eight_point(picture_1, picture_2, method)

% find points
[frame_1,descriptors_1] = vl_sift(single(reshape(picture_1, 480, 512))) ;
[frame_2,descriptors_2] = vl_sift(single(reshape(picture_2, 480, 512))) ;

% filter
[frame_1,descriptors_1] = filter_feature_points(frame_1 ,descriptors_1);
[frame_2,descriptors_2] = filter_feature_points(frame_2 ,descriptors_2);

[matches, scores] = vl_ubcmatch(descriptors_1, descriptors_2) ; % todo: maybe we can use the scores for something about filtering???

A = zeros(size(matches,2), 9);


if (strcmp(method, "normalized"))

    [T_1, T_2] = find_T_matrix(matches, frame_1, frame_2);

end

for i = 1:size(matches,2)
    
    match_index_1 = matches(1, i);
    match_index_2 = matches(2, i);
    
    x_1 = frame_1(1, match_index_1);
    y_1 = frame_1(2, match_index_1);
    x_2 = frame_2(1, match_index_2);
    y_2 = frame_2(2, match_index_2);
    
    if (strcmp(method, "normalized"))
        
        p_1 = T_1 * [x_1; y_1; 1]; % TODO: row or column vector?
        p_2 = T_2 * [x_2; y_2; 1];

        x_1 = p_1(1);
        x_2 = p_2(1);
        y_1 = p_1(2);
        y_2 = p_2(2);
        
    end
    
    A(i,:) = [x_1*x_2, x_1*y_2, x_1, y_1*x_2, y_1*y_2, y_1, x_2, y_2, 1];
    
end

F = fun_matrix(A, method);

end