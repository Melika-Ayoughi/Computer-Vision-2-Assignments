

% just an example for loading the pcd files from data.
% pcds_data = all_pcd_data(); % commented out bc slow

% % old data
% % 3 * 6400 double
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
epsilon = 0.00025;
sample_percentage = 0.4;

% lists to loop through for experiments
noise_levels = [0];%, 1, 2]; % tolerance to noise is about convergence of the algorithm with input data with noise. You can imagine data is captured by a sensor. In the ideal case you will obtain exact point cloud, however sensor is not precise, therefore there will be noise in measurement. Therefore we ask you to evaluate how ICP is robust against those kind of issuses.
methods = ["uniform_subsamp"];%, "random_iterative_subsamp", "informed_iterative_subsamp", "all_points"]; 
stability_R = [eye(3); [1,0,0;0,0.7,-0.7;0,0.7,0.7]; [0.7,0,0.7;0,1,0;-0.7,0,0.7]; [0.7,-0.7,0;0.7,0.7,0;0,0,1]; [1,0,0;0,0,-1;0,1,0]; [0,0,1;0,1,0;-1,0,0]; [0,-1,0;1,0,0;0,0,1]; [1,0,0;0,-1,0;0,0,-1]; [-1,0,0;0,1,0;0,0,-1]; [-1,0,0;0,-1,0;0,0,1]]; %rotate along x,y,z, 45, 90, 180 degrees
stability_t = [zeros(3,1); ones(3,1); [1;0;0]; [0;1;0]; [0;0;1]];

% output collecter
data = [];

for i = 1:numel(methods)
    
    method = methods(i); 
    new_source = [];
    for j = 1:(size(stability_R, 1)/3) %looping though stabilities_R        
        for f = 1:(size(stability_t,1)/3) %looping though stabilities_t
            new_source = add_instability(source, stability_R(j:j+2,:), stability_t(f:f+2,:));
        
            for k = 1:numel(noise_levels) %looping though noises

                noise = noise_levels(k);
                new_source = add_noise(new_source, 0, noise);

                disp("Started: " + method + " noise:" + noise + " stability index:" + j)

                tic % starts counter

                [R, t, error_final, iterations] = icp(new_source, target, epsilon, method, sample_percentage, source_normals, target_normals);

                time = toc;

                % save data in dictionary
                local_struct = struct();
                local_struct.time = time;
                local_struct.iterations = iterations;
                local_struct.error = mean(error_final);
                local_struct.stability_t = stability_t(f:f+2,:);
                local_struct.noise = noise;
                local_struct.method = method;
                local_struct.stability_R = stability_R(f:f+2,:);

                % save dictionary in final data output table
                data = [data, local_struct];

                % plot
                d = R * source + t;
                figz = figure(i+1);
                scatter3(target(3,:), target(1,:), target(2,:),'blue');hold;
                scatter3(d(3,:), d(1,:), d(2,:),'green');hold;
                figure_title = "Method-"+strrep(method, "_", " ") + " noise-"+noise+" stability-index"+j;
                title(figure_title)
                saveas(figz, "./results_icp/"+ figure_title +".png");
                close all;
            end
        end
    end
end

save("./results_icp/results"+string(datetime())+".mat", "data");



