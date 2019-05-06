close all
clear all
% vl_setup()

% load images
disp("Loading images");
directory = "House";
start_at = 1;
how_many = 49; %49 = all images
imgs = load_data(directory, how_many, start_at);

% for now pic the first two pictures: TODO: something else?
pic1 = imgs(1, :, :);
pic2 = imgs(49, :, :);


% do eight point algorithm
methods = ["standard", "normalized", "ransac"];
[F, p_1, p_2] = eight_point(pic1, pic2, methods(3));

%get epipolar line
get_epipolar_lines(F, reshape(pic1, 480, 512), reshape(pic2, 480, 512), p_1, p_2, 8, methods(3));


% % do eight point algorithm %%%%%%%%%%%%%%%%%%USE THIS
% for method = ["standard", "normalized", "ransac"]
%     [F, p_1, p_2] = eight_point(pic1, pic2, method);
% 
%     %get epipolar line
%     get_epipolar_lines(F, reshape(pic1, 480, 512), reshape(pic2, 480, 512), p_1, p_2, 8, method);
% end



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