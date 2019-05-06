function [F] = eight_point(picture_1, picture_2, method)	 % DOCSTRING_GENERATED
 % EIGHT_POINT		 [Does eight oint algorithm]
 % INPUTS 
 %			picture_1 = ..
 %			picture_2 = ..
 %			method = ..
 % OUTPUTS 
 %			F = ..

 
s_threshold = 5;
m_threshold = 5;
 
 
% find points
% [frame_1,descriptors_1] = vl_sift(single(reshape(picture_1, 480, 512))) ;
% [frame_2,descriptors_2] = vl_sift(single(reshape(picture_2, 480, 512))) ;

%ADDED threshold to keypoint extraction
[frame_1,descriptors_1] = vl_sift(single(reshape(picture_1, 480, 512)),'PeakThresh', s_threshold) ;
[frame_2,descriptors_2] = vl_sift(single(reshape(picture_2, 480, 512)),'PeakThresh', s_threshold) ;

% filter
[frame_1,descriptors_1] = filter_feature_points(frame_1 ,descriptors_1);
[frame_2,descriptors_2] = filter_feature_points(frame_2 ,descriptors_2);

% match
% [matches, scores] = vl_ubcmatch(descriptors_1, descriptors_2) ; % todo: maybe we can use the scores for something about filtering???
[matches, scores] = vl_ubcmatch(descriptors_1, descriptors_2, m_threshold) ; % Added threshold to matchpoint extraction



% init A
A = zeros(size(matches,2), 9);

% get T matrices if normalized
if (strcmp(method, "normalized"))

    [T_1, T_2] = find_T_matrix(matches, frame_1, frame_2);

end

%Initialize points (ADDED THIS)

p_1 = [];
p_2 = [];

for i = 1:size(matches,2)
    
    % find points from matches
    match_index_1 = matches(1, i);
    match_index_2 = matches(2, i); 
    x_1 = frame_1(1, match_index_1);
    y_1 = frame_1(2, match_index_1);
    x_2 = frame_2(1, match_index_2);
    y_2 = frame_2(2, match_index_2);
    
    % translate and rotate if needed
    if (strcmp(method, "normalized"))
        
       
        p_1 = T_1 * [x_1; y_1; 1]; % TODO: row or column vector?
        p_2 = T_2 * [x_2; y_2; 1];

        x_1 = p_1(1);
        x_2 = p_2(1);
        y_1 = p_1(2);
        y_2 = p_2(2);
        
    else
        
        %Get points of matches
        p_1 = [p_1;[x_1, y_1, 1]]; %ADDED THIS cause we need it for epipolar lines
        p_2 = [p_2;[x_2, y_2, 1]];
        
    end
    
    % get A matrix entry
    A(i,:) = [x_1*x_2, x_1*y_2, x_1, y_1*x_2, y_1*y_2, y_1, x_2, y_2, 1];
    
end


% get actual matrix
% F = fun_matrix(A, method);
F = fun_matrix(A, method, matches, frame_1, frame_2);

% denormalize if needed
if (strcmp(method, "normalized"))

    F = T_2' * F * T_1;

end

% TODO: is there more?


%get epipolar line
get_epipolar_lines(F, reshape(picture_1, 480, 512), reshape(picture_2, 480, 512), p_1, p_2, 8);

end