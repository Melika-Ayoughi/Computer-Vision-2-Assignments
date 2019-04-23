function [R_final, t_final, error, iterations] = icp(A1, A2, epsilon, method, sample_percentage, source_normals, target_normals)

 
disp("Start looking for R and t");

% returned R and t should be big matrix multiplications consisting of every step in between
R_final = eye(3); 
t_final = zeros(3,1);

% init the iteration-wise ones
R = R_final;
t = t_final;

% if this method is called use some subsampling
if (strcmp(method, "uniform_subsamp"))
    A1 = subsample(A1, sample_percentage, "uniform", 0);
    A2 = subsample(A1, sample_percentage, "uniform", 0);
end

iterations = 0;
finished = false;
while ~finished
    
    iterations = iterations + 1;
    
    % get sample for iteration
    if (strcmp(method, "all_points") || strcmp(method, "uniform_subsamp"))
        A1_local = A1;
        A2_local = A2;
    elseif(strcmp(method, "random_iterative_subsamp"))
        A1_local = subsample(A1, sample_percentage, "uniform", 0);
        A2_local = subsample(A2, sample_percentage, "uniform", 0);
    elseif(strcmp(method, "informed_iterative_subsamp"))
        A1_local = subsample(A1, sample_percentage, "informed", source_normals);
        A2_local = subsample(A2, sample_percentage, "informed", target_normals);
    else
        error("wrong keyword in sample method: "+method);
    end
    
    % find matches for every point
    [matches] = find_match(A1_local, A2_local);
    
    % check exit condition
    error = rms(matches(1:3,:), matches(4:6,:), R, t);
    
    if (mean(error) < epsilon)
       break 
    end
    
    % do iteration
    [R, t] = icp_iteration(matches(1:3,:), matches(4:6,:));
    
    % update global parameters 
    R_final = R * R_final;
    t_final = R * t_final + t;
    
    % and data
    A1 = R*A1 +t;
    source_normals = R*source_normals;
    
    disp("progress information: error ="+mean(error)+ " in iteration="+iterations);
end

disp("Found an appropiate R and t");
end