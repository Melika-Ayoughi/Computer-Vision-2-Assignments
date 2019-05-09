function [s, m] = calculate_s_m(D, mode, eliminate_affine)	 % DOCSTRING_GENERATED
 % CALCULATE_S_M		 [calculates structure and motion of matrix D]
 % if eliminate_affine is true, affine ambiguity is eliminated
 % mode = defines the mode to divide W in SVD

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

% Eliminate affine ambiguity
if eliminate_affine==1
    % solve for L -> MLM^T = I
    % retreive c and c^-1 from L with cholesky decomposition
    % s = c^-1 * s
    pm = pinv(m);
    pmt = pinv(m');
    L = pm * (eye(size(pm,2))) * pmt;

    
    C = chol(L);
    m = m * C;
    s = inv(C) * s;
end
end

