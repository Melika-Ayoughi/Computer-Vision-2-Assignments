function F = fun_matrix(A, method, matches, frame_1, frame_2)	 % DOCSTRING_GENERATED
 % FUN_MATRIX		 [GEts the functional matrix]
 % INPUTS 
 %			A = see assignment
 %			method = standard, normalized or ransac
 % OUTPUTS 
 %			F = see assignment


if (strcmp(method, "standard") || strcmp(method, "normalized"))
    
    % get F
    [~, ~, V_t] = svd(A); % TODO not sure if we have to transpose V_t??
    F = reshape(V_t(:, end),3,3);
    
    % correction to F
    [U_f, D_f, V_tf] = svd(F);
    temp = diag(D_f);
    temp(end) = 0;
    F = U_f* diag(temp) * V_tf;

elseif (strcmp(method, "ransac"))
    %TODO: RANSAC implementation
    
    F = get_fun_RANSAC(matches, frame_1, frame_2, method);
else
    error("Method for fun matrix not recognized");
    
end

end