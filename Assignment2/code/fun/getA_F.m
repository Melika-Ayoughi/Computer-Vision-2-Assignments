function [A, F, p_1, p_2] = getA_F(matches, frame_1, frame_2, normalized)	 % DOCSTRING_GENERATED
 % GETA_F		 [extracts the A and F matrix, as well as the used points, for the eight point algorithm]
 % INPUTS 
 %			matches = matched indices
 %			frame_1 = sift-frame of picture 1
 %			frame_2 = sift-frame of picture 2
 %			normalized = boolean
 % OUTPUTS 
 %			A = eight point A matrix
 %			F = eight point F matrix
 %			p_1 = points of pic 1
 %			p_2 = points of pic 2



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
    
    % normalize points (T = identity if not normalizing)
    z_1 = (T_1*[x_1; y_1; 1])';
    z_2 = (T_2*[x_2; y_2; 1])';

    % save points unormalized
    p_1 = [p_1;[x_1, y_1, 1]]; 
    p_2 = [p_2;[x_2, y_2, 1]];
    
    % get normalized points
    x_1 = z_1(1);
    y_1 = z_1(2);
    x_2 = z_2(1);
    y_2 = z_2(2);
    
    % generate A-entry
    A(i,:) = [x_1*x_2, x_1*y_2, x_1, y_1*x_2, y_1*y_2, y_1, x_2, y_2, 1];  

end

% find F as last column of V
[~, ~, V_t] = svd(A);
F = reshape(V_t(:, end), 3, 3);

% set lowest singular value to zero
[U_f, D_f, V_tf] = svd(F);
temp = diag(D_f);
temp(end) = 0;
F = U_f* diag(temp) * V_tf';
     
% denormalize F
F = T_2' * F * T_1;

end