function [R, t] = icp(A1, A2, dimensions)
% 1. Initialize R = I (identity matrix), t = 0. -> whatsize?
% 2. Find the closest points for each point in the base point set (A1) from the target point set (A2) using
% brute-force approach.
% 3. Refine R and t using Singular Value Decomposition
% 4. Go to step 2 unless RMS is unchanged.
 
disp("Start looking for R and t");

R = eye(dimensions);
t = zeroes(dimensions);
epsilon = 1.0e-3;

finished = false;
while ~finished
    
    [R, t] = icp_iteration(A1, A2, R, t);
    [matches] = find_match(A1, A2, R, t);
    
    if (rms(matches(1:3,:), matches(4:6,:), R, t) < epsilon)
       break 
    end
    
end

disp("Found an appropiate R and t");

end