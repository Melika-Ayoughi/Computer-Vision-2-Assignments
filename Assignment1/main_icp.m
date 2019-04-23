

% just an example for loading the pcd files from data.
% pcds_data = all_pcd_data(); % commented out bc slow

% old data
% 3 * 6400 double
% load('./Data/source.mat');
% load('./Data/target.mat');


% take two random pictures
random_attempt_indices = randsample(100, 2);
source_total = get_specific_pcd_data(random_attempt_indices(1));
target_total = get_specific_pcd_data(random_attempt_indices(2));
source = source_total.pcd;
target = target_total.pcd;
source_normals = source_total.normals;
target_normals = target_total.normals;

% plot the before situation
figure(1)
scatter3(source(1,:),source(2,:),source(3,:),'red');hold;
scatter3(target(1,:),target(2,:),target(3,:),'blue');
title("before")

% define constants
epsilon = 0.0055;
sample_percentage = 0.1;

% lists to loop through for experiments
stabilities = [0]; % TO DO - stability is about convergence of the algorithm dependent on initial condition.
noise_levels = [0]; % TO DO - tolerance to noise is about convergence of the algorithm with input data with noise. You can imagine data is captured by a sensor. In the ideal case you will obtain exact point cloud, however sensor is not precise, therefore there will be noise in measurement. Therefore we ask you to evaluate how ICP is robust against those kind of issuses.
methods = fliplr(["all_points", "random_iterative_subsamp", "uniform_subsamp", "informed_iterative_subsamp"]); 

% output collecter
data = [];


for i = 1:numel(methods)
    
    method = methods(i); 
    
    for j = 1:numel(stabilities)
        
        stability = stabilities(j); % TO DO: 
        
        for k = 1:numel(noise_levels)
    
            noise = noise_levels(k); % TO DO: 
            
            disp("Started: " + method + " noise:" + noise + " stability:" + stability)
            
            tic % starts counter
            
            [R, t, error_final, iterations] = icp(source, target, epsilon, method, sample_percentage, source_normals, target_normals);
            
            time = toc;
            
            accuracy = 0; %TO DO: don't know how to measure accuracy in this context
            
            % save data in dictionary
            local_struct = struct();
            local_struct.time = time;
            local_struct.iterations = iterations;
            local_struct.error = error_final;
            local_struct.stability = stability;
            local_struct.noise = noise;
            local_struct.accuracy = accuracy;
            local_struct.method = method;
            
            % save dictionary in final data output table
            data = [data, local_struct];
            
            % plot
            d = R*source +t;
            figure(i+1)
            scatter3(target(1,:),target(2,:),target(3,:),'blue');hold;
            scatter3(d(1,:),d(2,:),d(3,:),'green');
            title("after with method-"+strrep(method, "_", " ") + " noise-"+noise+" stability-"+stability)
            
        end
    end
end

save("./results_icp/results"+string(datetime())+".mat", "data");



