function [F, p_1, p_2] = fun_matrix(normalized, method, matches, frame_1, frame_2)		 % DOCSTRING_GENERATED
 % FUN_MATRIX		 [add function description here]
 % INPUTS 
 %			normalized = ..
 %			method = ..
 %			matches = ..
 %			frame_1 = ..
 %			frame_2 = ..
 % OUTPUTS 
 %			F = ..
 %			p_1 = ..
 %			p_2 = ..






if (strcmp(method, "standard") )
    
    [~, F, p_1, p_2] = getA_F(matches, frame_1, frame_2, normalized);

elseif (strcmp(method, "ransac"))

    [F, p_1, p_2] = get_fun_RANSAC(matches, frame_1, frame_2, method, normalized);
    
else
    
    error("Method for fun matrix not recognized");
    
end



end