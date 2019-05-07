function [F, p_1, p_2] = fun_matrix(normalized, method, matches, frame_1, frame_2)		 % DOCSTRING_GENERATED
 % FUN_MATRIX		 [gets the fundamental matrix]
 % INPUTS 
 %			normalized = boolean
 %			method = standard or ransac
 %			matches = feature point matches (indices) from SIFT
 %			frame_1 = feature points from SIFT of pic1
 %			frame_2 = feature points from SIFT of pic2
 % OUTPUTS 
 %			F = fundamental matrix
 %			p_1 = points from pic1
 %			p_2 =  points from pic2






if (strcmp(method, "standard") )
    
    [~, F, p_1, p_2] = getA_F(matches, frame_1, frame_2, normalized);

elseif (strcmp(method, "ransac"))

    [F, p_1, p_2] = get_fun_RANSAC(matches, frame_1, frame_2, method, normalized);
    
else
    
    error("Method for fun matrix not recognized");
    
end



end