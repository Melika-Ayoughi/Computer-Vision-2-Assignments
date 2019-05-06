function [F, p_1, p_2] = eight_point(picture_1, picture_2, method, normalized, s_threshold, m_threshold)	 % DOCSTRING_GENERATED
 % EIGHT_POINT		 [Does eight oint algorithm]
 % INPUTS 
 %			picture_1 = ..
 %			picture_2 = ..
 %			method = standard or ransac
 %          normalized = 1 or 0
 % OUTPUTS 
 %			F = ..

% find points
[frame_1,descriptors_1] = vl_sift(single(reshape(picture_1, 480, 512)),'PeakThresh', s_threshold) ;
[frame_2,descriptors_2] = vl_sift(single(reshape(picture_2, 480, 512)),'PeakThresh', s_threshold) ;

% match
[matches, ~] = vl_ubcmatch(descriptors_1, descriptors_2, m_threshold) ; % Added threshold to matchpoint extraction

% get actual matrix
[F, p_1, p_2] = fun_matrix(normalized, method, matches, frame_1, frame_2);

end