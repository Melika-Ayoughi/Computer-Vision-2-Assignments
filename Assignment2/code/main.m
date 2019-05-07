close all
clear all
% vl_setup()

% load images
disp("Loading images");
directory = "House";
start_at = 1;
how_many = 49; %49 = all images
imgs = load_data(directory, how_many, start_at);

% for now pick the first two pictures: TODO: something else?
pic1 = imgs(1, :, :);
pic2 = imgs(49, :, :);


% do eight point algorithm
methods = ["standard", "ransac"];
normalization = [0, 1];

s_threshold = 5;
m_threshold = 5;

plot_counter = 1;

% initialize dictionary for F's computed using different methods
Fs = struct;

for method = methods
    
    for norm = normalization
    
        [F, p_1, p_2] = eight_point(pic1, pic2, method, norm, s_threshold, m_threshold);
        
        Fs.(string(method) + string(norm)) = [F];
                    
    end

end

%plot epipolar lines
get_epipolar_lines(Fs, reshape(pic1, 480, 512), reshape(pic2, 480, 512), p_1, p_2, 8); 



% % CHAINING
% %set sift threshold and matching threshold
% s_threshold = 1.5;
% m_threshold = 1.5;
% 
% %get point view matrix
% disp('  ')
% disp('---------------------------')
% disp('Computing PV matrix')
% disp('s_thresh = ' + string(s_threshold) + ', m_thresh = ' + string(m_threshold)) 
% disp('---------------------------')
% PV = get_point_view_matrix(imgs, s_threshold, m_threshold);
% visualize_PV(PV)
% 
% %import given PV (its as dense as possible..)
% M=dlmread('PointViewMatrix.txt');
% visualize_PV(M)