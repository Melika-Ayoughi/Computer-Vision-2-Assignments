function [F, p_1, p_2] = get_fun_RANSAC(matches, frame_1, frame_2, ~, normalized)	 % DOCSTRING_GENERATED
 % GET_FUN_RANSAC		 [add function description here]
 % INPUTS 
 %			matches = indexes of the frames of the matched points
 %			frame_1 = frames of extracted interest points of 1st image 
 %			frame_2 = frames of extracted interest points of 2nd image
 %			method = self explanatory
 %			normalized = True or False (1 or 0)
 % OUTPUTS 
 %			F = fundamental matrix
 %			p_1 = homogenous coordinates of first image
 %			p_2 = homogenous coordinates of second image

 
 
 
%No. of iterations
N = 10000; 

% No. of point correspondences
P = 8; 

%Threshold
T = 0.0001; 

%initialize
best_n_inliners = zeros(P,1);
permutations = randperm(size(matches,2));
subset = permutations(1:P);
best_inliners_idx  = subset;

for n = 1:N
    
    % get random subset of size N from frames with matching features
    permutations = randperm(size(matches,2));
    subset = permutations(1:P);
    
    % get a fundamental matrix for the subset
    [~, F, ~, ~] = getA_F(matches(:, subset), frame_1, frame_2, normalized);
    
    %Get all matching points
    [~, ~, p_1, p_2] = getA_F(matches, frame_1, frame_2, normalized);
    

    % get Sampson distance for each point
    
    % initialize distance vector
    d = zeros(size(p_1,1),1);
    
    % get distances
    for i = 1:size(p_1,1)
        Fp_1 = F * p_1(i,:)';
        Fp_2 = F' * p_2(i,:)'; 
        numerator = (p_2(i,:) * F * p_1(i,:)')^2;
        denominator = (Fp_1(1))^2 + (Fp_1(2))^2 + (Fp_2(1))^2 + (Fp_2(2))^2;
        d(i) = numerator/denominator;        
    end
    
    % get number of inliners less than threshold 
    current_n_inliners = d < T;
       
    if sum(current_n_inliners) > sum(best_n_inliners)
        best_n_inliners = current_n_inliners;
        best_inliners_idx = subset;
    end

end

% get final values
[~, F, ~, ~] = getA_F(matches(:, best_inliners_idx), frame_1, frame_2, normalized);     
    
end
