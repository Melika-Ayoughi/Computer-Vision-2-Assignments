function [s, m] = calculate_s_m(D, mode)	 % DOCSTRING_GENERATED
 % CALCULATE_S_M		 [add function description here]
 % INPUTS 
 %			D = ..
 %			mode = ..
 % OUTPUTS 
 %			s = ..
 %			m = ..



%normalize M
D = D - mean(D,2); 
[U,W,V] = svd(D);

% reduce the rank to 3
U_3 = U(:, 1:3);
W_3 = W(1:3, 1:3); 
V_3 = V(:, 1:3);

if mode == 1
    m = U_3 * sqrt(W_3);
    s = sqrt(W_3) * V_3';
elseif mode == 2
    m = U_3;
    s = W_3 * V_3';
end

end

