function [A, F, p_1, p_2] = getA_F(matches, frame_1, frame_2, normalized)	 % DOCSTRING_GENERATED
 % GETA_F		 [add function description here]
 % INPUTS 
 %			matches = ..
 %			frame_1 = ..
 %			frame_2 = ..
 %			normalized = ..
 % OUTPUTS 
 %			A = ..
 %			F = ..
 %			p_1 = ..
 %			p_2 = ..



% init A
P = size(matches,2);
A = zeros(P, 9);

[T_1, T_2] = find_T_matrix(matches, frame_1, frame_2, normalized);

%initialize points of matches
p_1 = [];
p_2 = [];

for i = 1:P
    
    % find points from matches
    match_index_1 = matches(1, i);
    match_index_2 = matches(2, i); 
    x_1 = frame_1(1, match_index_1);
    y_1 = frame_1(2, match_index_1);
    x_2 = frame_2(1, match_index_2);
    y_2 = frame_2(2, match_index_2);
    
    z_1 = (T_1*[x_1; y_1; 1])';
    z_2 = (T_2*[x_2; y_2; 1])';

    p_1 = [p_1;[x_1, y_1, 1]]; 
    p_2 = [p_2;[x_2, y_2, 1]];
    
    x_1 = z_1(1);
    y_1 = z_1(2);
    x_2 = z_2(1);
    y_2 = z_2(2);
    
    A(i,:) = [x_1*x_2, x_1*y_2, x_1, y_1*x_2, y_1*y_2, y_1, x_2, y_2, 1];  

end

[~, ~, V_t] = svd(A);
F = reshape(V_t(:, end), 3, 3);

[U_f, D_f, V_tf] = svd(F);
temp = diag(D_f);
temp(end) = 0;
F = U_f* diag(temp) * V_tf';
     
%Normalize
F = T_2' * F * T_1;

end