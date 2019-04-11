function [R, t] = icp(A_1, A_2, dimensions)

disp("Start looking for R and t");

R = eye(dimensions);
t = zeroes(dimensions);
epsilon = 1.0e-3;

finished = false;
while ~finished
    
    [R, t] = icp_iteration(A_1, A_2, R, t);
    
    if (rms(A_1, A_2, psi, R, t) < epsilon)
       break 
    end
    
end

disp("Found an appropiate R and t");

end