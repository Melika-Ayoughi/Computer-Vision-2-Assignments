function F = get_fun_RANSAC(matches, frame_1, frame_2, method)
 % get_fun_RANSAC		 [Estimates the Fundamental matrix]
 % INPUTS 
 %			matches = indices of matches
 %			frame_1 = sift locations 
 %			frame_2 = sift locations 
 %          method = "standard", "normalized", "ransac"


%initialize parameters

N = 10000; %No. of iterations
P = 8; % No. of point correspondences
T = 0.001; %Threshold
best_n_inliners = zeros(P,1);

%initialize A
A = zeros(P, 9);

for n = 1:N
    
    %get random subset of size N from frames with matching features
    permutations = randperm(size(matches,2));
    subset = permutations(1:P);
    best_inliners_idx = subset;
        
    %get corresponding point coordinates
    x_1  = frame_1(1,matches(1,subset));
    x_2 = frame_2(1,matches(2,subset));
    y_1  = frame_1(2,matches(1,subset));
    y_2 = frame_2(2,matches(2,subset)); 
    
    %initialize points of matches
    p_1 = [];
    p_2 = [];
    
    %get T matrices if normalized
    [T_1, T_2] = find_T_matrix(matches(:,subset), frame_1, frame_2);
%     
    for i = 1:P
        %Get A using match coordinates
        A(i,:) = [x_1(i)*x_2(i), x_1(i)*y_2(i), x_1(i), y_1(i)*x_2(i), y_1(i)*y_2(i), y_1(i), x_2(i), y_2(i), 1];
        %Get points of matches
        p_1 = [p_1;(T_1*[x_1(i); y_1(i); 1])']; %APPLIED NORMALIZATION!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        p_2 = [p_2;(T_2*[x_2(i); y_2(i); 1])'];
    end    
    
    %get functional matrix    
    [~, D_t, V_t] = svd(A);
    [~,idx] = min(diag(D_t));
    F = V_t(:, idx);
    F = reshape(V_t(:, end),3,3);
    
    
    %Normalize
    F = T_2' * F * T_1;
    
    %get Sampson distance
    
    %initialize distance vector
    d = zeros(P,1);
    
    %get distances
    for i = 1:P
        Fp_1 = F * p_1(i,:)';
        Fp_2 = F' * p_2(i,:)'; 
        numerator = (p_2(i,:) * F * p_1(i,:)')^2;
        denominator = (Fp_1(1))^2 + (Fp_1(2))^2 + (Fp_2(1))^2 + (Fp_2(2))^2;
        d(i) = numerator/denominator;        
    end
    
    %get number of inliners less than threshold 
    current_n_inliners = d < T;
    
    if sum(current_n_inliners) > sum(best_n_inliners)
        best_n_inliners = current_n_inliners;
        best_inliners_idx = subset;
    end

end
  
%get A for best 8 points
A = getA(matches(:,best_inliners_idx), frame_1, frame_2, method);
 
%get functional matrix for best 8 points   
[~, D_t, V_t] = svd(A);
[~,idx] = min(diag(D_t));
F = V_t(:, idx);
F = reshape(V_t(:, end),3,3);        
    
end
